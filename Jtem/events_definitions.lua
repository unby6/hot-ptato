-- Scenario by default
HotPotato.EventStep({
	key = "nothing_1",
	loc_txt = {
		-- Loc key: G.localization.Descriptions.EventSteps.hpot_nothing_1
		text = {
			"Looks like there's nothing here...",
		},
		choices = {
			go = "...Go?",
		},
	},
	config = {
		-- Here you can specify all values you need for this step
		extra = {},
	},
	get_choices = function(self, event)
		return {
			{
				-- Loc key: G.localization.misc.EventChoices.hpot_nothing_1_go
				-- <modprefix>_<stepkey>_<key>
				key = "go",
				button = event.finish_scenario,
			},
		}
	end,
})
HotPotato.EventScenario({
	key = "nothing",
	hide_image_area = true,
	starting_step_key = "hpot_nothing_1",

	loc_txt = {
		-- Loc key: G.localization.Descriptions.EventScenarios.hpot_nothing
		name = { "Nothing happened..." }
	},

	weight = 0,
	in_pool = function()
		return false
	end,
	no_collection = true,
})

-- Test scenario
HotPotato.EventStep({
	key = "test_1",

	config = {
		extra = {
			rich = 25,
			gain = 5,
			gain_rich = 10,
		},
	},

	get_choices = function(self, event)
		return {
			{
				key = "lose",
				button = function()
					event.start_step("hpot_test_2")
				end,
			},
			{
				key = "gain_rich",
				loc_vars = { self.config.extra.rich },
				button = function()
					ease_dollars(self.config.extra.gain_rich)
					-- Object which resets between event scenarios
					-- So you can use it to transfer data between steps, if you need
					event.ability = self.config.extra.gain_rich
					event.start_step("hpot_test_3")
				end,
				func = function()
					return G.GAME.dollars >= self.config.extra.rich
				end,
			},
			{
				key = "gain",
				button = function()
					ease_dollars(self.config.extra.gain)
					event.ability = self.config.extra.gain
					event.start_step("hpot_test_3")
				end,
			},
		}
	end,
	start = function(self, event)
		event.display_lines(2, true)
		delay(1)
		local x, y = event.get_image_center()
		local jimbo_card = Card_Character({
			x = x,
			y = y,
			center = G.P_CENTERS.j_joker,
		})
		event.image_area.children.jimbo_card = jimbo_card
		event.display_lines(1, true)
		jimbo_card:say_stuff(3)
		delay(1)
		event.display_lines(1, true)
		jimbo_card:say_stuff(2)
		G.FUNCS.draw_from_deck_to_hand(3)
	end,
	finish = function(self, event)
		local jimbo_card = event.image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})
HotPotato.EventStep({
	key = "test_2",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function()
		if #G.hand.cards > 0 then
			SMODS.destroy_cards(G.hand.cards)
		end
	end,
})
HotPotato.EventStep({
	key = "test_3",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	loc_vars = function(self, event)
		return { event.ability.money_gain }
	end,
})

HotPotato.EventScenario({
	key = "test",
	starting_step_key = "hpot_test_1",
	in_pool = function()
		return false
	end,
	no_collection = true,
})

--------- Example above

local moveon = function()
	return {
		key = "hpot_general_move_on",
		no_prefix = true,
		button = hpot_event_end_scenario,
	}
end

local Character = function(key, container_key, dx, dy)
	dy = dy or 0
	dx = dx or 0
	container_key = container_key or "jimbo_card"
	local x, y = get_hpot_event_image_center()
	local card = Card_Character({
		x = x + dx,
		y = y + dy,
		center = key,
	})
	G.hpot_event_ui_image_area.children[container_key] = card
	return card
end

local Remove = function(character_key)
	character_key = character_key or "jimbo_card"
	local jimbo_card = G.hpot_event_ui_image_area.children[character_key]
	if jimbo_card then
		G.E_MANAGER:add_event(Event({
			func = function()
				jimbo_card:remove()
				G.hpot_event_ui_image_area.children[character_key] = nil
				return true
			end,
		}))
	end
end

-- Trade

HotPotato.EventStep({
	key = "pelter",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_multi_tradenone",
				no_prefix = true,
				button = event.finish_scenario,
			},
			{
				key = "hpot_multi_tradecard",
				no_prefix = true,
				loc_vars = { localize { type = 'name_text', key = "c_hpot_imag_stars", set = "imaginary" } },
				func = function()
					return next(SMODS.find_card("c_hpot_imag_stars"))
				end,
				button = function()
					SMODS.find_card("c_hpot_imag_stars")[1]:start_dissolve()
					G.hand:change_size(1)
					event.start_step("hpot_tradedreams")
				end,
			},
			{
				key = "hpot_multi_tradecard",
				no_prefix = true,
				loc_vars = { localize { type = 'name_text', key = "c_hpot_imag_duck", set = "imaginary" } },
				func = function()
					return next(SMODS.find_card("c_hpot_imag_duck"))
				end,
				button = function()
					SMODS.find_card("c_hpot_imag_duck")[1]:start_dissolve()
					G.consumeables:change_size(1)
					event.start_step("hpot_tradeduck")
				end,
			},
		}
	end,
})

HotPotato.EventStep {
	key = "tradedreams",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
		Character("c_hpot_imag_stars")
	end,
	finish = function(self, event)
		Remove()
	end,
}

HotPotato.EventStep {
	key = "tradeduck",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
		Character("c_hpot_imag_duck")
	end,
	finish = function(self, event)
		Remove()
	end,
}

HotPotato.EventScenario {
	key = "trade1",
	domains = { reward = true },
	starting_step_key = "hpot_pelter",
	hotpot_credits = {
		idea = { "Squidguset" },
		code = { "Squidguset" },
		team = { "Jtem" },
	},
	in_pool = function(self)
		return not not (next(SMODS.find_card("c_hpot_imag_duck")) or next(SMODS.find_card("c_hpot_imag_stars")))
	end
}

-- Porch Pirates

HotPotato.EventStep({
	key = "porch_pirate_1",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					event.start_step("hpot_porch_pirate_2")
				end,
			},
		}
	end,
	start = function(self, event)
		local pirate_card = Character("j_swashbuckler")
		pirate_card.children.particles.colours = { G.C.RED, G.C.RED, G.C.RED }
		pirate_card.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				pirate_card.T.scale = pirate_card.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event) end,
})
HotPotato.EventStep({
	key = "porch_pirate_2",
	config = {
		extra = {
			remove = 10,
		},
	},
	get_choices = function(self, event)
		return {
			{
				key = "hpot_porch_pirate_protect",
				no_prefix = true,
				button = function()
					ease_dollars(-self.config.extra.remove)
					event.start_step("hpot_porch_pirate_good")
				end,
			},
			{
				key = "hpot_porch_pirate_leave",
				no_prefix = true,
				button = function()
					if pseudorandom('fuck_you') < 0.5 then
						event.start_step("hpot_porch_pirate_bad")
					else
						event.start_step("hpot_porch_pirate_phew")
					end
				end,
			},
		}
	end,
	loc_vars = function(self)
		return { self.config.extra.remove }
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
		Remove()
	end,
})
HotPotato.EventStep({
	key = "porch_pirate_good",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function(self, event)
		if not G.hp_jtem_delivery_queue then
			hotpot_jtem_init_extra_shops_area()
			hotpot_delivery_refresh_card()
		end
		---@type Card
		local card = pseudorandom_element(G.hp_jtem_delivery_queue.cards,
			'porch_pirate_eternal_' .. G.GAME.round_resets.ante)
		if card then
			card:set_perishable(false)
			card:set_eternal(true)
			local delivery = copy_card(card)
			local delivery_obj = card.hp_delivery_obj
			if delivery_obj then
				delivery_obj.extras = delivery_obj.extras or {}
				delivery_obj.extras.eternal = true
			end
			local x, y = event.get_image_center()
			local jimbo_card = Card_Character({
				x = x,
				y = y,
				center = delivery.config.center.key,
			})
			event.image_area.children.jimbo_card = jimbo_card
			hpot_event_display_lines(1, true)
			delay(1)
			G.E_MANAGER:add_event(Event {
				func = function()
					jimbo_card.children.card:set_eternal(true)
					jimbo_card.children.card:juice_up(0.3, 0.3)
					play_sound('gold_seal', 1.2, 0.4)
					return true
				end
			})
		end
	end,

	finish = function(self, event)
		local jimbo_card = event.image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event {
				func = function()
					jimbo_card.children.card:start_dissolve()
					return true
				end
			})
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})
HotPotato.EventStep({
	key = "porch_pirate_bad",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		-- make sure the queue exists first
		if not G.hp_jtem_delivery_queue then
			hotpot_jtem_init_extra_shops_area()
			hotpot_delivery_refresh_card()
		end
		local delivery = pseudorandom_element(G.hp_jtem_delivery_queue.cards,
			'porch_pirate_steal_' .. G.GAME.round_resets.ante)
		if delivery then
			local remove = {}
			for k, v in pairs(G.GAME.hp_jtem_delivery_queue) do
				if v == delivery.hp_delivery_obj then
					remove[k] = true
				end
			end
			for i = #G.GAME.hp_jtem_delivery_queue, 1, -1 do
				if remove[i] then
					table.remove(G.GAME.hp_jtem_delivery_queue, i)
				end
			end
			remove = {}
			local x, y = event.get_image_center()
			local jimbo_card = Card_Character({
				x = x,
				y = y,
				center = delivery.config.center.key,
			})
			event.image_area.children.jimbo_card = jimbo_card
			hpot_event_display_lines(2, true)
			delay(1)
			jimbo_card:say_stuff(3)
			hpot_event_display_lines(1, true)
			G.E_MANAGER:add_event(Event {
				func = function()
					jimbo_card.children.card:start_dissolve()
					return true
				end
			})
			delivery:remove()
		end
	end,
	finish = function(self, event)
		local jimbo_card = event.image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})
HotPotato.EventStep({
	key = "porch_pirate_phew",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event) end,
	finish = function(self) end,
})

HotPotato.EventScenario {
	key = "porch_pirate",
	domains = { occurence = true },
	starting_step_key = "hpot_porch_pirate_1",
	hotpot_credits = {
		idea = { "Haya" },
		code = { "Haya" },
		team = { "Jtem" },
	},
	in_pool = function()
		return G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue > 0
	end
}

-- Taxes
-- Not finished

local function taxcalc(d)
	d = d or 0
	if not G.GAME then return 0 end
	G.GAME.CurrentInflation = G.GAME.CurrentInflation or 0.5
	return d * (G.GAME.CurrentInflation * (1 + (1 / 12.4))) + math.sqrt(G.GAME.CurrentInflation)
end

HotPotato.EventStep {
	key = "taxman",
	config = { extra = { cost = 50, req = 10 } },
	get_choices = function(self)
		return {
			{
				key = "taxespay",
				loc_vars = {},
				func = function()
					return G.GAME.dollars >= G.GAME.dollars - taxcalc(G.GAME.dollars)
				end,
				button = function()
					ease_dollars(-taxcalc(G.GAME.dollars))
				end,
			},
			{
				key = "bribe",
				func = function()
					return G.GAME.dollars >= self.config.extra.req
				end,
				button = function()
					ease_dollars(-self.config.extra.req)
				end
			},
			{
				key = "debt",
				button = function()
					ease_dollars(-(G.GAME.dollars + pseudorandom("hotpot_taxes", 15, 25)))
				end
			}

		}
	end,
	start = function(self, scenario, previous_step)
		Character("j_hpot_bank_teller")
	end,
}

-- Postman

HotPotato.EventStep({
	key = "postman_1",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					if not G.hp_jtem_delivery_queue then
						hotpot_jtem_init_extra_shops_area()
						hotpot_delivery_refresh_card()
					end
					---@type Card
					local card = pseudorandom_element(G.hp_jtem_delivery_queue.cards,
						'postman_retrieve_' .. G.GAME.round_resets.ante)
					if card then
						local delivery = card.hp_delivery_obj
						remove_element_from_list(G.GAME.hp_jtem_delivery_queue, delivery)
						card:remove()
						local cct = { key = delivery.key, skip_materialize = true }
						for k, v in pairs(delivery.create_card_args) do
							cct[k] = v
						end
						local c = SMODS.add_card(cct)
						if delivery.extras then
							for k, v in pairs(delivery.extras) do
								c.ability[k] = v
							end
						end
					end
					event.finish_scenario()
				end,
			},
		}
	end,
	start = function(self, event)
		local pirate_card = Character("j_shortcut")
		pirate_card.children.particles.colours = { G.C.RED, G.C.RED, G.C.RED }
		pirate_card.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				pirate_card.T.scale = pirate_card.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
		local jimbo_card = event.image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})

HotPotato.EventScenario {
	key = "postman",
	domains = { reward = true },
	starting_step_key = "hpot_postman_1",
	in_pool = function()
		return G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue > 0 and G.jokers and
			#G.jokers.cards < G.jokers.config.card_limit
	end,
	hotpot_credits = {
		idea = { "MissingNumber" },
		code = { "Haya", "SleepyG11" },
		team = { "Jtem" },
	},
}

-- Free voucher yahoo

HotPotato.EventStep({
	key = "voucher_1",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_voucher_pick_up",
				no_prefix = true,
				button = function()
					local vouchers = get_current_pool('Voucher')
					local valid = {}
					for k, v in pairs(vouchers) do
						if v ~= 'UNAVAILABLE' then
							valid[#valid + 1] = v
						end
					end
					if next(valid) then
						local vouch = pseudorandom_element(valid, 'vouch_' .. G.GAME.round_resets.ante)
						event.ability.voucher = vouch
						G.GAME.hpot_voucher_taken = G.GAME.hpot_event_scenario_data.voucher
						--print(G.GAME.hpot_event_scenario_data.voucher)
						event.start_step('hpot_voucher_2')
					else
						event.finish_scenario()
					end
				end,
			},
			{
				key = "hpot_voucher_leave",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
})
HotPotato.EventStep({
	key = 'voucher_2',
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	loc_vars = function(self, event)
		return { localize { type = 'name_text', key = event.ability.voucher, set = "Voucher", vars = {} } }
	end,
	start = function(self, event)
		local pirate_card = Character(event.ability.voucher)
		pirate_card.children.particles.colours = { G.C.VOUCHER, G.C.SET.Voucher, G.C.SECONDARY_SET.Voucher }
		pirate_card.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				pirate_card.T.scale = pirate_card.T.scale * 0.75
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event {
			func = function()
				pirate_card.children.card.cost = 0
				pirate_card.children.card:redeem()
				return true
			end
		})
	end,
	finish = function(self, event)
		local jimbo_card = event.image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end
})

HotPotato.EventScenario {
	key = "voucher",
	domains = { reward = true },
	starting_step_key = "hpot_voucher_1",
	hotpot_credits = {
		idea = { "MissingNumber" },
		code = { "Haya", "SleepyG11" },
		team = { "Jtem" },
	},
}

-- Spam

HotPotato.EventStep({
	key = 'spam_1',
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
		create_ads(pseudorandom('spam_spam_lovely_spam!_' .. G.GAME.round_resets.ante, 10, 25))
	end
})

HotPotato.EventScenario {
	key = "spam_email",
	hide_image_area = true,
	domains = { occurence = true },
	starting_step_key = "hpot_spam_1",
	hotpot_credits = {
		idea = { "MissingNumber" },
		code = { "Haya", "SleepyG11" },
		team = { "Jtem" },
	},
}

-- Money game

HotPotato.EventStep({
	key = "money_game_invest",
	get_choices = function(self, event)
		return {
			{
				key = "sell_diamonds",
				button = function()
					SMODS.add_card({
						key = "j_rough_gem",
						stickers = { "rental" }
					})
					event.finish_scenario()
				end,
				func = function()
					return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
				end,
			},
			{
				key = "sell_rocks",
				button = function()
					SMODS.add_card({
						key = "j_stone",
						stickers = { "eternal" }
					})
					event.finish_scenario()
				end,
				func = function()
					return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
				end,
			},
			{
				key = "sell_water_to_a_fish",
				button = function()
					SMODS.add_card({
						key = "j_selzer",
						stickers = { "rental" }
					})
					event.finish_scenario()
				end,
				func = function()
					return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
				end,
			},
			{
				key = "sell_time_to_a_clock",
				button = function()
					SMODS.add_card({
						key = "j_delayed_grat",
						stickers = { "perishable" }
					})
					event.finish_scenario()
				end,
				-- No check to prevent softlock
			},
		}
	end,

	start = function()
		local card = Character("j_to_the_moon")
		card.children.particles.colours = { G.C.MONEY, G.C.MONEY, G.C.MONEY }
	end,
	finish = function()
		Remove()
	end,
})
HotPotato.EventScenario({
	key = "money_game",
	domains = { reward = true },
	starting_step_key = "hpot_money_game_invest",
	in_pool = function(self)
		return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
	end,
})


-- nigerian prince
HotPotato.EventStep {
	key = "nigerian_prince_start",
	hide_hand = true,
	start = function(self, event)
		local prince_man = Character("j_baron")
		prince_man.children.particles.colours = { G.C.RED, G.C.RED, G.C.RED }
		prince_man.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				prince_man.T.scale = prince_man.T.scale * 0.75
				return true
			end,
		}))
	end,
	get_choices = function(self, event)
		return {
			{
				key = "hp_prince_ignore",
				button = function()
					event.finish_scenario()
				end,
			},
			{
				key = "hp_prince_reply",
				button = function()
					event.start_step('hpot_nigerian_prince_reply')
				end,
			},
		}
	end
}

HotPotato.EventStep {
	key = "nigerian_prince_reply",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hp_prince_ignore",
				button = function()
					event.finish_scenario()
				end,
			},
			{
				key = "hp_prince_invest",
				button = function()
					local success = pseudorandom("hpot_nigerian_prince_invest") > 0.5
					ease_spark_points(-25000)
					if success then
						ease_spark_points(G.GAME.spark_points * 3)
						event.start_step('hpot_nigerian_prince_success')
					else
						event.start_step('hpot_nigerian_prince_invested')
					end
				end,
				func = function()
					return G.GAME.spark_points >= 25000
				end,
			},
		}
	end
}
HotPotato.EventStep {
	key = "nigerian_prince_invested",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hp_prince_stop",
				button = function()
					event.finish_scenario()
				end,
			},
			{
				key = "hp_prince_invest_more",
				button = function()
					local success = pseudorandom("hpot_nigerian_prince_invest") > 0.5
					ease_spark_points(-25000)
					if success then
						ease_spark_points(G.GAME.spark_points * 3)
						event.start_step('hpot_nigerian_prince_success')
					else
						event.start_step('hpot_nigerian_prince_invested')
					end
				end,
				func = function()
					return G.GAME.spark_points > 25000
				end,
			},
		}
	end
}

HotPotato.EventStep {
	key = "nigerian_prince_success",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hp_prince_leave",
				button = function()
					event.finish_scenario()
				end,
			},
		}
	end
}

HotPotato.EventScenario({
	key = "nigerian_prince",
	domains = { occurence = true },
	starting_step_key = "hpot_nigerian_prince_start",
	in_pool = function(self)
		return true
	end,
	hotpot_credits = {
		idea = { "Aikoyori" },
		code = { "Aikoyori" },
		team = { "Jtem" },
	},
})
-- Food for stuff trade
-- Someone make good finish for this event
local function get_food_joker()
	for _, joker in ipairs(G.jokers.cards) do
		local pools = joker.config.center.pools or {}
		if pools.Food then return joker end
	end
end

HotPotato.EventStep({
	key = "food_trade_1",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_food_trade_listen",
				no_prefix = true,
				vars = { localize { type = 'name_text', key = "j_gluttenous_joker", set = "Joker", vars = {} } },
				button = function()
					return event.start_step("hpot_food_trade_2")
				end,
			}
		}
	end,
})
HotPotato.EventStep({
	key = "food_trade_2",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_food_trade_listen",
				no_prefix = true,
				vars = { localize { type = 'name_text', key = "j_hpot_greedybastard", set = "Joker", vars = {} } },
				button = function()
					return event.start_step("hpot_food_trade_3")
				end,
			}
		}
	end,
	start = function(self, event)
		local glut = Character("j_gluttenous_joker", "glut", -G.CARD_W / 2, -G.CARD_H / 8)
		glut.children.particles.colours = { { 0, 0, 0, 0 } }
		event.display_lines(2, true)
		glut:say_stuff(5)
	end,
})
HotPotato.EventStep({
	key = "food_trade_3",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_food_trade_listen",
				no_prefix = true,
				vars = { localize { type = 'name_text', key = "j_vagabond", set = "Joker", vars = {} } },
				button = function()
					return event.start_step("hpot_food_trade_4")
				end,
			}
		}
	end,
	start = function(self, event)
		local greedyb = Character("j_hpot_greedybastard", "greedyb", 0, G.CARD_H / 8)
		greedyb.children.particles.colours = { { 0, 0, 0, 0 } }
		event.display_lines(2, true)
		greedyb:say_stuff(5)
	end,
})
HotPotato.EventStep({
	key = "food_trade_4",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_food_trade_think",
				no_prefix = true,
				button = function()
					return event.start_step("hpot_food_trade_choose")
				end,
			}
		}
	end,
	start = function(self, event)
		local vagabond = Character("j_vagabond", "vagabond", G.CARD_W / 2, -G.CARD_H / 8)
		vagabond.children.particles.colours = { { 0, 0, 0, 0 } }
		event.display_lines(2, true)
		vagabond:say_stuff(5)
	end,
})
HotPotato.EventStep({
	key = "food_trade_choose",
	get_choices = function(self, event)
		return {
			{
				key = "ignore",
				button = function()
					event.finish_scenario()
				end
			},
			{
				key = "hpot_food_trade_choose",
				no_prefix = true,
				vars = { localize { type = 'name_text', key = "j_gluttenous_joker", set = "Joker", vars = {} } },
				button = function()
					SMODS.destroy_cards(get_food_joker())
					for i = 1, 2 do
						SMODS.add_card({
							key = "c_empress"
						})
					end
					event.finish_scenario()
				end,
				func = function()
					return get_food_joker() and G.consumeables and
						G.consumeables.config.card_limit - #G.consumeables.cards >= 2
				end,
			},
			{
				key = "hpot_food_trade_choose",
				no_prefix = true,
				vars = { localize { type = 'name_text', key = "j_hpot_greedybastard", set = "Joker", vars = {} } },
				button = function()
					SMODS.destroy_cards(get_food_joker())
					ease_plincoins(4)
					event.finish_scenario()
				end,
				func = function()
					return get_food_joker()
				end,
			},
			{
				key = "hpot_food_trade_choose",
				no_prefix = true,
				vars = { localize { type = 'name_text', key = "j_vagabond", set = "Joker", vars = {} } },
				button = function()
					SMODS.destroy_cards(get_food_joker())
					SMODS.add_card({
						set = "bottlecap_Rare",
						area = G.consumeables,
					})
					event.finish_scenario()
				end,
				func = function()
					return get_food_joker() and G.consumeables and
						#G.consumeables.cards < G.consumeables.config.card_limit
				end,
			}
		}
	end,
	finish = function()
		Remove("glut")
		Remove("greedyb")
		Remove("vagabond")
	end,
})

HotPotato.EventScenario({
	key = "food_trade",
	domains = { occurence = true },
	starting_step_key = "hpot_food_trade_1",

	in_pool = function(self)
		return get_food_joker()
	end,

	hotpot_credits = {
		idea = { "MissingNumber" },
		code = { "SleepyG11" },
		team = { "Jtem" },
	},
})




-- Team Name Events


-- Mysterious Man

HotPotato.EventStep({
	key = "currency_exchange_1",

	config = {
		extra = {

		},
	},

	get_choices = function(self, event)
		return {
			{
				key = "hpot_exchange_credits_to_dollars",
				no_prefix = true,
				loc_vars = { convert_currency(G.GAME.credits_text, "CREDIT", "DOLLAR") },
				button = function()
					HPTN.ease_credits(-G.GAME.credits_text)
					ease_dollars(convert_currency(G.GAME.credits_text, "CREDIT", "DOLLAR"))
					event.ability = convert_currency(G.GAME.credits_text, "CREDIT", "DOLLAR")
					event.start_step("hpot_currency_exchange_success")
				end,
				func = function()
					return convert_currency(G.GAME.credits_text, "CREDIT", "DOLLAR") > 0
				end,
			},
			{
				key = "hpot_exchange_plincoins_to_dollars",
				no_prefix = true,
				loc_vars = { convert_currency(G.GAME.plincoins, "PLINCOIN", "DOLLAR") },
				button = function()
					ease_plincoins(-G.GAME.plincoins)
					ease_dollars(convert_currency(G.GAME.plincoins, "PLINCOIN", "DOLLAR"))
					event.ability = convert_currency(G.GAME.plincoins, "PLINCOIN", "DOLLAR")
					event.start_step("hpot_currency_exchange_success")
				end,
				func = function()
					return convert_currency(G.GAME.plincoins, "PLINCOIN", "DOLLAR") > 0
				end,
			},
			{
				key = "hpot_exchange_sparks_to_dollars",
				no_prefix = true,
				loc_vars = { convert_currency(G.GAME.spark_points, "SPARKLE", "DOLLAR") },
				button = function()
					ease_spark_points(-G.GAME.spark_points)
					ease_dollars(convert_currency(G.GAME.spark_points, "SPARKLE", "DOLLAR"))
					event.ability = convert_currency(G.GAME.spark_points, "SPARKLE", "DOLLAR")
					event.start_step("hpot_currency_exchange_success")
				end,
				func = function()
					return convert_currency(G.GAME.spark_points, "SPARKLE", "DOLLAR") > 0
				end,
			},
			{
				key = "hpot_ignore_or_something",
				no_prefix = true,
				button = function()
					event.finish_scenario()
				end,
			},
		}
	end,
	start = function(self, event)
		event.display_lines(2, true)
		delay(1)
		local x, y = event.get_image_center()
		local card_sharp_card = Character("j_card_sharp")
		event.image_area.children.jimbo_card = card_sharp_card
		event.display_lines(1, true)
		delay(1)
		event.display_lines(1, true)
	end,
})
HotPotato.EventStep({
	key = "currency_exchange_success",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		event.display_lines(1, true)
	end,
	finish = function(self, event)
		local card_sharp_card = event.image_area.children.jimbo_card
		if card_sharp_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					card_sharp_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})

HotPotato.EventScenario {
	key = "currency_exchange",
	domains = { wealth = true },
	starting_step_key = "hpot_currency_exchange_1",
	hotpot_credits = {
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
	in_pool = function()
		return G.GAME.dollars < 5
	end
}

-- Sticker Master

HotPotato.EventStep({
	key = "sticker_master_1",

	config = {
		extra = {
			cost = 5
		},
	},

	get_choices = function(self, event)
		return {
			{
				key = "hpot_remove_stickers",
				no_prefix = true,
				loc_vars = { self.config.extra.cost },
				button = function()
					ease_plincoins(-self.config.extra.cost)
					for k, card in pairs(G.jokers.cards) do
						G.E_MANAGER:add_event(Event({
							trigger = "after",
							func = function()
								card:juice_up()
								remove_all_stickers(card)
								return true
							end,
						}))
					end
					event.start_step("hpot_sticker_success")
				end,
				func = function()
					return sticker_check(G.jokers.cards) > 0 and G.GAME.plincoins >= 3
				end,
			},
			{
				key = "hpot_ignore_or_something",
				no_prefix = true,
				button = function()
					event.finish_scenario()
				end,
			},
		}
	end,
	start = function(self, event)
		event.display_lines(1, true)
		delay(2)
		local x, y = event.get_image_center()
		local cc = Character("j_hpot_sticker_master")
		event.image_area.children.jimbo_card = cc
		event.display_lines(2, true)
		delay(2)
		event.display_lines(2, true)
	end,
})

HotPotato.EventStep({
	key = "sticker_success",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		event.display_lines(1, true)
	end,
	finish = function(self, event)
		local card_sharp_card = event.image_area.children.jimbo_card
		if card_sharp_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					card_sharp_card:remove()
					event.image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})

HotPotato.EventScenario {
	key = "sticker_master_e",
	domains = { occurence = true },
	starting_step_key = "hpot_sticker_master_1",
	hotpot_credits = {
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
	in_pool = function()
		return sticker_check(G.jokers.cards) > 0
	end
}


-- Nuclear Explosion

HotPotato.EventStep({
	key = "nuclear_explosion_1",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					if SMODS.find_card("j_hpot_power_plant") then
						SMODS.find_card("j_hpot_power_plant")[1]:start_dissolve()
					end

					local suits = {}
					for k, v in pairs(G.playing_cards) do
						if not suits[v.base.suit] then
							suits[#suits + 1] = v.base.suit
						end
					end
					local random_suit = pseudorandom_element(suits)
					for k, v in pairs(G.playing_cards) do
						if v.base.suit == random_suit then
							SMODS.Stickers["hpot_uranium"]:apply(v, true)
						end
					end

					event.finish_scenario()
				end,
			},
		}
	end,
	start = function(self, event)
		event.display_lines(1, true)
		delay(1)
		event.display_lines(2, true)
	end,
})

HotPotato.EventScenario {
	key = "nuclear_explosion",
	hide_image_area = true,
	domains = { occurence = true },
	starting_step_key = "hpot_nuclear_explosion_1",
	hotpot_credits = {
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
	in_pool = function()
		return #SMODS.find_card("j_hpot_power_plant") > 0
	end
}

-- Job Application

HotPotato.EventStep({
	key = "hpot_job_application_1",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					event.start_step('hpot_job_application_procrastinate')
				end,
			},
			{
				key = "hpot_job_application_apply",
				no_prefix = true,
				button = function()
					local success = SMODS.pseudorandom_probability(event, "jobapplication", 1, 2, "jobapplication", true)
					if success then
						event.start_step('hpot_job_application_success')
					else
						event.start_step('hpot_job_application_failure')
					end
				end,
			},
		}
	end,
	start = function(self, event)
		local application = Character("j_business")
		application.children.particles.colours = { G.C.BLUE, G.C.BLUE, G.C.BLUE }
		application.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				application.T.scale = application.T.scale * 0.75
				return true
			end,
		}))
	end,
})

HotPotato.EventStep({
	key = "hpot_job_application_procrastinate",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					ease_plincoins(-G.GAME.plincoins)
					event.finish_scenario()
				end,
			}
		}
	end,
})

HotPotato.EventStep({
	key = "hpot_job_application_failure",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					event.finish_scenario()
				end,
			}
		}
	end,
})

HotPotato.EventStep({
	key = "hpot_job_application_success",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_job_application_success",
				no_prefix = true,
				button = function()
					ease_plincoins(10)
					G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
					event.finish_scenario()
				end,
			}
		}
	end,
})

HotPotato.EventScenario {
	key = "job_application",
	hide_image_area = true,
	domains = { occurence = true },
	starting_step_key = "hpot_job_application_1",
	hotpot_credits = {
		idea = { "Liafeon" },
		code = { "Liafeon" },
		team = { "Oops! All Programmers" },
	},
	in_pool = function()
		return G.GAME.round_resets.ante >= 5
	end
}

-- Virtual Sin Forgiveness

HotPotato.EventScenario {
	key = "virtual_sin_forgiveness",
	domains = { reward = true },
	starting_step_key = "hpot_vsf_1",
	hotpot_credits = {
		idea = { "th30ne" },
		code = { "theAstra" },
		team = { "O!AP" },
	}
}

HotPotato.EventStep {
	key = "hpot_vsf_1",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					event.start_step('hpot_vsf_2')
				end,
			},
		}
	end,
	start = function(self, event)
		local dan = Character("j_hpot_melvin")
		dan.children.particles.colours = { G.C.RED, G.C.RED, G.C.RED }
		dan.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				dan.T.scale = dan.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_vsf_2",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		play_sound('hpot_forgiveness')
		for _, joker in pairs(G.jokers.cards) do
			joker:juice_up(0.8, 0.8)
			for _, sticker in pairs(SMODS.Sticker.obj_buffer) do
				if joker.ability[sticker] then
					joker.ability[sticker] = nil
				end
			end
		end
	end,
	finish = function(self, event)
	end
}


-- The Trolley Problem

HotPotato.EventScenario {
	key = "trolley",
	domains = { occurence = true },
	starting_step_key = "hpot_trolley_1",
	hotpot_credits = {
		idea = { "theAstra" },
		code = { "theAstra" },
		team = { "O!AP" },
	},
	in_pool = function()
		return #G.jokers.cards >= 1 and #G.playing_cards >= 5
	end
}

-- Prevent selling card during this event
local csc = Card.can_sell_card
function Card:can_sell_card(context)
	if self.marked_for_trolley then
		return false
	end

	return csc(self, context)
end

HotPotato.EventStep {
	key = "hpot_trolley_1",
	hide_hand = false,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_trolley_joker",
				no_prefix = true,
				button = function()
					event.start_step('hpot_trolley_joker_killed')
				end,
			},
			{
				key = "hpot_trolley_cards",
				no_prefix = true,
				button = function()
					event.start_step('hpot_trolley_cards_killed')
				end,
			},
			{
				key = "hpot_trolley_bribe_attempt",
				no_prefix = true,
				button = function()
					ease_dollars(-20)
					event.start_step('hpot_trolley_bribe')
				end,
				func = function()
					return G.GAME.dollars >= 20
				end
			},
		}
	end,
	start = function(self, event)
		local to = Character("j_hpot_trolley_operator")
		to.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				to.T.scale = to.T.scale * 0.75
				return true
			end,
		}))

		G.GAME.TROLLEY_PREV_HANDSIZE = G.hand.config.card_limit

		G.hand:change_size(5 - G.hand.config.card_limit)

		local selected_joker = pseudorandom_element(G.jokers.cards)
		selected_joker.marked_for_trolley = true

		G.E_MANAGER:add_event(Event({
			func = function()
				G.FUNCS.draw_from_deck_to_hand()

				G.jokers:remove_card(selected_joker)
				G.hand:emplace(selected_joker)
				return true;
			end
		}))
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_trolley_joker_killed",
	hide_hand = false,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		for _, v in pairs(G.hand.cards) do
			if v.ability.set == 'Joker' then
				v:start_dissolve()
				G.hand:remove_card(v)
			end
		end
	end,
	finish = function(self, event)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.FUNCS.draw_from_hand_to_deck()
				G.deck:shuffle('nr' .. G.GAME.round_resets.ante)

				G.hand:change_size(G.GAME.TROLLEY_PREV_HANDSIZE - 5)
				G.GAME.TROLLEY_PREV_HANDSIZE = nil
				return true;
			end
		}))
	end
}

HotPotato.EventStep {
	key = "hpot_trolley_cards_killed",
	hide_hand = false,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		for _, v in pairs(G.hand.cards) do
			if v.ability.set ~= 'Joker' then
				v:start_dissolve()
			end
		end
	end,
	finish = function(self, event)
		local joker = G.hand.cards[1]
		G.hand:remove_card(joker)
		G.jokers:emplace(joker)
		joker.marked_for_trolley = nil
		G.E_MANAGER:add_event(Event({
			func = function()
				G.hand:change_size(G.GAME.TROLLEY_PREV_HANDSIZE - 5)
				G.GAME.TROLLEY_PREV_HANDSIZE = nil
				return true;
			end
		}))
	end
}

HotPotato.EventStep {
	key = "hpot_trolley_bribe",
	hide_hand = false,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
		for _, v in pairs(G.hand.cards) do
			if v.ability.set == 'Joker' then
				G.hand:remove_card(v)
				G.jokers:emplace(v)
				v.marked_for_trolley = nil
				break
			end
		end

		G.E_MANAGER:add_event(Event({
			func = function()
				G.FUNCS.draw_from_hand_to_deck()
				G.deck:shuffle('nr' .. G.GAME.round_resets.ante)

				G.hand:change_size(G.GAME.TROLLEY_PREV_HANDSIZE - 5)
				G.GAME.TROLLEY_PREV_HANDSIZE = nil
				return true;
			end
		}))
	end
}


-- Mystery Box

HotPotato.EventScenario {
	key = "mystery_box",
	domains = { occurence = true },
	starting_step_key = "hpot_mb_1",
	hotpot_credits = {
		idea = { "factwixard" },
		code = { "factwixard" },
		team = { "O!AP" }
	},
}
HotPotato.EventStep {
	key = "mb_1",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					event.start_step('hpot_mb_4')
				end,
			},
			{
				key = "hpot_mystery_box",
				no_prefix = true,
				button = function()
					HPTN.ease_credits(-5)
					event.start_step("hpot_mb_2")
				end,
				func = function()
					return G.GAME.credits_text > 5
				end,
			},
		}
	end,
	start = function(self, event)
		local tn = Character("j_hpot_tname_postcard")
		tn.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				tn.T.scale = tn.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
	end
}
HotPotato.EventStep {
	key = "mb_2",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					event.start_step("hpot_mb_3")
				end,
			},
		}
	end,
	start = function(self, event)
		for _, joker in pairs(G.jokers.cards) do
			joker:juice_up(0.8, 1)
		end
	end,
	finish = function(self, event)
	end
}
HotPotato.EventStep {
	key = "mb_3",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}
HotPotato.EventStep {
	key = "mb_4",
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

-- Refreshing

HotPotato.EventScenario {
	key = "refreshing",
	domains = { occurence = true },
	starting_step_key = "hpot_refreshing_1",
	hotpot_credits = {
		idea = { "theAstra" },
		code = { "theAstra" },
		team = { "O!AP" },
	}
}

HotPotato.EventStep {
	key = "hpot_refreshing_1",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_refreshing_purchase_btn",
				no_prefix = true,
				button = function()
					ease_dollars(-5)
					event.start_step('hpot_refreshing_purchase')
				end,
				func = function()
					return G.GAME.dollars >= 5 and
						#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
				end
			},
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		local cola = Character("j_diet_cola")
		cola.children.particles.colours = { G.C.RED, G.C.RED, G.C.RED }
		cola.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				cola.T.scale = cola.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_refreshing_purchase",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_refreshing_purchase_btn",
				no_prefix = true,
				button = function()
					ease_dollars(-5)
					event.start_step('hpot_refreshing_purchase')
				end,
				func = function()
					return G.GAME.dollars >= 5 and
						#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
				end
			},
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		play_sound('hpot_bottlecap')
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			func = function()
				SMODS.add_card({
					set = 'bottlecap'
				})
				return true;
			end
		}))
	end,
	finish = function(self, event)
	end
}


-- Fishing

HotPotato.EventScenario {
	key = "fishing",
	hide_image_area = true,
	domains = { occurence = true },
	starting_step_key = "hpot_fishing_1",
	hotpot_credits = {
		idea = { "theAstra" },
		code = { "theAstra" },
		team = { "O!AP" },
	},
}

HotPotato.EventStep {
	key = "hpot_fishing_1",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_fishing_cast_btn",
				no_prefix = true,
				button = function()
					event.start_step('hpot_fishing_cast_line')
				end,
				func = function()
					return #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
				end
			},
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_fishing_cast_line",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_fishing_wait_btn",
				no_prefix = true,
				button = function()
					local success = SMODS.pseudorandom_probability(event, 'hpot_fishing', 1, 10, 'hpot_fishing', true)
					if success then
						event.start_step('hpot_fishing_bite')
					else
						event.start_step('hpot_fishing_waiting')
					end
				end
			},
			{
				key = "hpot_fishing_leave_btn",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_fishing_waiting",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_fishing_wait_btn",
				no_prefix = true,
				button = function()
					local success = SMODS.pseudorandom_probability(event, 'hpot_fishing', 1, 2, 'hpot_fishing', true)
					if success then
						event.start_step('hpot_fishing_bite')
					else
						event.start_step('hpot_fishing_waiting')
					end
				end
			},
			{
				key = "hpot_fishing_leave_btn",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_fishing_bite",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		local c_type = pseudorandom_element(SMODS.ConsumableType.visible_buffer)

		SMODS.add_card {
			set = c_type,
			key_append = 'hpot_fishing'
		}
	end,
	finish = function(self, event)
	end
}

-- trapped streamer

HotPotato.EventScenario {
	key = "roffle",
	domains = { reward = true },
	starting_step_key = "hpot_roffle_start",
	hotpot_credits = {
		idea = { "trif" },
		code = { "trif" },
		team = { "O!AP" },
	}
}

HotPotato.EventStep {
	key = "hpot_roffle_start",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_roffle_looksinside_btn",
				no_prefix = true,
				button = function()
					event.start_step("hpot_roffle_looksinside")
				end
			},
			{
				key = "hpot_roffle_spec_baron_btn",
				no_prefix = true,
				button = function()
					event.start_step("hpot_roffle_spec_baron")
				end
			}
		}
	end,
	start = function(self, event)
		local roff = Character("j_card_sharp")
		roff.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				roff.T.scale = roff.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "hpot_roffle_looksinside",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	finish = function(self, event)
		if #G.jokers.cards < G.jokers.config.card_limit then
			local joker = pseudorandom_element({ "j_photograph", "j_hanging_chad" }, "photochad")
			SMODS.add_card({
				key = joker,
				area = G.jokers,
			})
		end
	end
}

HotPotato.EventStep {
	key = "hpot_roffle_spec_baron",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	finish = function(self, event)
		if #G.jokers.cards < G.jokers.config.card_limit then
			local b = SMODS.add_card({
				key = "j_baron",
				area = G.jokers,
			})
			b.T.h = b.T.h * 0.8
			poll_modification(1, b, nil, { BAD = 100 })
			reforge_card(b, true)
		end
	end
}

-- md6 slot machine

HotPotato.EventScenario {
	key = "bizzare_machine",
	hide_image_area = true,
	starting_step_key = "hpot_bizzare_machine_start",
	hotpot_credits = {
		code = { "Mysthaps" },
		team = { "O!AP" },
	},
}

HotPotato.EventStep {
	key = "hpot_bizzare_machine_start",
	domains = { occurence = true },
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_bizzare_machine_take_coin",
				no_prefix = true,
				button = function()
					event.start_step("hpot_bizzare_machine_take_coin")
				end
			},
			{
				key = "hpot_bizzare_machine_insert_coin",
				no_prefix = true,
				button = function()
					if pseudorandom('hpot_bizzare_machine', 1, 100) == 100 then
						event.start_step("hpot_bizzare_machine_insert_coin_success")
					else
						event.start_step("hpot_bizzare_machine_insert_coin_failure")
					end
				end
			}
		}
	end,
	start = function(self, event)
		G.GAME.abno_choice_music = true
	end,
}

HotPotato.EventStep {
	key = "hpot_bizzare_machine_take_coin",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		ease_plincoins(1)
	end,
	finish = function(self, event)
		G.GAME.abno_choice_music = nil
	end
}

HotPotato.EventStep {
	key = "hpot_bizzare_machine_insert_coin_success",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		local card = SMODS.add_card({
			set = "Joker",
			rarity = "Legendary",
			area = G.jokers,
		})
	end,
	finish = function(self, event)
		G.GAME.abno_choice_music = nil
	end
}

HotPotato.EventStep {
	key = "hpot_bizzare_machine_insert_coin_failure",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = event.finish_scenario,
			},
		}
	end,
	start = function(self, event)
		ease_plincoins(0.5)
	end,
	finish = function(self, event)
		G.GAME.abno_choice_music = nil
	end
}

-- Pissdrawer Tech Support

HotPotato.EventScenario {
	key = "tech_support",
	domains = { reward = true },
	starting_step_key = "hpot_tech_support_start",
	hotpot_credits = {
		code = { "SDM_0" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "hpot_tech_support_start",
	hide_hand = true,
	get_choices = function(self, event)
		return {
			{
				key = "hpot_tech_support_ask_n",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_n")
				end
			},
			{
				key = "hpot_tech_support_ask_eremel",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_eremel")
				end
			},
			{
				key = "hpot_tech_support_ask_sdm_0",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_sdm_0")
				end
			},
			{
				key = "hpot_tech_support_ask_bepis",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_bepis")
				end
			},
			{
				key = "hpot_tech_support_ask_deadbeet",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_deadbeet")
				end
			},
			{
				key = "hpot_tech_support_ask_fey",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_fey")
				end
			},
			{
				key = "hpot_tech_support_ask_tacashumi",
				no_prefix = true,
				button = function()
					event.start_step("hpot_tech_support_ask_tacashumi")
				end
			},
		}
	end,
	start = function(self, event)
		local yap = Character("j_hpot_yapper")
		yap.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				yap.T.scale = yap.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_n",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_eremel",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_sdm_0",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_bepis",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_deadbeet",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_fey",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}

HotPotato.EventStep {
	key = "hpot_tech_support_ask_tacashumi",
	hide_hand = true,
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event)
	end,
	finish = function(self, event)
	end
}


--- Post-Overhaul Events :P
-- TODO: change these to not use loc_txt. i cant be bothered rn
-- Sorry if these are bad but there isn't much I can do in a week

--- Occurence

--#region Business Venture

HotPotato.EventScenario {
	key = "business_venture_1",
	loc_txt = {
		name = "Triboulet's Business Venture (Part I)",
		text = {
			"To the moon!"
		}
	},
	domains = { occurence = true },
	starting_step_key = "hpot_business_venture_1_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
	in_pool = function(self)
		return tonumber(G.GAME.credits_text) >= 100 and not G.GAME.hpot_event_triboulet_invested and
			not G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested
	end
}

HotPotato.EventStep {
	key = "business_venture_1_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"A stange guy approaches you on the street.",
			" ",
			"\"Hey, would you like to invest in my business idea?\"",
		},
		choices = {
			invest_100 = "Invest {C:purple}c.100",
			invest_500 = "Invest {C:purple}c.500",
			invest_1000 = "Invest {C:purple}c.1000",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "invest_100",
				button = function()
					G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested = 100
					G.GAME.hpot_event_triboulet_invested = true
					HPTN.ease_credits(-100)
					event.start_step("hpot_business_venture_1_finish")
				end,
				func = function()
					return tonumber(G.GAME.credits_text) >= 100
				end
			},
			{
				key = "invest_500",
				button = function()
					G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested = 500
					G.GAME.hpot_event_triboulet_invested = true
					HPTN.ease_credits(-500)
					event.start_step("hpot_business_venture_1_finish")
				end,
				func = function()
					return tonumber(G.GAME.credits_text) >= 500
				end
			},
			{
				key = "invest_1000",
				button = function()
					G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested = 1000
					G.GAME.hpot_event_triboulet_invested = true
					HPTN.ease_credits(-1000)
					event.start_step("hpot_business_venture_1_finish")
				end,
				func = function()
					return tonumber(G.GAME.credits_text) >= 1000
				end
			},
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("j_triboulet")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "business_venture_1_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Hehe, I will make it worth your time.\" *wink* *wink*",
			" ",
			"You have a bad feeling about this."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
}

HotPotato.EventScenario {
	key = "business_venture_2",
	loc_txt = {
		name = "Triboulet's Business Venture (Part II)",
		text = {
			"Stonks."
		}
	},
	domains = { occurence = true },
	starting_step_key = "hpot_business_venture_2_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
	in_pool = function(self)
		return not G.GAME.hpot_event_triboulet_invested and
			G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested
	end
}

HotPotato.EventStep {
	key = "business_venture_2_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"It's you! Long time no see, pal!",
			"Thanks to your help I'm a millionaire now!",
			"It's in credits so it's actually not that impressive",
			"but at least I can afford some nice Kings and Queens,",
			"if you know what I mean!\" *wink* *wink*",
			" ",
			"You take the money and decide to wash your hands repeatedly",
			"as soon as you get home."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("j_triboulet")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
		HPTN.ease_credits((G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested or 0) * 2)
		G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested = nil
		G.GAME.hpot_event_triboulet_invested = true
	end
}

HotPotato.EventScenario {
	key = "business_venture_3",
	loc_txt = {
		name = "Triboulet's Pity",
		text = {
			"Oh, you can't afford it?"
		}
	},
	domains = { occurence = true },
	starting_step_key = "hpot_business_venture_3_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
	in_pool = function(self)
		return tonumber(G.GAME.credits_text) <= -100 and not G.GAME.hpot_event_triboulet_invested and
			not G.PROFILES[G.SETTINGS.profile].hpot_event_triboulet_invested
	end
}

HotPotato.EventStep {
	key = "business_venture_3_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"A stange guy approaches you on the street.",
			" ",
			"\"Hey, would you like to invest in-",
			" ",
			"Oh, you seem to be in serious debt I see.",
			"Tell you what, I'll bail you out. But not for free of course.",
			"You will need to give me something valuable in return,",
			"if you know what I mean!\" *wink* *wink*",
			" ",
			"You have a bad feeling about this."
		},
		choices = {
			dollars = "Pay {C:money}$",
			plincoins = "Pay {C:blue,f:hpot_plincoin}͸",
			crypto = "Pay {C:hpot_advert,f:hpot_plincoin}£",
			spark = "Pay {C:blue,f:hpot_plincoin}͸",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "dollars",
				button = function()
					G.GAME.hpot_event_triboulet_invested = true
					ease_dollars(tonumber(G.GAME.credits_text))
					HPTN.ease_credits(-tonumber(G.GAME.credits_text))
					event.start_step("hpot_business_venture_3_finish")
				end,
			},
			{
				key = "plincoins",
				button = function()
					G.GAME.hpot_event_triboulet_invested = true
					ease_plincoins(tonumber(G.GAME.credits_text))
					HPTN.ease_credits(-tonumber(G.GAME.credits_text))
					event.start_step("hpot_business_venture_3_finish")
				end,
			},
			{
				key = "crypto",
				button = function()
					G.GAME.hpot_event_triboulet_invested = true
					ease_cryptocurrency(tonumber(G.GAME.credits_text))
					HPTN.ease_credits(-tonumber(G.GAME.credits_text))
					event.start_step("hpot_business_venture_3_finish")
				end,
			},
			{
				key = "spark",
				button = function()
					G.GAME.hpot_event_triboulet_invested = true
					ease_spark_points(tonumber(G.GAME.credits_text))
					HPTN.ease_credits(-tonumber(G.GAME.credits_text))
					event.start_step("hpot_business_venture_3_finish")
				end,
			},
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("j_triboulet")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "business_venture_3_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Hehe, pleasure doing business with you.\" *wink* *wink*",
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
}

--#endregion

--- Reward

--#region Personality Quiz

HotPotato.EventScenario {
	key = "buzzfeed_quiz",
	loc_txt = {
		name = "Personality Quiz",
		text = {
			"Click here and find out which Joker you are!"
		}
	},
	domains = { reward = true },
	starting_step_key = "hpot_buzzfeed_quiz_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"You accidentally clicked one of the ads on the screen. The page reads:",
			" ",
			"{s:1.2}\"Which {s:1.2,C:attention}Balatro{s:1.2} Joker are you?\"",
			" ",
			"No harm in trying it out, right?"
		},
		choices = {
			take_quiz = "Take the quiz"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "take_quiz",
				button = function()
					G.GAME.hotpot_diy = G.GAME.hotpot_diy or {}
					event.start_step("hpot_buzzfeed_quiz_1")
				end
			},
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("c_hpot_imag_curi")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_1",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Where would you like to go on a first date?\"",
		},
		choices = {
			park = "To the park",
			carnival = "To the town fair",
			casino = "To the casino",
			no_date = "Winners don't go on dates"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "park",
				button = function()
					G.GAME.hotpot_diy.trigger = 1
					event.start_step("hpot_buzzfeed_quiz_park")
				end
			},
			{
				key = "carnival",
				button = function()
					G.GAME.hotpot_diy.trigger = 2
					event.start_step("hpot_buzzfeed_quiz_carnival")
				end
			},
			{
				key = "casino",
				button = function()
					G.GAME.hotpot_diy.trigger = 3
					event.start_step("hpot_buzzfeed_quiz_casino")
				end
			},
			{
				key = "no_date",
				button = function()
					G.GAME.hotpot_diy.trigger = 4
					event.start_step("hpot_buzzfeed_quiz_no_date")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_park",
	hide_hand = true,
	loc_txt = {
		text = {
			"You would like to go on a nice handholding date",
			"to the local park, you thought."
		},
		choices = {
			continue = "Read the next question",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_3")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_carnival",
	hide_hand = true,
	loc_txt = {
		text = {
			"You would like to enjoy the attractions",
			"together at the local town fair, you thought."
		},
		choices = {
			continue = "Read the next question",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_3")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_casino",
	hide_hand = true,
	loc_txt = {
		text = {
			"They are not going out with me if they can't",
			"enjoy a little Plinko gambling, you thought."
		},
		choices = {
			continue = "Read the next question",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_3")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_no_date",
	hide_hand = true,
	loc_txt = {
		text = {
			"Dates? Those are woke nonsense.",
			"I'm going to be by my lonesome, you thought."
		},
		choices = {
			continue = "Read the next question",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_3")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_3",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Your roommate owes you 500 credits.",
			"They say they can pay you back if you just give them a",
			"little bit more time.",
			" ",
			"What do you do?\""
		},
		choices = {
			wait = "Wait patiently",
			forgive = "Forgive the debt",
			move = "Move out",
			sell = "Sell their possessions on the Black Market",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "wait",
				button = function()
					G.GAME.hotpot_diy.effect = 3
					event.start_step("hpot_buzzfeed_quiz_wait")
				end
			},
			{
				key = "forgive",
				button = function()
					G.GAME.hotpot_diy.effect = 6
					event.start_step("hpot_buzzfeed_quiz_forgive")
				end
			},
			{
				key = "move",
				button = function()
					G.GAME.hotpot_diy.effect = 1
					event.start_step("hpot_buzzfeed_quiz_move")
				end
			},
			{
				key = "sell",
				button = function()
					G.GAME.hotpot_diy.effect = 5
					event.start_step("hpot_buzzfeed_quiz_sell")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_wait",
	hide_hand = true,
	loc_txt = {
		text = {
			"I'm patient. I can wait for them, you thought.",
			" ",
			"You may be betrayed by those words some day."
		},
		choices = {
			continue = "See results",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_finish")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_forgive",
	hide_hand = true,
	loc_txt = {
		text = {
			"No relationship should be shackled to such things as",
			"money, you thought.",
			" ",
			"Maybe you're too forgiving."
		},
		choices = {
			continue = "See results",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_finish")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_move",
	hide_hand = true,
	loc_txt = {
		text = {
			"I can't be living with a leech! You thought.",
			" ",
			"Are credits this important to you?"
		},
		choices = {
			continue = "See results",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_finish")
				end
			},
		}
	end,
}


HotPotato.EventStep {
	key = "buzzfeed_quiz_sell",
	hide_hand = true,
	loc_txt = {
		text = {
			"Hey, at least I can make some of it back, you thought.",
			" ",
			"Maybe you should stop and think about what you would do after that."
		},
		choices = {
			continue = "See results",
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "continue",
				button = function()
					event.start_step("hpot_buzzfeed_quiz_finish")
				end
			},
		}
	end,
}

HotPotato.EventStep {
	key = "buzzfeed_quiz_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"{s:1.2}\"This is who yuo are!\"",
			" ",
			"A picture of yourself appears on the screen.",
			" ",
			"...",
			"I thought this was about Balatro? Boring."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		if #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
			SMODS.add_card { key = "j_hpot_diy" }
		end
	end
}
--#endregion

--#region Dreamkeeper

HotPotato.EventScenario {
	key = "dreamkeeper_1",
	loc_txt = {
		name = "Dreamkeeper (Part I)",
		text = {
			"Sweet dreams are made of this"
		}
	},
	domains = { reward = true },
	starting_step_key = "hpot_dreamkeeper_1_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "dreamkeeper_1_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Can you take care of these for a bit?",
			"It would help out a lot!\""
		},
		choices = {
			accept = "Take Dreams"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "accept",
				button = function()
					event.start_step("hpot_dreamkeeper_1_finish")
				end,
			},
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("c_hpot_imag_stars")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "dreamkeeper_1_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Thank you so much. You're a life saver.\"",
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		G.GAME.hpot_event_dreamkeeper = true
		for i = 1, 5 do
			SMODS.add_card { key = "c_hpot_imag_stars" }
		end
	end
}

HotPotato.EventScenario {
	key = "dreamkeeper_2",
	loc_txt = {
		name = "Dreamkeeper (Part II)",
		text = {
			"Who am I to disagree?"
		}
	},
	domains = { reward = true },
	starting_step_key = "hpot_dreamkeeper_2_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
	in_pool = function(self)
		return G.GAME.hpot_event_dreamkeeper
	end
}

HotPotato.EventStep {
	key = "dreamkeeper_2_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Hey, have you got my dreams?\""
		},
		choices = {
			accept = "Give Dreams"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "accept",
				button = function()
					if #SMODS.find_card("c_hpot_imag_stars") >= 5 then
						for i, card in ipairs(SMODS.find_card("c_hpot_imag_stars")) do
							if i > 5 then break end
							SMODS.destroy_cards(card)
						end
						event.start_step("hpot_dreamkeeper_2_give")
					else
						event.start_step("hpot_dreamkeeper_2_finish")
					end
				end,
			},
		}
	end,
	start = function(self, event)
		local chara = Character("c_hpot_imag_stars")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "dreamkeeper_2_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"How could you do this to me!? Those are valuable...",
			" ",
			"I hope you're ready to pay for them.\""
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	finish = function(self, event)
		ease_dollars(-10 * (5 - #SMODS.find_card("c_hpot_imag_stars")))
		for i, card in ipairs(SMODS.find_card("c_hpot_imag_stars")) do
			SMODS.destroy_cards(card)
		end
	end
}

HotPotato.EventStep {
	key = "dreamkeeper_2_give",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"I don't know what I would have done without you.",
			" ",
			"Take this. You deserve it.\""
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	finish = function(self, event)
		local _handname, _played = 'High Card', -1
		for hand_key, hand in pairs(G.GAME.hands) do
			if hand.played > _played then
				_played = hand.played
				_handname = hand_key
			end
		end
		local most_played = _handname

		SMODS.smart_level_up_hand(nil, most_played, nil, 20)
	end
}

--#endregion

--#region I Hope This Holds Your Interest

HotPotato.EventScenario {
	key = "interest_1",
	loc_txt = {
		name = "I Hope This Holds Your Interest (Part I)",
		text = {
			"I think it's in your best interest",
			"to hold on to these"
		}
	},
	domains = { reward = true },
	starting_step_key = "hpot_interest_1_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "interest_1_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Hey, I'm bored of these. You can play with them if you want",
			"but give them back, will you?\""
		},
		choices = {
			accept = "Take Interests"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "accept",
				button = function()
					event.start_step("hpot_interest_1_finish")
				end,
			},
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("c_hpot_imag_duck")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "interest_1_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"I'm just going back to my Switch 2.\"",
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		G.GAME.hpot_event_interest = true
		for i = 1, 5 do
			SMODS.add_card { key = "c_hpot_imag_duck" }
		end
	end
}

HotPotato.EventScenario {
	key = "interest_2",
	loc_txt = {
		name = "I Hope This Holds Your Interest (Part II)",
		text = {
			"Being nice doesn't make you interesting, you know?"
		}
	},
	domains = { reward = true },
	starting_step_key = "hpot_interest_2_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
	in_pool = function(self)
		return G.GAME.hpot_event_interest
	end
}

HotPotato.EventStep {
	key = "interest_2_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"I take it back. I want to play with them again,",
			"can you give them back?\""
		},
		choices = {
			accept = "Give Interests"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "accept",
				button = function()
					if #SMODS.find_card("c_hpot_imag_duck") >= 5 then
						for i, card in ipairs(SMODS.find_card("c_hpot_imag_duck")) do
							if i > 5 then break end
							SMODS.destroy_cards(card)
						end
						event.start_step("hpot_interest_2_give")
					else
						event.start_step("hpot_interest_2_finish")
					end
				end,
			},
		}
	end,
	start = function(self, event)
		local chara = Character("c_hpot_imag_duck")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
}

HotPotato.EventStep {
	key = "interest_2_finish",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"What? But... I didn't look like I needed them?",
			"How dare you?",
			" ",
			"I hope you're ready to pay for them.\""
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	finish = function(self, event)
		HPTN.ease_credits(-50 * (5 - #SMODS.find_card("c_hpot_imag_duck")))
		for i, card in ipairs(SMODS.find_card("c_hpot_imag_duck")) do
			SMODS.destroy_cards(card)
		end
	end
}

HotPotato.EventStep {
	key = "interest_2_give",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Hahaha, I don't know how I ever go bored of these.",
			" ",
			"Thanks, have this.\""
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	finish = function(self, event)
		for i = 1, 10 do
			SMODS.add_card { set = "Spectral", edition = 'e_negative' }
		end
	end
}

--#endregion

--- Wealth

--#region Cool Gal

HotPotato.EventScenario {
	key = "cool_gal",
	loc_txt = {
		name = "Cool Gal",
		text = {
			"And everyone clapped."
		}
	},
	domains = { wealth = true },
	starting_step_key = "hpot_cool_gal_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "cool_gal_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"A young lady riding a motocycle approaches you.",
			"\"Hey, take this!\"",
			" ",
			"And then she drove away into the sunset.",
			" ",
			"What a cool gal."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		local chara = Character("j_hit_the_road")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
		local poll = pseudorandom("hpo_event_cool_gal", 1, 5)
		if poll == 1 then
			ease_dollars(10)
		elseif poll == 2 then
			ease_plincoins(2)
		elseif poll == 3 then
			HPTN.ease_credits(20)
		elseif poll == 4 then
			ease_spark_points(2000)
		elseif poll == 5 then
			ease_cryptocurrency(2)
		end
	end
}

--#endregion

--#region Gambling

HotPotato.EventScenario {
	key = "gambling",
	hide_image_area = true,
	loc_txt = {
		name = "Let's Go Gambling!",
		text = {
			"Aw dang it."
		}
	},
	domains = { wealth = true },
	starting_step_key = "hpot_gambling_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
	in_pool = function(self)
		return G.GAME.dollars >= 5
	end
}

local hpot_event_gambling_func = function(amount, event)
	event.ability.gambling = (event.ability.gambling or 0) + 1
	local success = pseudorandom("hpot_event_gambling") >= 0.25 * event.ability.gambling
	if success then
		ease_dollars(amount)
	else
		ease_dollars(-amount)
	end
	if event.ability.gambling >= 4 then
		if event.ability.initial_money > G.GAME.dollars then
			event.start_step("hpot_gambling_finish_pos")
		else
			event.start_step("hpot_gambling_finish_neg")
		end
	elseif success then
		event.start_step("hpot_gambling_success")
	else
		event.start_step("hpot_gambling_fail")
	end
end

HotPotato.EventStep {
	key = "gambling_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"You encounter a slot machine.",
			" ",
			"How much will you bet?"
		},
		choices = {
			bet5 = "Bet {C:money}$5{}",
			bet10 = "Bet {C:money}$10{}",
			bet20 = "Bet {C:money}$20{}",
			bet40 = "Bet {C:money}$40{}",
			ignore = "Ignore"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "bet5",
				button = function()
					hpot_event_gambling_func(5, event)
				end,
				func = function()
					return G.GAME.dollars >= 5
				end
			},
			{
				key = "bet10",
				button = function()
					hpot_event_gambling_func(10, event)
				end,
				func = function()
					return G.GAME.dollars >= 10
				end
			},
			{
				key = "bet20",
				button = function()
					hpot_event_gambling_func(20, event)
				end,
				func = function()
					return G.GAME.dollars >= 20
				end
			},
			{
				key = "bet40",
				button = function()
					hpot_event_gambling_func(40, event)
				end,
				func = function()
					return G.GAME.dollars >= 40
				end
			},
			{
				key = "ignore",
				button = hpot_event_end_scenario,
			}
		}
	end,
	start = function(self, event)
		event.ability.initial_money = G.GAME.dollars
	end
}

HotPotato.EventStep {
	key = "gambling_success",
	hide_hand = true,
	loc_txt = {
		text = {
			"I can't stop winning!",
			" ",
			"How much will you bet next?"
		},
		choices = {
			bet5 = "Bet {C:money}$5{}",
			bet10 = "Bet {C:money}$10{}",
			bet20 = "Bet {C:money}$20{}",
			bet40 = "Bet {C:money}$40{}",
			stop = "Stop"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "bet5",
				button = function()
					hpot_event_gambling_func(5, event)
				end,
				func = function()
					return G.GAME.dollars >= 5
				end
			},
			{
				key = "bet10",
				button = function()
					hpot_event_gambling_func(10, event)
				end,
				func = function()
					return G.GAME.dollars >= 10
				end
			},
			{
				key = "bet20",
				button = function()
					hpot_event_gambling_func(20, event)
				end,
				func = function()
					return G.GAME.dollars >= 20
				end
			},
			{
				key = "bet40",
				button = function()
					hpot_event_gambling_func(40, event)
				end,
				func = function()
					return G.GAME.dollars >= 40
				end
			},
			{
				key = "stop",
				button = hpot_event_end_scenario,
			}
		}
	end,
}

HotPotato.EventStep {
	key = "gambling_fail",
	hide_hand = true,
	loc_txt = {
		text = {
			"Aw dang it!",
			" ",
			"How much will you bet next?"
		},
		choices = {
			bet5 = "Bet {C:money}$5{}",
			bet10 = "Bet {C:money}$10{}",
			bet20 = "Bet {C:money}$20{}",
			bet40 = "Bet {C:money}$40{}",
			stop = "Stop"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "bet5",
				button = function()
					hpot_event_gambling_func(5, event)
				end,
				func = function()
					return G.GAME.dollars >= 5
				end
			},
			{
				key = "bet10",
				button = function()
					hpot_event_gambling_func(10, event)
				end,
				func = function()
					return G.GAME.dollars >= 10
				end
			},
			{
				key = "bet20",
				button = function()
					hpot_event_gambling_func(20, event)
				end,
				func = function()
					return G.GAME.dollars >= 20
				end
			},
			{
				key = "bet40",
				button = function()
					hpot_event_gambling_func(40, event)
				end,
				func = function()
					return G.GAME.dollars >= 40
				end
			},
			{
				key = "stop",
				button = hpot_event_end_scenario,
			}
		}
	end,
}

HotPotato.EventStep {
	key = "gambling_finish_pos",
	hide_hand = true,
	loc_txt = {
		text = {
			"Maybe stop while you're ahead..."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
}

HotPotato.EventStep {
	key = "gambling_finish_neg",
	hide_hand = true,
	loc_txt = {
		text = {
			"You want to keep going by your brain knows better..."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
}

--#endregion

--#region PBA 10

local random_pack_tag = function(seed)
	return pseudorandom_element({
		"tag_hpot_mega_hanafuda",
		"tag_hpot_mega_auras",
		"tag_hpot_job",
		"tag_buffoon",
		"tag_charm",
		"tag_ethereal",
		"tag_meteor",
		"tag_standard"
	}, seed or "hpot_pack_tag")
end

HotPotato.EventScenario {
	key = "pba10",
	loc_txt = {
		name = "PBA 10",
		text = {
			"Sometimes the hobby is to ruin the hobby"
		}
	},
	domains = { wealth = true },
	starting_step_key = "hpot_pba10_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "pba10_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"Dude, you gotta check this out. This is crazy!",
			"My Trading Card got rated a PBA 10! This is gonna sell for thousands!\"",
			" ",
			"\"What? Playing? Of course I'm not playing! This is an investment!\"",
			" ",
			"\"Here, take some of my packs. They will give you the rush.",
			"Oh, and don't worry I already weighted them."
		},
		choices = {
			accept = "Take packs"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "accept",
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function(self, event)
		local chara = Character("j_trading")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end,
	finish = function(self, event)
		for i = 1, 3 do
			add_tag(Tag(random_pack_tag("hpot_event_pba10")))
		end
	end
}

--#endregion

--- Escapade

--#region Small Seed

HotPotato.EventScenario {
	key = "small_seed",
	loc_txt = {
		name = "Small Seed",
		text = {
			"All you need to change the future"
		}
	},
	domains = { escapade = true },
	starting_step_key = "hpot_small_seed_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "small_seed_start",
	hide_image_area = true,
	hide_hand = true,
	loc_txt = {
		text = {
			"On your way to the next blind you see a small sapling.",
			" ",
			"What do you do?"
		},
		choices = {
			water = "Water it",
			ignore = "Ignore it"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "water",
				button = function()
					event.start_step("hpot_small_seed_water")
				end,
			},
			{
				key = "ignore",
				button = function()
					event.start_step("hpot_small_seed_ignore")
				end,
			},
		}
	end,
}

HotPotato.EventStep {
	key = "small_seed_water",
	hide_hand = true,
	loc_txt = {
		text = {
			"Changing the world one nice act at the time.",
			" ",
			"You feel a change in your deck."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		local editionless_cards = SMODS.Edition:get_edition_cards(G.deck, true)

		local choice = pseudorandom_element(editionless_cards, "hpot_event_small_seed")
		if choice then
			choice:set_edition("e_negative")
		end
	end
}

HotPotato.EventStep {
	key = "small_seed_ignore",
	hide_hand = true,
	loc_txt = {
		text = {
			"So that's the kind of person you are, huh?",
			" ",
			"You feel a change in your deck."
		},
	},
	get_choices = function(self, event)
		return {
			moveon()
		}
	end,
	start = function(self, event)
		for _, pcard in ipairs(G.playing_cards) do
			if pcard.ability.set == "Default" then
				pcard:set_ability("m_glass")
			end
		end
	end
}

--#endregion

--#region Ruan Mei

HotPotato.EventScenario {
	key = "ruan_mei",
	loc_txt = {
		name = "Ruan Mei",
		text = {
			"Don't tell Herta and Screwllum about this."
		}
	},
	domains = { escapade = true },
	starting_step_key = "hpot_ruan_mei_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "ruan_mei_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"You catch a whiff of the aroma of warm pastries.",
			"As you lift your feet from the ground and float",
			"towards them in a cartoonis fashion, a dark-haired lady",
			"addresses you.",
			" ",
			"\"This is the simulated lab, my miniature petri dish.",
			"I nurtured this miniature slice by myself and embedded it into the code of te game.\"",
			" ",
			"\"I'll give you some things,\" she says, ",
			"good things. But they don't come for free.\""
		},
		choices = {
			ruan_mei = "You are... Ruan Mei?",
			aeons = "Worship Aeons",
			money = "Want lots of money"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "ruan_mei",
				button = function()
					for _, joker in ipairs(G.jokers.cards) do
						if not joker.edition then
							joker:set_edition("e_negative")
						end
					end
					ease_dollars(500)
					hpot_event_end_scenario()
				end,
				func = function()
					return not not next(SMODS.find_card("j_hpot_ruan_mei"))
				end
			},
			{
				key = "aeons",
				button = function()
					for _, joker in ipairs(G.jokers.cards) do
						if not joker.edition then
							joker:set_edition("e_negative")
						end
					end
					hpot_event_end_scenario()
				end,
				func = function()
					return #SMODS.Edition:get_edition_cards(G.jokers, true) > 0
				end
			},
			{
				key = "money",
				button = function()
					ease_dollars(500)
					hpot_event_end_scenario()
				end,
			},
		}
	end,
	start = function(self, event)
		local chara = Character("j_hpot_ruan_mei")
		chara.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				chara.T.scale = chara.T.scale * 0.75
				return true
			end,
		}))
	end
}

--#endregion

--- Combat

-- TODO: turn this into an SMODS.GameObject thingy too
HotPotato.CombatEvents = {}
HotPotato.CombatEvents.test = {
	blind_key = "bl_serpent",        -- blind to face
	calculate = function(self, context) -- calculate
		if context.end_of_round and context.main_eval then
			return {
				dollars = 50
			}
		end
	end,
	defeat = function(self) -- on defeat (use for rewards)
		ease_dollars(50)
	end
}

HotPotato.CombatEvents.generic = {
	blind_key = "bl_big",
	calculate = function(self, context)
		local effect = G.GAME.blind.effect.hpot_combat_bonus
		if not effect then return end

		if context.setting_blind then
			if effect.change_size then
				G.GAME.blind.chips = G.GAME.blind.chips * effect.change_size
				G.GAME.blind.chip_text = number_format(G.GAME.blind.chips)
			end

			if effect.total_hands or effect.hands then
				ease_hands_played((effect.total_hands and (-G.GAME.round_resets.hands + effect.total_hands) or 0) +
					(effect.hands or 0))
			end

			if effect.total_discards or effect.discards then
				ease_discard((effect.total_discards and (-G.GAME.current_round.discards_left + effect.total_discards) or 0) +
					(effect.discards or 0))
			end

			effect.hpot_hands = {}
			for _, poker_hand in ipairs(G.handlist) do
				effect.hpot_hands[poker_hand] = false
			end
		end

		if context.debuff_card and effect.debuff then
			if context.debuff_card.area == G.jokers then
				if effect.debuff.jokers then
					return {
						debuff = true
					}
				end
			else
				if effect.debuff.suit and context.debuff_card:is_suit(effect.debuff.suit, true) then
					return {
						debuff = true
					}
				end
				if effect.debuff.face and context.debuff_card:is_face(true) then
					return {
						debuff = true
					}
				end
				if effect.debuff.played_this_ante and context.debuff_card.ability.played_this_ante then
					return {
						debuff = true
					}
				end
			end
		end

		if context.debuff_hand and (effect.debuff or effect.set_to_zero) then
			local set_to_zero = false
			local debuff = false
			if context.scoring_name == G.GAME.current_round.most_played_poker_hand then
				if effect.set_to_zero and effect.set_to_zero.most_played_hand then
					set_to_zero = true
				end
				if effect.debuff and effect.debuff.most_played_hand then
					debuff = true
				end
			end
			if effect.set_to_zero and context.scoring_name == effect.set_to_zero.scoring_name then
				set_to_zero = true
			end
			if effect.debuff and context.scoring_name == effect.debuff.scoring_name then
				debuff = true
			end
			if effect.no_repeat_hands then
				if effect.hpot_hands[context.scoring_name] then
					debuff = true
				end
				if not context.check then
					effect.hpot_hands[context.scoring_name] = true
				end
			end
			if effect.one_hand_type then
				if effect.hpot_only_hand and effect.hpot_only_hand ~= context.scoring_name then
					return {
						debuff = true
					}
				end
			end

			if not context.check then
				effect.hpot_only_hand = context.scoring_name
			end
			if set_to_zero then
				if not context.check then
					if effect.set_to_zero.dollars then
						ease_dollars(math.min(0, -G.GAME.dollars), true)
					end
					if effect.set_to_zero.plincoins then
						ease_plincoins(math.min(0, -G.GAME.plincoins), true)
					end
					if effect.set_to_zero.credits then
						HPTN.ease_credits(math.min(0, -G.PROFILES[G.SETTINGS.profile].TNameCredits), true)
					end
					if effect.set_to_zero.sparkle then
						ease_spark_points(math.min(0, -G.GAME.spark_points), true)
					end
					if effect.set_to_zero.crypto then
						ease_cryptocurrency(math.min(0, -G.GAME.cryptocurrency), true)
					end
				end
			end
			if debuff then
				return {
					debuff = true
				}
			end
		end

		if context.stay_flipped and context.to_area == G.hand and effect.flipped then
			if effect.flipped.suit and context.other_card:is_suit(effect.flipped.suit, true) then
				return {
					stay_flipped = true
				}
			end
			if effect.flipped.face and context.other_card:is_face(true) then
				return {
					stay_flipped = true
				}
			end
			if effect.flipped.played_this_ante and context.other_card.ability.played_this_ante then
				return {
					stay_flipped = true
				}
			end
			if effect.flipped.first_hand and
				G.GAME.current_round.hands_played == 0 and G.GAME.current_round.discards_used == 0 then
				return {
					stay_flipped = true
				}
			end
		end

		if context.modify_hand then
			if effect.base_score_halved then
				mult = mod_mult(math.max(math.floor(mult * 0.5 + 0.5), 1))
				hand_chips = mod_chips(math.max(math.floor(hand_chips * 0.5 + 0.5), 0))
				update_hand_text({ sound = 'chips2', modded = true }, { chips = hand_chips, mult = mult })
			end
		end
	end,
	defeat = function(self)
		local reward = (G.GAME.blind.effect.hpot_combat_bonus or {}).reward
		if not reward then return end

		if reward.jokers then
			for _, joker in ipairs(reward.jokers) do
				for i = 1, (joker.amount or 1) do
					if not joker.need_room or (#G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit) then
						SMODS.add_card { set = "Joker", rarity = joker.rarity, edition = joker.edition, no_edition = joker.no_edition, stickers = joker.stickers, key_append = joker.key_append or "hpot_combat_reward", key = joker.key, area = G.jokers }
					end
				end
			end
		end

		if reward.consumables then
			for _, consumable in ipairs(reward.consumables) do
				for i = 1, (consumable.amount or 1) do
					if not consumable.need_room or (#G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit) then
						SMODS.add_card { set = consumable.set, edition = consumable.edition, key_append = consumable.key_append or "hpot_combat_reward", key = consumable.key, area = G.consumeables }
					end
				end
			end
		end

		if reward.tags then
			for _, tag_key in ipairs(reward.tags.keys or {}) do
				add_tag(Tag(tag_key, false, 'Small'))
			end
			if reward.tags.random_amount then
				local tag_pool = get_current_pool('Tag')
				for i = 1, reward.tags.random_amount do
					local selected_tag = pseudorandom_element(tag_pool, 'hpot_combat_reward')
					local it = 1
					while selected_tag == 'UNAVAILABLE' do
						it = it + 1
						selected_tag = pseudorandom_element(tag_pool, 'hpot_combat_reward_resample' .. it)
					end
					add_tag(Tag(selected_tag, false, 'Small'))
				end
			end
		end

		if reward.vouchers then
			local vouchers_to_redeem = {}
			for _, voucher_key in ipairs(reward.vouchers.keys or {}) do
				vouchers_to_redeem[#vouchers_to_redeem + 1] = voucher_key
			end
			if reward.vouchers.random_amount then
				local voucher_pool = get_current_pool('Voucher')
				for i = 1, reward.vouchers.random_amount do
					local selected_voucher = pseudorandom_element(voucher_pool, 'modprefix_seed')
					local it = 1
					while selected_voucher == 'UNAVAILABLE' do
						it = it + 1
						selected_voucher = pseudorandom_element(voucher_pool, 'modprefix_seed' .. it)
					end
					vouchers_to_redeem[#vouchers_to_redeem + 1] = selected_voucher
				end
			end
			for _, voucher_key in ipairs(vouchers_to_redeem) do
				local voucher_card = SMODS.create_card({ area = G.play, key = voucher_key })
				voucher_card:start_materialize()
				voucher_card.cost = 0
				G.play:emplace(voucher_card)
				delay(0.8)
				voucher_card:redeem()

				G.E_MANAGER:add_event(Event({
					trigger = 'after',
					delay = 0.5,
					func = function()
						voucher_card:start_dissolve()
						return true
					end
				}))
			end
		end

		if reward.playing_cards then
			for _, pcard in ipairs(reward.playing_cards) do
				for i = 1, (pcard.amount or 1) do
					-- TODO: account for modded ranks I guess
					local rank = pcard.rank or
						(pcard.face and pseudorandom_element({ "King", "Queen", "Jack" }, "hpot_event_combat_reward")) or
						(pcard.numbered and tostring(pseudorandom("hpot_event_combat_reward", 2, 10)))
					SMODS.add_card { set = (pcard.enhanced and "Enhanced") or (pcard.base and "Base") or "Playing Card", edition = pcard.edition, stickers = pcard.stickers, enhancement = pcard.enhancement, key_append = pcard.key_append or "hpot_combat_reward", rank = rank, suit = pcard.suit, seal = pcard.seal, area = G.deck }
				end
			end
		end

		if reward.enhance_deck then
			for _, mod in ipairs(reward.enhance_deck) do
				local amount = mod.amount or 1
				local valid_cards = {}
				local chosen_cards = {}
				local conditions = mod.conditions or {}

				for _, pcard in ipairs(G.playing_cards) do
					local valid = true
					if conditions.suits then
						local has_suit = false
						for _, suit in ipairs(conditions.suits) do
							if pcard:is_suit(suit) then
								has_suit = true
								break
							end
						end
						if not has_suit then valid = false end
					end
					if valid and conditions.ranks then
						local has_rank = false
						for _, rank in ipairs(conditions.ranks) do
							if pcard.base.value == rank then
								has_rank = true
								break
							end
						end
						if not has_rank then valid = false end
					end
					if valid and conditions.no_enhancement then
						if pcard.ability.set == "Enhanced" then
							valid = false
						end
					end
					if valid and conditions.no_edition then
						if pcard.edition then
							valid = false
						end
					end
					if valid and conditions.no_seal then
						if pcard.seal then
							valid = false
						end
					end
					if valid then
						valid_cards[#valid_cards + 1] = pcard
					end
				end

				for i = 1, amount do
					local chosen = pseudorandom_element(valid_cards, "hpot_event_combat_reward")
					chosen_cards[#chosen_cards + 1] = chosen
				end

				for _, pcard in ipairs(chosen_cards) do
					if mod.change_base then
						-- TODO: account for modded ranks I guess
						local rank = mod.change_base.rank or
							(mod.change_base.face and pseudorandom_element({ "King", "Queen", "Jack" }, "hpot_event_combat_reward")) or
							(mod.change_base.numbered and tostring(pseudorandom("hpot_event_combat_reward", 2, 10)))
						assert(SMODS.change_base(pcard, mod.change_base.suit, rank))
					end
					if mod.edition then
						pcard:set_edition(mod.edition)
					end
					if mod.enhancement then
						pcard:set_ability(mod.enhancement)
					end
					if mod.seal then
						pcard:set_seal(mod.seal)
					end
				end
			end
		end

		if reward.dollars then
			ease_dollars(reward.dollars)
		end
		if reward.plincoins then
			ease_dollars(reward.plincoins)
		end
		if reward.credits then
			HPTN.ease_credits(reward.credits)
		end
		if reward.sparkle then
			ease_spark_points(reward.sparkle)
		end
		if reward.crypto then
			ease_cryptocurrency(reward.crypto)
		end

		if reward.level_up_hand then
			SMODS.smart_level_up_hand(nil, reward.level_up_hand.key, nil, reward.level_up_hand.amount)
		end
	end
}

local hpot_event_get_random_boss = function(seed)
	local eligible_bosses = {}
	for k, v in pairs(G.P_BLINDS) do
		local res, options = SMODS.add_to_pool(v)
		eligible_bosses[k] = res and true or nil
	end
	for k, v in pairs(G.GAME.banned_keys) do
		if eligible_bosses[k] then eligible_bosses[k] = nil end
	end
	local _, boss = pseudorandom_element(eligible_bosses, seed or "hpot_event_boss")
	return boss or "bl_wall"
end

local hpot_event_get_random_combat_effect = function(seed)
	-- TODO: localize these
	local effects = {
		{ change_size = 2,                                           text = "but Blind size is doubled" },
		{ total_hands = 1,                                           text = "with only 1 hand" },
		{ total_discards = 0,                                        text = "with 0 discards" },
		{ debuff = { jokers = true },                                text = "but all Jokers are debuffed" },
		{ debuff = { suit = true },                                  text = "but all [suit] are debuffed" }, -- not valid, randomizes later
		{ debuff = { face = true },                                  text = "but all face cards are debuffed" },
		{ debuff = { played_this_ante = true },                      text = "but all cards played this ante are debuffed" },
		{ debuff = { most_played_hand = true },                      text = "but " .. localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') .. " is not allowed" },
		{ set_to_zero = { most_played_hand = true, dollars = true }, text = "but playing " .. localize(G.GAME.current_round.most_played_poker_hand, 'poker_hands') .. " sets money to 0" },
		{ no_repeat_hands = true,                                    text = "but no repeat hand types" },
		{ one_hand_type = true,                                      text = "but ony one hand type can be played" },
		{ flipped = { suit = true },                                 text = "but all [suit] are drawn facedown" }, -- not valid, randomizes later
		{ flipped = { face = true },                                 text = "but all face cards are drawn facedown" },
		{ flipped = { played_this_ante = true },                     text = "but all cards played this ante are drawn facedown" },
		{ flipped = { first_hand = true },                           text = "but first hand is drawn facedown" },
		{ base_score_halved = true,                                  text = "but base Chips and Mult are halved" },
	}

	local chosen_effect = pseudorandom_element(effects, seed or "hpot_event_combat_effect")
	if not chosen_effect then return end
	if chosen_effect.debuff and chosen_effect.debuff.suit then
		local suit = pseudorandom_element(SMODS.Suits, (seed or "hpot_event_combat_effect") .. "suit_debuff")
		chosen_effect.debuff.suit = (suit or {}).key or "Spades"
		chosen_effect.text = "but all " .. localize(chosen_effect.debuff.suit, "suits_plural") .. " are debuffed"
	end
	if chosen_effect.flipped and chosen_effect.flipped.suit then
		local suit = pseudorandom_element(SMODS.Suits, (seed or "hpot_event_combat_effect") .. "suit_flip")
		chosen_effect.flipped.suit = (suit or {}).key or "Diamonds"
		chosen_effect.text = "but all " .. localize(chosen_effect.flipped.suit, "suits_plural") .. " are drawn facedown"
	end

	return chosen_effect
end

local hpot_event_get_random_combat_reward = function(domain, seed)
	-- TODO: localize these
	local combat_rewards = {
		{ jokers = { { rarity = "Common" } },                                           text = "A random Common Joker (Doesn't need room)" },
		{ jokers = { { rarity = "Uncommon", need_room = true } },                       text = "A random Uncommon Joker (Must have room)" },
		{ consumables = { { set = "Tarot", need_room = true, amount = 2 } },            text = "Up to 2 random Tarot cards (Must have room)" },
		{ consumables = { { set = "Planet", need_room = true, amount = 2 } },           text = "Up to 2 random Planet cards (Must have room)" },
		{ consumables = { { set = "bottlecap_Common", need_room = true, amount = 2 } }, text = "Up to 2 random Common Bottlecaps (Must have room)" },
		{ consumables = { { set = "bottlecap_Uncommon", need_room = true } },           text = "1 random Uncommon Bottlecap (Must have room)" },
		{ consumables = { { set = "Czech", need_room = true } },                        text = "1 random Cheque card (Must have room)" },
		{ consumables = { { set = "Hanafuda", need_room = true, amount = 2 } },         text = "Up to 2 random Hanafuda cards (Must have room)" },
		{ tags = { random_amount = 2 },                                                 text = "2 random Tags" },
		{ tags = { keys = { "tag_double" } },                                           text = "A Double Tag" },
		{ dollars = 4,                                                                  text = "$4" },
		{ credits = 30,                                                                 text = "30 credits" },
		{ sparkle = 100,                                                                text = "100 Joker Exchange" },
		{ crypto = 0.5,                                                                 text = "0.5 Cryptocurrency" },
	}

	local encounter_rewards = {
		{ jokers = { { rarity = "Uncommon" } },                                           text = "A random Uncommon Joker (Doesn't need room)" },
		{ jokers = { { rarity = "Rare", need_room = true } },                             text = "A random Rare Joker (Must have room)" },
		{ consumables = { { set = "Spectral", need_room = true, amount = 2 } },           text = "1 random Spectral card (Must have room)" },
		{ consumables = { { set = "bottlecap_Uncommon", need_room = true, amount = 2 } }, text = "Up to 2 random Uncommon Bottlecaps (Must have room)" },
		{ consumables = { { set = "bottlecap_Rare", need_room = true } },                 text = "1 random Rare Bottlecap (Must have room)" },
		{ consumables = { { set = "Czech", need_room = true, amount = 2 } },              text = "Up to 2 random Cheque cards (Must have room)" },
		{ tags = { random_amount = 5 },                                                   text = "5 random Tags" },
		{ tags = { keys = { "tag_double", "tag_double" } },                               text = "2 Double Tags" },
		{ dollars = 8,                                                                    text = "$8" },
		{ credits = 100,                                                                  text = "100 credits" },
		{ sparkle = 300,                                                                  text = "300 Joker Exchange" },
		{ crypto = 2,                                                                     text = "2 Cryptocurrency" },
	}

	local _handname, _played = 'High Card', -1
	for hand_key, hand in pairs(G.GAME.hands) do
		if hand.played > _played then
			_played = hand.played
			_handname = hand_key
		end
	end
	local most_played = _handname

	combat_rewards[#combat_rewards + 1] = {
		level_up_hand = { key = most_played, amount = 2 },
		text = "Level up " ..
			localize(most_played, "poker_hands") .. " 2 times"
	}
	encounter_rewards[#encounter_rewards + 1] = {
		level_up_hand = { key = most_played, amount = 4 },
		text = "Level up " ..
			localize(most_played, "poker_hands") .. " 4 times"
	}

	local _poker_hands = {}
	for handname, _ in pairs(G.GAME.hands) do
		if SMODS.is_poker_hand_visible(handname) and handname ~= most_played then
			_poker_hands[#_poker_hands + 1] = handname
		end
	end

	local chosen_hand = pseudorandom_element(_poker_hands, seed or "hpot_event_combat_reward")

	if chosen_hand then
		combat_rewards[#combat_rewards + 1] = {
			level_up_hand = { key = chosen_hand, amount = 2 },
			text = "Level up " ..
				localize(chosen_hand, "poker_hands") .. " 2 times"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			level_up_hand = { key = chosen_hand, amount = 4 },
			text = "Level up " ..
				localize(chosen_hand, "poker_hands") .. " 4 times"
		}
	end

	local add_rank = pseudorandom("hpot_event_combat_reward", 1, 3)
	local add_enhancement = SMODS.poll_enhancement({ guaranteed = true })
	local add_seal = SMODS.poll_seal({ guaranteed = true }) or "Red"

	local add_rank_text = (add_rank == 1 and "Ace") or (add_rank == 2 and "Face card") or "Numbered card"
	local add_enhancement_text = localize { type = "name_text", set = "Enhanced", key = add_enhancement }
	local add_seal_text = localize { type = "name_text", set = "Other", key = add_seal:lower() .. "_seal" }

	if pseudorandom("hpot_event_combat_reward") < 0.5 then
		combat_rewards[#combat_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					edition = "e_foil",
					amount = 2
				}
			},
			text = "Add 2 random Foil " .. add_rank_text .. "s to the deck"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					edition = "e_holo",
					amount = 2
				}
			},
			text = "Add 2 random Holographic " .. add_rank_text .. "s to the deck"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					edition = "e_polychrome",
					amount = 1
				}
			},
			text = "Add 1 random Polychrome " .. add_rank_text .. " to the deck"
		}
		combat_rewards[#combat_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					enhanced = true,
					amount = 2
				}
			},
			text = "Add 2 random Enhanced " .. add_rank_text .. "s to the deck"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					enhanced = true,
					amount = 5
				}
			},
			text = "Add 5 random Enhanced " .. add_rank_text .. "s to the deck"
		}
		combat_rewards[#combat_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					enhancement = add_enhancement,
					amount = 2
				}
			},
			text = "Add 2 random " .. add_enhancement_text .. " " .. add_rank_text .. "s to the deck"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					enhancement = add_enhancement,
					amount = 5
				}
			},
			text = "Add 5 random " .. add_enhancement_text .. " " .. add_rank_text .. "s to the deck"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			playing_cards = {
				{
					rank = add_rank == 1 and "Ace" or nil,
					face = add_rank == 2 or nil,
					numbered = add_rank == 3 or nil,
					seal = add_seal,
					amount = 2
				}
			},
			text = "Add 2 random " .. add_seal_text .. " " .. add_rank_text .. "s to the deck"
		}
	else
		combat_rewards[#combat_rewards + 1] = {
			enhance_deck = {
				{
					edition = "e_foil",
					amount = 2
				}
			},
			text = "Turn 2 random cards in deck Foil"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			enhance_deck = {
				{
					edition = "e_holo",
					amount = 2
				}
			},
			text = "Turn 2 random cards in deck Holographic"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			enhance_deck = {
				{
					edition = "e_polychrome",
					amount = 1
				}
			},
			text = "Turn a random card in deck Polychrome"
		}
		combat_rewards[#combat_rewards + 1] = {
			enhance_deck = {
				{
					change_base = {
						rank = add_rank == 1 and "Ace" or nil,
						face = add_rank == 2 or nil,
						numbered = add_rank == 3 or nil,
					},
					enhancement = add_enhancement,
					amount = 1
				}
			},
			text = "Change a random card in deck into a " .. add_enhancement_text .. " " .. add_rank_text
		}
		encounter_rewards[#encounter_rewards + 1] = {
			enhance_deck = {
				{
					change_base = {
						rank = add_rank == 1 and "Ace" or nil,
						face = add_rank == 2 or nil,
						numbered = add_rank == 3 or nil,
					},
					enhancement = add_enhancement,
					amount = 3
				}
			},
			text = "Change 3 random cards in deck into " .. add_enhancement_text .. " " .. add_rank_text .. "s"
		}
		encounter_rewards[#encounter_rewards + 1] = {
			enhance_deck = {
				{ seal = add_seal }
			},
			text = "Add " .. add_seal_text .. "to a random card in the deck"
		}
	end

	return pseudorandom_element(domain == "encounter" and encounter_rewards or combat_rewards,
		seed or "hpot_event_combat_reward")
end

HotPotato.EventScenario {
	key = "the_tavern",
	hide_image_area = true,
	loc_txt = {
		name = "The Tavern",
		text = {
			"You think you can be in this part of town",
			"looking all cool? Yes, you can."
		}
	},
	domains = { combat = true, encounter = true },
	starting_step_key = "hpot_the_tavern_start",
	hotpot_credits = {
		code = { "N'" },
		team = { "Pissdrawer" },
	},
}

HotPotato.EventStep {
	key = "the_tavern_start",
	hide_hand = true,
	loc_txt = {
		text = {
			"\"This person over here thinks they're so tough.\"",
			" ",
			"\"Really? Let's see you beat this.\"",
			" ",
			"Face {C:attention}#1#{} #2#",
			"{C:money}Reward:{} #3#",
			"{C:inactive}(Regular Blind rewards are also obtained){}"
		},
		choices = {
			fight = "Fight!",
		}
	},
	loc_vars = function(self, event)
		if not event.ability.blind then -- very hacky. dont like it
			event.ability.blind = event.domain == "encounter" and hpot_event_get_random_boss() or "bl_big"
			event.ability.effect = hpot_event_get_random_combat_effect()
			event.ability.effect.reward = hpot_event_get_random_combat_reward(event.domain)
		end
		return { localize { type = 'name_text', key = event.ability.blind or "bl_big", set = 'Blind' },
			event.ability.effect.text or "", event.ability.effect.reward.text or "" }
	end,
	get_choices = function(self, event)
		return {
			{
				key = "fight",
				button = function()
					hpot_event_start_combat("generic", event.ability.blind, event.ability.effect)
				end,
			},
			moveon()
		}
	end,
}

--- Encounter

--- Adventure

--#region Black Jack

HotPotato.EventScenario {
	key = "bj",
	loc_txt = {
		name = "Blackjack",
		text = {
			"What's 9+10?"
		}
	},
	domains = { adventure = true },
	starting_step_key = "hpot_bj_in",
	hotpot_credits = {
		code = { "fey <3" },
		team = { "Pissdrawer" },
	},
	in_pool = function()
		if #G.deck.cards >= 2 and G.GAME.dollars > 0 then return true end
	end,
}

HotPotato.EventStep {
	key = "hpot_bj_in",
	hide_hand = false,
	loc_txt = {
		text = {
			"You see a shady figure with a set of cards",
			"infront of him, a 'normal' 52 card deck.",
			'',
			"\"Up for a game of Black Jack, pal?\" He sounds",
			"like he's straight out of the 'slammer'..."
		},
		choices = {
			start = "I'm all in!",
			stop = "On second thought, maybe not..."
		}
	},
	start = function(self, event)
		G.GAME.BJ_CARDS = { TOTAL = 0 }
		local to = Character("j_ring_master")
		to.states.collide.can = false
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			blockable = false,
			blocking = false,
			func = function()
				to.T.scale = to.T.scale * 0.75
				return true
			end,
		}))
	end,
	get_choices = function(self, event)
		return {
			{
				key = "start",
				button = function()
					event.start_step('hpot_bj_start')
				end
			},
			{
				key = "stop",
				button = function()
					hpot_event_end_scenario()
				end
			},
		}
	end
}

HotPotato.EventStep {
	key = "hpot_bj_start",
	hide_hand = false,
	start = function(self, event)
		G.GAME.BJ_CARDS.MONEY = G.GAME.dollars
		ease_dollars(-G.GAME.dollars)
		G.GAME.BJ_CARDS.HANDSIZE = G.hand.config.card_limit

		G.hand:change_size(2 - G.hand.config.card_limit)

		G.E_MANAGER:add_event(Event({
			func = function()
				G.FUNCS.draw_from_deck_to_hand()
				return true;
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.BJ_CARDS.DEALER_CARDS = { SMODS.create_card { set = "Base" }, SMODS.create_card { set = "Base" } }
				G.GAME.BJ_CARDS.DEALER = G.GAME.BJ_CARDS.DEALER_CARDS[1].base.nominal +
					G.GAME.BJ_CARDS.DEALER_CARDS[2].base.nominal
				G.GAME.BJ_CARDS.DEALER_CARDS[2]:flip()
				G.GAME.BJ_CARDS.DEALER_CARDS[1].T.x = 9.52; G.GAME.BJ_CARDS.DEALER_CARDS[1].T.y = 3.9
				G.GAME.BJ_CARDS.DEALER_CARDS[2].T.x = 11.52; G.GAME.BJ_CARDS.DEALER_CARDS[2].T.y = 3.9
				return true
			end
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				event.start_step("hpot_bj_check")
				return true;
			end
		}))
	end
}

HotPotato.EventStep {
	key = "hpot_bj_hit",
	hide_hand = false,
	start = function(self, event)
		draw_card(G.deck, G.hand, 1, 'up', true)
		event.start_step('hpot_bj_check')
	end
}

HotPotato.EventStep {
	key = "hpot_bj_check",
	hide_hand = false,
	loc_txt = {
		choices = {
			hit = "Lady Luck gimme a kiss! (Hit)",
			stand = "Wee hee hee! (Stand)"
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = 'hit',
				button = function()
					event.start_step('hpot_bj_hit')
				end,
				func = function()
					return G.GAME.BJ_CARDS.TOTAL < 21
				end
			},
			{
				key = 'stand',
				button = function()
					event.start_step('hpot_bj_eval')
				end
			}
		}
	end,
	start = function(self, event)
		local count = 0
		for i, v in ipairs(G.hand.cards) do
			if count + v.base.nominal > 21 and v.base.name == 'Ace' then
				count = count + 1
			else
				count = count + v.base.nominal
			end
		end
		G.GAME.BJ_CARDS.TOTAL = count
	end
}

HotPotato.EventStep {
	key = "hpot_bj_eval",
	hide_hand = false,
	start = function(self, event)
		G.GAME.BJ_CARDS.DEALER_CARDS[2]:flip()
		local count = 0
		for i, v in ipairs(G.hand.cards) do
			if count + v.base.nominal > 21 and v.base.name == 'Ace' then
				count = count + 1
			else
				count = count + v.base.nominal
			end
		end
		G.GAME.BJ_CARDS.TOTAL = count
		G.GAME.BJ_CARDS.FINAL_MONEY = 0
		if G.GAME.BJ_CARDS.TOTAL <= 21 and G.GAME.BJ_CARDS.TOTAL > G.GAME.BJ_CARDS.DEALER then
			G.GAME.BJ_CARDS.WON = true
			G.GAME.BJ_CARDS.FINAL_MONEY = G.GAME.BJ_CARDS.MONEY * 2
		end
		event.start_step("hpot_bj_final")
	end
}

HotPotato.EventStep {
	key = "hpot_bj_final",
	hide_hand = false,
	loc_txt = {
		text = {
			"Looks like you #1# {C:money}$#2#{}!"
		},
		choices = {
			cashin = 'Cash in!'
		}
	},
	get_choices = function(self, event)
		return {
			{
				key = "cashin",
				button = function()
					ease_dollars(G.GAME.BJ_CARDS.FINAL_MONEY)
					G.GAME.BJ_CARDS.DEALER_CARDS[1]:remove()
					G.GAME.BJ_CARDS.DEALER_CARDS[2]:remove()
					hpot_event_end_scenario()
				end
			}
		}
	end,
	loc_vars = function(self)
		return {
			vars = {
				G.GAME.BJ_CARDS.WON and 'won' or 'lost',
				G.GAME.BJ_CARDS.FINAL_MONEY
			}
		}
	end,
	finish = function(self, event)
		G.E_MANAGER:add_event(Event({
			func = function()
				G.FUNCS.draw_from_hand_to_deck()
				G.deck:shuffle('bj' .. G.GAME.round_resets.ante)

				G.hand:change_size(G.GAME.BJ_CARDS.HANDSIZE - 2)
				G.GAME.BJ_CARDS.HANDSIZE = nil
				return true
			end
		}))
	end
}

--#endregion

--- Transaction/Respite

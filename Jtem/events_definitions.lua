-- Scenario by default
SMODS.EventStep({
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
	get_choices = function()
		return {
			{
				-- Loc key: G.localization.misc.EventChoices.hpot_nothing_1_go
				-- <modprefix>_<stepkey>_<key>
				key = "go",
				button = hpot_event_end_scenario,
			},
		}
	end,
})
SMODS.EventScenario({
	key = "nothing",
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
SMODS.EventStep({
	key = "test_1",

	config = {
		extra = {
			rich = 25,
			gain = 5,
			gain_rich = 10,
		},
	},

	get_choices = function(self)
		return {
			{
				key = "lose",
				button = function()
					hpot_event_start_step("hpot_test_2")
				end,
			},
			{
				key = "gain_rich",
				loc_vars = { self.config.extra.rich },
				button = function()
					ease_dollars(self.config.extra.gain_rich)
					-- Object which resets between event scenarios
					-- So you can use it to transfer data between steps, if you need
					G.GAME.hpot_event_scenario_data.money_gain = self.config.extra.gain_rich
					hpot_event_start_step("hpot_test_3")
				end,
				func = function()
					return G.GAME.dollars >= self.config.extra.rich
				end,
			},
			{
				key = "gain",
				button = function()
					ease_dollars(self.config.extra.gain)
					G.GAME.hpot_event_scenario_data.money_gain = self.config.extra.gain
					hpot_event_start_step("hpot_test_3")
				end,
			},
		}
	end,
	start = function(self, scenario, previous_step)
		hpot_event_display_lines(2, true)
		delay(1)
		local x, y = get_hpot_event_image_center()
		local jimbo_card = Card_Character({
			x = x,
			y = y,
			center = G.P_CENTERS.j_joker,
		})
		G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
		hpot_event_display_lines(1, true)
		jimbo_card:say_stuff(3)
		delay(1)
		hpot_event_display_lines(1, true)
		jimbo_card:say_stuff(2)
		G.FUNCS.draw_from_deck_to_hand(3)
	end,
	finish = function(self)
		local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					G.hpot_event_ui_image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})
SMODS.EventStep({
	key = "test_2",
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function()
		if #G.hand.cards > 0 then
			SMODS.destroy_cards(G.hand.cards)
		end
	end,
})
SMODS.EventStep({
	key = "test_3",
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	loc_vars = function(self)
		return { G.GAME.hpot_event_scenario_data.money_gain }
	end,
})

SMODS.EventScenario({
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

local Character = function(key)
	local x, y = get_hpot_event_image_center()
	local jimbo_card = Card_Character({
		x = x,
		y = y,
		center = key,
	})
	G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
	return jimbo_card
end

local Remove = function()
	local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
	if jimbo_card then
		G.E_MANAGER:add_event(Event({
			func = function()
				jimbo_card:remove()
				G.hpot_event_ui_image_area.children.jimbo_card = nil
				return true
			end,
		}))
	end
end

-- Trade

SMODS.EventStep({
	key = "pelter",
	get_choices = function()
		return {
			{
				key = "hpot_multi_tradenone",
				no_prefix = true,
				button = hpot_event_end_scenario,
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
					hpot_event_start_step("hpot_tradedreams")
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
					hpot_event_start_step("hpot_tradeduck")
				end,
			},
		}
	end,
	start = function(self, scenario, previous_step)

	end,
	finish = function(self)

	end,
})

SMODS.EventStep {
	key = "tradedreams",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, scenario, previous_step)
		Character("c_hpot_imag_stars")
	end,
	finish = function(self)
		Remove()
	end,
}

SMODS.EventStep {
	key = "tradeduck",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, scenario, previous_step)
		Character("c_hpot_imag_duck")
	end,
	finish = function(self)
		Remove()
	end,

}

SMODS.EventScenario {
	key = "trade1",
	starting_step_key = "hpot_pelter",
}

-- Porch Pirates

SMODS.EventStep({
	key = "porch_pirate_1",
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = function()
					hpot_event_start_step("hpot_porch_pirate_2")
				end,
			},
		}
	end,
	start = function(self, scenario, previous_step)
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
	finish = function(self) end,
})
SMODS.EventStep({
	key = "porch_pirate_2",
	config = {
		extra = {
			remove = 10,
		},
	},
	get_choices = function(self)
		return {
			{
				key = "hpot_porch_pirate_protect",
				no_prefix = true,
				button = function()
					ease_dollars(-self.config.extra.remove)
					hpot_event_start_step("hpot_porch_pirate_good")
				end,
			},
			{
				key = "hpot_porch_pirate_leave",
				no_prefix = true,
				button = function()
					if pseudorandom('fuck_you') < 0.5 then
						hpot_event_start_step("hpot_porch_pirate_bad")
					else
						hpot_event_start_step("hpot_porch_pirate_phew")
					end
				end,
			},
		}
	end,
	loc_vars = function(self)
		return { self.config.extra.remove }
	end,
	start = function(self, scenario, previous_step)
	end,
	finish = function(self)
		Remove()
	end,
})
SMODS.EventStep({
	key = "porch_pirate_good",
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function(self, scenario, previous_step)
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
			local x, y = get_hpot_event_image_center()
			local jimbo_card = Card_Character({
				x = x,
				y = y,
				center = delivery.config.center.key,
			})
			G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
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
	finish = function(self)
		local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					G.hpot_event_ui_image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})
SMODS.EventStep({
	key = "porch_pirate_bad",
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function(self, scenario, previous_step)
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
			local x, y = get_hpot_event_image_center()
			local jimbo_card = Card_Character({
				x = x,
				y = y,
				center = delivery.config.center.key,
			})
			G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
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
	finish = function(self)
		local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					G.hpot_event_ui_image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})
SMODS.EventStep({
	key = "porch_pirate_phew",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, scenario, previous_step) end,
	finish = function(self) end,
})

SMODS.EventScenario {
	key = "porch_pirate",
	starting_step_key = "hpot_porch_pirate_1",
	in_pool = function()
		return G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue > 0
	end
}

-- Taxes

local function taxcalc(d)
	d = d or 0
	if not G.GAME then return 0 end
	G.GAME.CurrentInflation = G.GAME.CurrentInflation or 0.5
	return d * (G.GAME.CurrentInflation * (1 + (1 / 12.4))) + math.sqrt(G.GAME.CurrentInflation)
end

SMODS.EventStep {
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

SMODS.EventStep({
	key = "postman_1",
	get_choices = function()
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
					hpot_event_end_scenario()
				end,
			},
		}
	end,
	start = function(self, scenario, previous_step)
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
	finish = function(self)
		local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					G.hpot_event_ui_image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end,
})

SMODS.EventScenario {
	key = "postman",
	starting_step_key = "hpot_postman_1",
	in_pool = function()
		return G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue > 0 and G.jokers and
		#G.jokers.cards < G.jokers.config.card_limit
	end
}

SMODS.EventStep({
	key = "voucher_1",
	get_choices = function()
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
						local vouch = pseudorandom_element(valid, 'vouch_'..G.GAME.round_resets.ante)
						G.GAME.hpot_event_scenario_data.voucher = vouch
						G.GAME.hpot_voucher_taken = G.GAME.hpot_event_scenario_data.voucher
						--print(G.GAME.hpot_event_scenario_data.voucher)
						hpot_event_start_step('hpot_voucher_2')
					else
						hpot_event_end_scenario()
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

SMODS.EventStep({
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
	loc_vars = function(self)
		return { localize { type = 'name_text', key = G.GAME.hpot_event_scenario_data.voucher, set = "Voucher", vars = {} } }
	end,
	start = function(self, scenario, previous_step)
		local pirate_card = Character(G.GAME.hpot_event_scenario_data.voucher)
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
		G.E_MANAGER:add_event(Event{
			func = function()
				pirate_card.children.card.cost = 0
				pirate_card.children.card:redeem()
				return true
			end
		})
	end,
	finish = function(self, scenario, previous_step)
		local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
		if jimbo_card then
			G.E_MANAGER:add_event(Event({
				func = function()
					jimbo_card:remove()
					G.hpot_event_ui_image_area.children.jimbo_card = nil
					return true
				end,
			}))
		end
	end
})

SMODS.EventScenario {
	key = "voucher",
	starting_step_key = "hpot_voucher_1",
}

SMODS.EventStep({
	key = 'spam_1',
	get_choices = function()
		return {
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function(self, scenario, previous_step)
	end,
	finish = function(self, scenario, previous_step)
		create_ads(pseudorandom('spam_spam_lovely_spam!_'..G.GAME.round_resets.ante, 10, 25))
	end
})

SMODS.EventScenario {
	key = "spam_email",
	starting_step_key = "hpot_spam_1",
}

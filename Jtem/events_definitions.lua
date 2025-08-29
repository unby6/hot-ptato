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
SMODS.EventStep({
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
SMODS.EventStep({
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

SMODS.EventStep({
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

SMODS.EventStep {
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

SMODS.EventStep {
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

SMODS.EventScenario {
	key = "trade1",
	starting_step_key = "hpot_pelter",
	hotpot_credits = {
		idea = { "Squidguset" },
		code = { "Squidguset" },
		team = { "Jtem" },
	}
}

-- Porch Pirates

SMODS.EventStep({
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
SMODS.EventStep({
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
SMODS.EventStep({
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
SMODS.EventStep({
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
SMODS.EventStep({
	key = "porch_pirate_phew",
	get_choices = function()
		return {
			moveon()
		}
	end,
	start = function(self, event) end,
	finish = function(self) end,
})

SMODS.EventScenario {
	key = "porch_pirate",
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

SMODS.EventScenario {
	key = "postman",
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

SMODS.EventStep({
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
						local vouch = pseudorandom_element(valid, 'vouch_'..G.GAME.round_resets.ante)
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
		G.E_MANAGER:add_event(Event{
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

SMODS.EventScenario {
	key = "voucher",
	starting_step_key = "hpot_voucher_1",
	hotpot_credits = {
		idea = { "MissingNumber" },
		code = { "Haya", "SleepyG11" },
		team = { "Jtem" },
	},
}

-- Spam

SMODS.EventStep({
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
		create_ads(pseudorandom('spam_spam_lovely_spam!_'..G.GAME.round_resets.ante, 10, 25))
	end
})

SMODS.EventScenario {
	key = "spam_email",
	starting_step_key = "hpot_spam_1",
	hotpot_credits = {
		idea = { "MissingNumber" },
		code = { "Haya", "SleepyG11" },
		team = { "Jtem" },
	},
}

-- Money game

SMODS.EventStep({
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
SMODS.EventScenario({
    key = "money_game",
    starting_step_key = "hpot_money_game_invest",

    in_pool = function(self)
        return G.jokers and #G.jokers.cards < G.jokers.config.card_limit
    end,
})


-- nigerian prince
SMODS.EventStep {
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

SMODS.EventStep {
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
        			return G.GAME.spark_points > 25000
                end,
            },
		}
	end
}
SMODS.EventStep {
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

SMODS.EventStep {
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

SMODS.EventScenario({
    key = "nigerian_prince",
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

SMODS.EventStep({
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
SMODS.EventStep({
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
SMODS.EventStep({
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
SMODS.EventStep({
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
SMODS.EventStep({
    key = "food_trade_choose",
    get_choices = function(self, event)
        return {
            {
                key = "ignore",
                button = function ()
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
                    return get_food_joker() and G.consumeables and G.consumeables.config.card_limit - #G.consumeables.cards >= 2
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
                    return get_food_joker() and G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit
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

SMODS.EventScenario({
    key = "food_trade",
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

SMODS.EventStep({
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
SMODS.EventStep({
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

SMODS.EventScenario {
	key = "currency_exchange",
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

SMODS.EventStep({
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

SMODS.EventStep({
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

SMODS.EventScenario {
	key = "sticker_master_e",
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
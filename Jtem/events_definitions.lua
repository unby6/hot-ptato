-- Scenario by default
SMODS.EventStep({
	key = "nothing_1",
	loc_txt = {
		text = {
			"Looks like there's nothing here...",
		},
		choices = {
			go = "...Go?",
		},
	},
	config = {},
	get_choices = function()
		return {
			{
				key = "go",
				button = hpot_event_end_scenario,
			},
		}
	end,
})
SMODS.EventScenario({
	key = "nothing",
	starting_step_key = "hpot_nothing_1",

	weight = 0,
	in_pool = function()
		return false
	end,
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
		local x = G.hpot_event_ui_image_area.T.x + G.hpot_event_ui_image_area.T.w / 2 - G.CARD_W / 2
		local y = G.hpot_event_ui_image_area.T.y + G.hpot_event_ui_image_area.T.h / 2 - G.CARD_H / 2
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
	in_pool = function ()
		return false
	end
})

--------- Example above

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
				loc_vars = {localize { type = 'name_text', key = "c_hpot_imag_stars", set = "imaginary" }},
				func = function ()
					return next(SMODS.find_card("c_hpot_imag_stars"))
				end,
				button = function()
					SMODS.find_card("c_hpot_imag_stars")[1]:start_dissolve()
					G.hand:change_size(1)
					hpot_event_end_scenario()
				end,
			},
			{
				key = "hpot_multi_tradecard",
				no_prefix = true,
				loc_vars = {localize { type = 'name_text', key = "c_hpot_imag_duck", set = "imaginary" }},
				func = function ()
					return next(SMODS.find_card("c_hpot_imag_duck"))
				end,
				button = function()
					SMODS.find_card("c_hpot_imag_duck")[1]:start_dissolve()
					G.consumeables:change_size(1)
					hpot_event_end_scenario()
				end,
			},
		}
	end,
	start = function(self, scenario, previous_step)
	
	end,
	finish = function(self)
		
	end,
})

SMODS.EventScenario {
	key = "trade1",
	starting_step_key = "hpot_pelter"
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
	start = function(self, scenario, previous_step) end,
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
	start = function(self, scenario, previous_step) end,
	finish = function(self) end,
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
		local card = pseudorandom_element(G.hp_jtem_delivery_queue.cards, 'porch_pirate_eternal_'..G.GAME.round_resets.ante)
		if card then
			card:set_perishable(false)
			card:set_eternal(true)
			local delivery = copy_card(card)
			local x = G.hpot_event_ui_image_area.T.x + G.hpot_event_ui_image_area.T.w / 2 - G.CARD_W / 2
			local y = G.hpot_event_ui_image_area.T.y + G.hpot_event_ui_image_area.T.h / 2 - G.CARD_H / 2
			local jimbo_card = Card_Character({
				x = x,
				y = y,
				center = delivery.config.center.key,
			})
			G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
			hpot_event_display_lines(1, true)
			delay(1)
			G.E_MANAGER:add_event(Event{
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
		local delivery = pseudorandom_element(G.hp_jtem_delivery_queue.cards, 'porch_pirate_steal_'..G.GAME.round_resets.ante)
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
			local x = G.hpot_event_ui_image_area.T.x + G.hpot_event_ui_image_area.T.w / 2 - G.CARD_W / 2
			local y = G.hpot_event_ui_image_area.T.y + G.hpot_event_ui_image_area.T.h / 2 - G.CARD_H / 2
			local jimbo_card = Card_Character({
				x = x,
				y = y,
				center = delivery.config.center.key,
			})
			G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
			hpot_event_display_lines(1, true)
			delay(1)
			jimbo_card:say_stuff(3)
			hpot_event_display_lines(1, true)
			G.E_MANAGER:add_event(Event{
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
			{
				key = "hpot_general_move_on",
				no_prefix = true,
				button = hpot_event_end_scenario,
			},
		}
	end,
	start = function(self, scenario, previous_step) end,
	finish = function(self) end,
})

SMODS.EventScenario {
	key = "porch_pirate",
	starting_step_key = "hpot_porch_pirate_1",
	in_pool = function ()
		return G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue > 0
	end
}
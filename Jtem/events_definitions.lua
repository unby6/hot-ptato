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
})

-- Test scenario
SMODS.EventStep({
	key = "test_1",

	config = {
		extra = {
			rich = 25,
			gain = 5,
			gain_rich = 10,
			lose = -5,
		},
	},

	get_choices = function(self)
		return {
			{
				key = "lose",
				button = function()
					ease_dollars(self.config.extra.lose)
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
})

--------- Example above

-- SMODS.EventStep({
-- 	key = "pelter",
-- 	get_choices = function()
-- 		return {
-- 			{
-- 				text = function()
-- 					return "Gain {E:1,C:money}money{} for no reason"
-- 				end,
-- 				button = function()
-- 					ease_dollars(5)
-- 					hpot_event_start_step("hpot_test_3")
-- 				end,
-- 				func = function()
-- 					return G.GAME.dollars > 100
-- 				end,
-- 			},
-- 			{
-- 				text = function()
-- 					return "Gain {E:1,C:money}money{} for no reason"
-- 				end,
-- 				button = function()
-- 					ease_dollars(5)
-- 					hpot_event_start_step("hpot_test_3")
-- 				end,
-- 			},
-- 		}
-- 	end,
-- 	start = function(self, scenario, previous_step)
-- 		hpot_event_display_lines(2, true)
-- 		delay(1)
-- 		local x = G.hpot_event_ui_image_area.T.x + G.hpot_event_ui_image_area.T.w / 2 - G.CARD_W / 2
-- 		local y = G.hpot_event_ui_image_area.T.y + G.hpot_event_ui_image_area.T.h / 2 - G.CARD_H / 2
-- 		local jimbo_card = Card_Character({
-- 			x = x,
-- 			y = y,
-- 			center = G.P_CENTERS.j_joker,
-- 		})
-- 		G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
-- 		hpot_event_display_lines(1, true)
-- 		jimbo_card:say_stuff(3)
-- 		delay(1)
-- 		hpot_event_display_lines(1, true)
-- 		jimbo_card:say_stuff(2)
-- 	end,
-- 	finish = function(self)
-- 		local jimbo_card = G.hpot_event_ui_image_area.children.jimbo_card
-- 		if jimbo_card then
-- 			G.E_MANAGER:add_event(Event({
-- 				func = function()
-- 					jimbo_card:remove()
-- 					G.hpot_event_ui_image_area.children.jimbo_card = nil
-- 					return true
-- 				end,
-- 			}))
-- 		end
-- 	end,
-- })

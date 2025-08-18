SMODS.EventStep({
	key = "test_1",
	get_choices = function()
		return {
			{
				text = function()
					return "Lose {C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(-5)
					hpot_event_start_step("hpot_test_2")
				end,
			},
			{
				text = function()
					return "Gain {E:1,C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(5)
					hpot_event_start_step("hpot_test_3")
				end,
				func = function()
					return G.GAME.dollars > 100
				end,
			},
			{
				text = function()
					return "Gain {E:1,C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(5)
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
				text = function()
					return "Move on"
				end,
				button = hpot_event_end_scenario,
				func = function()
					return true
				end,
			},
		}
	end,
})
SMODS.EventStep({
	key = "test_3",
	get_choices = function()
		return {
			{
				text = function()
					return "Move on"
				end,
				button = hpot_event_end_scenario,
			},
		}
	end,
})
--------- Example above

SMODS.EventStep({
	key = "pelter",
	get_choices = function()
		return {
			{
				text = function()
					return "Gain {E:1,C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(5)
					hpot_event_start_step("hpot_test_3")
				end,
				func = function()
					return G.GAME.dollars > 100
				end,
			},
			{
				text = function()
					return "Gain {E:1,C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(5)
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

SMODS.EventScenario({
	key = "test",
	starting_step_key = "hpot_test_1",
})

G.STATES.hpot_event_select = 198275827
G.STATES.HOTPOT_EVENT = 198275828

-- TODO: draw cards in hand api
SMODS.EventSteps = {}
SMODS.EventStep = SMODS.GameObject:extend({
	obj_table = SMODS.EventSteps,
	set = "EventSteps",
	obj_buffer = {},
	required_params = {
		"key",
	},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions.EventSteps, self.key:lower(), self.loc_txt)
	end,

	get_choices = function(self, scenario)
		return {
			{
				text = function()
					return "Leave"
				end,
				button = function()
					G.FUNCS.finish_hpot_event()
				end,
				func = function()
					return true
				end,
			},
		}
	end,

	load = function(self, scenario) end,

	start = function(self, scenario, previous_step) end,
	finish = function(self, scenario, next_step) end,

	inject = function() end,
})

SMODS.EventScenarios = {}
SMODS.EventScenario = SMODS.GameObject:extend({
	obj_table = SMODS.EventScenarios,
	set = "EventScenarios",
	obj_buffer = {},
	required_params = {
		"key",
		"starting_step_key",
	},
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions.EventScenarios, self.key:lower(), self.loc_txt)
	end,

	default_weight = 5,
	in_pool = function(self)
		return true
	end,
	get_weight = function(self)
		return self.default_weight
	end,

	inject = function(self)
		SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
	end,
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
})

-----------------

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
					start_hpot_step("hpot_test_2")
				end,
			},
			{
				text = function()
					return "Gain {E:1,C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(5)
					start_hpot_step("hpot_test_3")
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
					start_hpot_step("hpot_test_3")
				end,
			},
		}
	end,
	start = function(self, scenario, previous_step)
		hpot_step_display_next_line(2, true)
		delay(1)
		local x = G.hpot_event_ui_image_area.T.x + G.hpot_event_ui_image_area.T.w / 2 - G.CARD_W / 2
		local y = G.hpot_event_ui_image_area.T.y + G.hpot_event_ui_image_area.T.h / 2 - G.CARD_H / 2
		local jimbo_card = Card_Character({
			x = x,
			y = y,
			center = G.P_CENTERS.j_joker,
		})
		G.hpot_event_ui_image_area.children.jimbo_card = jimbo_card
		hpot_step_display_next_line(1, true)
		jimbo_card:say_stuff(3)
		delay(1)
		hpot_step_display_next_line(1, true)
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
				button = finish_hpot_event,
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
				button = finish_hpot_event,
			},
		}
	end,
})

SMODS.EventScenario({
	key = "test",
	starting_step_key = "hpot_test_1",
})

-----------------

function Game:update_hpot_event(dt)
	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.BLIND_SELECT)
		G.E_MANAGER:add_event(Event({
			func = function()
				save_run()
				return true
			end,
		}))
		G.STATE_COMPLETE = true
		G.CONTROLLER.interrupt.focus = true
		G.E_MANAGER:add_event(Event({
			func = function()
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						start_hpot_event()
						return true
					end,
				}))
				return true
			end,
		}))
	end
end
function create_UIBox_hpot_event_choice()
	local disabled = false
	local run_info = false

	local blind_choice = {
		config = G.P_BLINDS[G.GAME.round_resets.blind_choices["Big"]],
	}

	blind_choice.animation = AnimatedSprite(0, 0, 1.4, 1.4, G.ANIMATION_ATLAS["blind_chips"], blind_choice.config.pos)
	blind_choice.animation:define_draw_steps({
		{ shader = "dissolve", shadow_height = 0.05 },
		{ shader = "dissolve" },
	})
	-- local extras = nil

	-- if not run_info then
	-- 	local dt1 = DynaText({
	-- 		string = { { string = localize("ph_up_ante_1"), colour = G.C.FILTER } },
	-- 		colours = { G.C.BLACK },
	-- 		scale = 0.55,
	-- 		silent = true,
	-- 		pop_delay = 4.5,
	-- 		shadow = true,
	-- 		bump = true,
	-- 		maxw = 3,
	-- 	})
	-- 	local dt2 = DynaText({
	-- 		string = { { string = localize("ph_up_ante_2"), colour = G.C.WHITE } },
	-- 		colours = { G.C.CHANCE },
	-- 		scale = 0.35,
	-- 		silent = true,
	-- 		pop_delay = 4.5,
	-- 		shadow = true,
	-- 		maxw = 3,
	-- 	})
	-- 	local dt3 = DynaText({
	-- 		string = { { string = localize("ph_up_ante_3"), colour = G.C.WHITE } },
	-- 		colours = { G.C.CHANCE },
	-- 		scale = 0.35,
	-- 		silent = true,
	-- 		pop_delay = 4.5,
	-- 		shadow = true,
	-- 		maxw = 3,
	-- 	})
	-- 	extras = {
	-- 		n = G.UIT.R,
	-- 		config = { align = "cm" },
	-- 		nodes = {
	-- 			{
	-- 				n = G.UIT.R,
	-- 				config = { align = "cm", padding = 0.07, r = 0.1, colour = { 0, 0, 0, 0.12 }, minw = 2.9 },
	-- 				nodes = {
	-- 					{
	-- 						n = G.UIT.R,
	-- 						config = { align = "cm" },
	-- 						nodes = {
	-- 							{ n = G.UIT.O, config = { object = dt1 } },
	-- 						},
	-- 					},
	-- 					{
	-- 						n = G.UIT.R,
	-- 						config = { align = "cm" },
	-- 						nodes = {
	-- 							{ n = G.UIT.O, config = { object = dt2 } },
	-- 						},
	-- 					},
	-- 					{
	-- 						n = G.UIT.R,
	-- 						config = { align = "cm" },
	-- 						nodes = {
	-- 							{ n = G.UIT.O, config = { object = dt3 } },
	-- 						},
	-- 					},
	-- 				},
	-- 			},
	-- 		},
	-- 	}
	-- end

	G.GAME.round_resets.blind_ante = G.GAME.round_resets.blind_ante or G.GAME.round_resets.ante
	local loc_target = localize({
		type = "raw_descriptions",
		key = blind_choice.config.key,
		set = "Blind",
		vars = { "" },
	})
	local loc_name = localize({ type = "name_text", key = blind_choice.config.key, set = "Blind" })
	local text_table = loc_target
	local blind_col = get_blind_main_colour("Big")

	local t = {
		n = G.UIT.R,
		config = {
			align = "tm",
			minh = not run_info and 10 or nil,
			ref_table = { deck = nil, run_info = run_info },
			r = 0.1,
			padding = 0.05,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					align = "cm",
					colour = mix_colours(G.C.BLACK, G.C.L_BLACK, 0.5),
					r = 0.1,
					outline = 1,
					outline_colour = G.C.L_BLACK,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.2 },
						nodes = {
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									colour = disabled and G.C.UI.BACKGROUND_INACTIVE or G.C.ORANGE,
									minh = 0.6,
									minw = 2.7,
									padding = 0.07,
									r = 0.1,
									shadow = true,
									hover = true,
									one_press = true,
									button = "select_hpot_event",
									func = "can_select_hpot_event",
								},
								nodes = {
									{
										n = G.UIT.T,
										config = {
											text = localize("Select", "blind_states"),
											scale = 0.45,
											colour = G.C.UI.TEXT_LIGHT,
											shadow = not disabled,
										},
									},
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { id = "blind_name", align = "cm", padding = 0.07 },
						nodes = {
							{
								n = G.UIT.R,
								config = {
									align = "cm",
									r = 0.1,
									outline = 1,
									outline_colour = blind_col,
									colour = darken(blind_col, 0.3),
									minw = 2.9,
									emboss = 0.1,
									padding = 0.07,
									line_emboss = 1,
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											object = DynaText({
												string = loc_name,
												colours = { disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE },
												shadow = not disabled,
												float = not disabled,
												y_offset = -4,
												scale = 0.45,
												maxw = 2.8,
											}),
										},
									},
								},
							},
						},
					},
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.05 },
						nodes = {
							{
								n = G.UIT.R,
								config = { id = "blind_desc", align = "cm", padding = 0.05 },
								nodes = {
									{
										n = G.UIT.R,
										config = { align = "cm" },
										nodes = {
											{
												n = G.UIT.R,
												config = { align = "cm", minh = 1.5 },
												nodes = {
													{ n = G.UIT.O, config = { object = blind_choice.animation } },
												},
											},
										},
									},
									{
										n = G.UIT.R,
										config = {
											align = "cm",
											r = 0.1,
											padding = 0.05,
											minw = 3.1,
											colour = G.C.BLACK,
											emboss = 0.05,
										},
										nodes = {
											{
												n = G.UIT.R,
												config = { align = "cm", maxw = 3 },
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = "Random event encounter",
															scale = 0.3,
															colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE,
															shadow = not disabled,
														},
													},
												},
											},
											{
												n = G.UIT.R,
												config = { align = "cm" },
												nodes = {
													{
														n = G.UIT.T,
														config = {
															text = localize("ph_blind_reward"),
															scale = 0.35,
															colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.WHITE,
															shadow = not disabled,
														},
													},
													{
														n = G.UIT.T,
														config = {
															text = "???",
															scale = 0.35,
															colour = disabled and G.C.UI.TEXT_INACTIVE or G.C.MONEY,
															shadow = not disabled,
														},
													},
												},
											},
										},
									},
								},
							},
						},
					},
				},
			},
		},
	}
	return t
end

-- TODO: remove card area
function Game:update_hpot_event_select(dt)
	if self.buttons then
		self.buttons:remove()
		self.buttons = nil
	end
	if self.shop then
		self.shop:remove()
		self.shop = nil
	end

	if not G.STATE_COMPLETE then
		stop_use()
		ease_background_colour_blind(G.STATES.BLIND_SELECT)
		G.E_MANAGER:add_event(Event({
			func = function()
				save_run()
				return true
			end,
		}))
		G.STATE_COMPLETE = true
		G.CONTROLLER.interrupt.focus = true
		G.E_MANAGER:add_event(Event({
			func = function()
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						play_sound("cancel")
						G.hpot_event_select = UIBox({
							definition = create_UIBox_hpot_event_select(),
							config = {
								align = "bmi",
								offset = { x = 0, y = G.ROOM.T.y + 29 },
								major = G.hand,
								bond = "Weak",
							},
						})
						G.hpot_event_select.alignment.offset.y = 0.8
							- (G.hand.T.y - G.jokers.T.y)
							+ G.hpot_event_select.T.h
						G.ROOM.jiggle = G.ROOM.jiggle + 3
						G.hpot_event_select.alignment.offset.x = 0
						G.CONTROLLER.lock_input = false
						return true
					end,
				}))
				return true
			end,
		}))
	end
end
function create_UIBox_hpot_event_select()
	local choice = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {
				UIBox_dyn_container(
					{ create_UIBox_hpot_event_choice() },
					false,
					get_blind_main_colour("Big"),
					mix_colours(G.C.BLACK, get_blind_main_colour("Big"), 0.8)
				),
			},
		},
		config = { align = "bmi", offset = { x = 0, y = 0 } },
	})
	local t = {
		n = G.UIT.ROOT,
		config = { align = "tm", minw = width, r = 0.15, colour = G.C.CLEAR },
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm", padding = 0.5 },
				nodes = {
					{ n = G.UIT.O, config = { align = "cm", object = choice } },
				},
			},
		},
	}
	return t
end

-----------------

function start_hpot_event(forced_key)
	-- TODO: get from pool
	local scenario = SMODS.EventScenarios["hpot_test"]
	G.hpot_event_scenario = scenario

	local event_ui = UIBox({
		definition = G.UIDEF.hpot_event(),
		config = {
			align = "br",
			major = G.ROOM_ATTACH,
			bond = "Weak",
			offset = {
				x = -15.3,
				y = G.ROOM.T.y + 21,
			},
		},
	})
	G.hpot_event_ui = event_ui
	G.hpot_event_ui_image_area = G.hpot_event_ui:get_UIE_by_ID("image_area")
	G.hpot_event_ui_text_area = G.hpot_event_ui:get_UIE_by_ID("text_area")
	G.hpot_event_ui_choices_area = G.hpot_event_ui:get_UIE_by_ID("choices_area")

	G.E_MANAGER:add_event(Event({
		func = function()
			G.hpot_event_ui.alignment.offset.y = -8.5
			return true
		end,
	}))
	delay(1)
	G.E_MANAGER:add_event(Event({
		func = function()
			start_hpot_step(scenario.starting_step_key)
			return true
		end,
	}))
end
function start_hpot_step(key)
	local step = SMODS.EventSteps[key]
	G.hpot_event_previous_step = G.hpot_event_current_step or nil
	G.hpot_event_current_step = step

	G.E_MANAGER:add_event(Event({
		func = function()
			if G.hpot_event_previous_step then
				G.hpot_event_previous_step:finish(G.hpot_event_current_step)
			end
			G.E_MANAGER:add_event(Event({
				func = function()
					cleanup_hpot_previous_step()
					G.E_MANAGER:add_event(Event({
						func = function()
							prepare_hpot_current_step_lines()
							G.hpot_event_current_step:start(G.hpot_event_previous_step)
							G.E_MANAGER:add_event(Event({
								func = function()
									render_hpot_current_step()
									return true
								end,
							}))
							return true
						end,
					}))
					return true
				end,
			}))
			return true
		end,
	}))
end
function finish_hpot_event()
	stop_use()
	if G.hpot_event_ui then
		G.GAME.facing_hpot_event = nil

		if G.hpot_event_current_step then
			G.hpot_event_current_step:finish()
		end

		G.E_MANAGER:add_event(Event({
			func = function()
				G.E_MANAGER:add_event(Event({
					trigger = "before",
					delay = 0.2,
					func = function()
						G.hpot_event_ui.alignment.offset.y = G.ROOM.T.y + 21
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						G.hpot_event_ui:remove()
						G.hpot_event_ui = nil
						delay(0.3)
						return true
					end,
				}))
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						G.STATE = G.STATES.BLIND_SELECT
						G.STATE_COMPLETE = false
						return true
					end,
				}))
				return true
			end,
		}))
	end
end

function cleanup_hpot_previous_step()
	local function set_object(container, object)
		container.config.object:remove()
		container.config.object = object
		container.UIBox:recalculate()
	end

	G.E_MANAGER:add_event(Event({
		func = function()
			set_object(G.hpot_event_ui_text_area, Moveable())
			return true
		end,
	}))
	delay(1)
	G.E_MANAGER:add_event(Event({
		func = function()
			set_object(G.hpot_event_ui_choices_area, Moveable())
			return true
		end,
	}))
end
function prepare_hpot_current_step_lines()
	local scenario = G.hpot_event_scenario
	local step = G.hpot_event_current_step

	local text_objects = {}
	-- Step text
	local event_text_content = {}
	localize({
		type = "descriptions",
		set = step.set,
		key = step.key,
		nodes = event_text_content,
		vars = {},
		default_col = G.C.UI.TEXT_LIGHT,
	})
	local event_text_lines = {}
	for _, line in ipairs(event_text_content) do
		local text_object = UIBox({
			definition = {
				n = G.UIT.ROOT,
				config = {
					colour = G.C.CLEAR,
				},
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "c", minh = 0.35 },
						nodes = line,
					},
				},
			},
			config = {},
		})
		text_object.states.visible = false
		table.insert(text_objects, text_object)
		table.insert(event_text_lines, {
			n = G.UIT.R,
			nodes = {
				{
					n = G.UIT.O,
					config = {
						object = text_object,
					},
				},
			},
		})
	end

	local function set_object(container, object)
		container.config.object:remove()
		container.config.object = object
		if object then
			object.config.parent = container
		end
		container.UIBox:recalculate()
	end

	set_object(
		G.hpot_event_ui_text_area,
		UIBox({
			definition = {
				n = G.UIT.ROOT,
				config = { colour = G.C.CLEAR },
				nodes = {
					{
						n = G.UIT.C,
						config = {
							align = "cm",
						},
						nodes = event_text_lines,
					},
				},
			},
			config = {
				parent = G.hpot_event_ui_text_area,
			},
		})
	)

	G.hpot_event_ui_text_objects = text_objects
	G.hpot_event_ui_next_text_object = 1
end
function render_hpot_current_step()
	local scenario = G.hpot_event_scenario
	local step = G.hpot_event_current_step

	-- Step buttons
	local event_buttons_content = {}
	local choices = step:get_choices(scenario)
	for _, choice in ipairs(choices) do
		table.insert(event_buttons_content, G.UIDEF.hpot_event_choice_button(choice))
	end

	local function set_object(container, object)
		container.config.object:remove()
		container.config.object = object
		if object then
			object.config.parent = container
		end
		container.UIBox:recalculate()
	end

	local text_objects = G.hpot_event_ui_text_objects
	for i = G.hpot_event_ui_next_text_object, #G.hpot_event_ui_text_objects do
		local object = text_objects[i]
		if object then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.75,
				func = function()
					object.states.visible = true
					return true
				end,
			}))
		end
	end
	delay(1)
	G.E_MANAGER:add_event(Event({
		func = function()
			set_object(
				G.hpot_event_ui_choices_area,
				UIBox({
					definition = {
						n = G.UIT.ROOT,
						config = { colour = G.C.CLEAR, padding = 0.1 },
						nodes = event_buttons_content,
					},
					config = {
						parent = G.hpot_event_ui_choices_area,
					},
				})
			)
			return true
		end,
	}))
end

function hpot_step_display_next_line(n, no_delay)
	n = n or 1
	local text_objects = G.hpot_event_ui_text_objects
	if text_objects and G.hpot_event_ui_next_text_object then
		for i = G.hpot_event_ui_next_text_object, math.min(G.hpot_event_ui_next_text_object + n - 1, #text_objects) do
			local object = text_objects[i]
			if object then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = no_delay and 0 or 0.75,
					func = function()
						object.states.visible = true
						return true
					end,
				}))
			end
		end
	end
	G.hpot_event_ui_next_text_object = G.hpot_event_ui_next_text_object + n
end

--

function G.FUNCS.select_hpot_event(e)
	stop_use()
	if G.hpot_event_select then
		G.GAME.facing_hpot_event = true

		G.E_MANAGER:add_event(Event({
			trigger = "before",
			delay = 0.2,
			func = function()
				G.hpot_event_select.alignment.offset.y = 40
				G.hpot_event_select.alignment.offset.x = 0
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				G.hpot_event_select:remove()
				G.hpot_event_select = nil
				delay(0.2)
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			trigger = "immediate",
			func = function()
				G.RESET_JIGGLES = nil
				delay(0.4)
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
						delay(0.4)
						G.E_MANAGER:add_event(Event({
							trigger = "immediate",
							func = function()
								G.STATE = G.STATES.HOTPOT_EVENT
								G.STATE_COMPLETE = false
								return true
							end,
						}))
						return true
					end,
				}))
				return true
			end,
		}))
	end
end
function G.FUNCS.can_select_hpot_event(e)
	if G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0) then
		e.config.button = nil
	else
		e.config.button = "select_hpot_event"
	end
end

--

function G.FUNCS.hpot_can_execute_choice(e)
	if not e.config.old_colour then
		e.config.old_colour = e.config.colour
	end
	local choice_func = e.config.choice_func
	if
		(G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0))
		or (choice_func and not choice_func())
	then
		e.config.button = nil
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
	else
		e.config.button = "hpot_execute_choice"
		e.config.colour = e.config.old_colour
	end
end
function G.FUNCS.hpot_execute_choice(e)
	local choice_button = e.config.choice_button
	local choice_func = e.config.choice_func

	if not choice_func or choice_func() then
		choice_button()
	end
end

--

function G.UIDEF.hpot_event_choice_button(choice)
	local localized = SMODS.localize_box(loc_parse_string(choice.text()), {
		default_col = G.C.UI.TEXT_LIGHT,
		vars = {},
	})
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			padding = 0.08,
			r = 0.75,
			hover = true,
			colour = choice.colour or G.C.GREY,
			one_press = true,
			shadow = true,
			func = "hpot_can_execute_choice",
			button = "hpot_execute_choice",
			choice_button = choice.button,
			choice_func = choice.func,
			minh = 0.5,
			maxh = 0.5,
		},
		nodes = {
			{
				n = G.UIT.C,
				config = { minw = 0.05 },
			},
			{
				n = G.UIT.C,
				config = { align = "cm" },
				nodes = localized,
			},
			{
				n = G.UIT.C,
				config = { minw = 0.05 },
			},
		},
	}
end

-- TODO: prettify
function G.UIDEF.hpot_event()
	local scenario = G.hpot_event_scenario

	local container_H = 5.6
	local container_W = 14.9
	local container_padding = 0.1

	local header_H = 0.6
	local header_W = container_W - container_padding * 2
	local header_padding = 0.1

	local content_H = container_H - container_padding * 2 - header_H
	local content_W = container_W - container_padding * 2
	local content_padding = 0.1

	local image_area_size = container_H - container_padding * 2 - header_H - content_padding * 2
	local choices_H = 1.8
	local text_H = image_area_size - content_padding * 2 - choices_H

	local event_text_name = {}
	localize({
		type = "name",
		set = "EventScenarios",
		key = scenario.key,
		nodes = event_text_name,
		vars = {},
		default_col = G.C.UI.TEXT_LIGHT,
	})
	local event_name_lines = {}
	for _, line in ipairs(event_text_name) do
		table.insert(event_name_lines, {
			n = G.UIT.R,
			config = { minh = 0.3 },
			nodes = line,
		})
	end

	return {
		n = G.UIT.ROOT,
		config = {
			colour = G.C.CLEAR,
			minw = container_W,
			maxw = container_W,
			minh = container_H,
			maxh = container_H,
		},
		nodes = {
			UIBox_dyn_container({
				{
					n = G.UIT.R,
					config = {
						minw = header_W,
						maxw = header_W,
						colour = G.C.DYN_UI.BOSS_MAIN,
						r = 0.1,
						emboss = 0.05,
						minh = header_H,
						maxh = header_H,
						padding = header_padding,
						align = "cm",
					},
					nodes = {
						{
							n = G.UIT.C,
							config = { align = "cm" },
							nodes = event_name_lines,
						},
					},
				},
				{
					n = G.UIT.R,
					config = {
						r = 0.1,
						minh = content_H,
						maxh = content_H,
						minw = content_W,
						maxw = content_W,
						align = "c",
					},
					nodes = {
						{
							n = G.UIT.C,
							config = {
								minw = image_area_size,
								maxw = image_area_size,
								minh = image_area_size,
								maxh = image_area_size,
								colour = { 0, 0, 0, 0.1 },
								r = 0.1,
								id = "image_area",
							},
						},
						{
							n = G.UIT.C,
							config = {
								minw = 0.1,
								maxw = 0.1,
							},
						},
						{
							n = G.UIT.C,
							nodes = {
								{
									n = G.UIT.R,
									config = {
										minh = text_H,
										maxh = text_H,
										align = "c",
										padding = 0.1,
									},
									nodes = {
										{
											n = G.UIT.O,
											config = {
												id = "text_area",
												object = Moveable(),
											},
										},
									},
								},
								{
									n = G.UIT.R,
									config = { minh = 0.1 },
								},
								{
									n = G.UIT.R,
									config = {
										align = "c",
										minh = choices_H,
										maxh = choices_H,
									},
									nodes = {
										{
											n = G.UIT.O,
											config = {
												id = "choices_area",
												object = Moveable(),
											},
										},
									},
								},
							},
						},
					},
				},
			}),
		},
	}
end

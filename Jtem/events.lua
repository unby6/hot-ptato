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
					G.FUNCS.finish_hotpot_event()
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
					start_hotpot_step("hpot_test_2")
				end,
				func = function()
					return true
				end,
			},
			{
				text = function()
					return "Gain {C:money}money{} for no reason"
				end,
				button = function()
					ease_dollars(5)
					start_hotpot_step("hpot_test_3")
				end,
				func = function()
					return true
				end,
			},
		}
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
				button = function()
					G.FUNCS.finish_hotpot_event()
				end,
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
				button = function()
					G.FUNCS.finish_hotpot_event()
				end,
				func = function()
					return true
				end,
			},
		}
	end,
})

SMODS.EventScenario({
	key = "test",
	starting_step_key = "hpot_test_1",
})

-----------------

-- TODO: prettify
function create_UIBox_hotpot_event_choice()
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
									button = "select_hotpot_event",
									func = "can_select_hotpot_event",
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
function create_UIBox_hpot_event_select()
	local choice = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {
				UIBox_dyn_container(
					{ create_UIBox_hotpot_event_choice() },
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
						start_hotpot_event()
						return true
					end,
				}))
				return true
			end,
		}))
	end
end

function start_hotpot_event(forced_key)
	-- TODO: get from pool
	local scenario = SMODS.EventScenarios["hpot_test"]
	G.hpot_event_scenario = scenario

	local event_ui = UIBox({
		definition = G.UIDEF.hotpot_event(),
		config = {
			align = "br",
			major = G.ROOM_ATTACH,
			bond = "Weak",
			offset = {
				x = -15.25,
				y = G.ROOM.T.y + 21,
			},
		},
	})
	G.hpot_event_ui = event_ui
	G.E_MANAGER:add_event(Event({
		func = function()
			G.hpot_event_ui.alignment.offset.y = -8.5
			return true
		end,
	}))
	delay(0.2)
	G.E_MANAGER:add_event(Event({
		func = function()
			start_hotpot_step(scenario.starting_step_key)
			return true
		end,
	}))
end
function start_hotpot_step(key)
	local step = SMODS.EventSteps[key]
	G.hpot_event_previous_step = G.hpot_event_current_step or nil
	G.hpot_event_current_step = step

	if G.hpot_event_previous_step then
		G.hpot_event_previous_step:finish(step)
	end
	G.E_MANAGER:add_event(Event({
		func = function()
			render_hotpot_current_step()

			return true
		end,
	}))
end

function cleanup_hotpot_previous_step() end
function render_hotpot_current_step()
	local scenario = G.hpot_event_scenario
	local step = G.hpot_event_current_step

	local event_text_container = G.hpot_event_ui:get_UIE_by_ID("event_text")
	local event_choices_container = G.hpot_event_ui:get_UIE_by_ID("event_choices")
	local function set_object(container, object)
		container.config.object:remove()
		container.config.object = object
		container.UIBox:recalculate()
	end

	delay(1)

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
		table.insert(event_text_lines, {
			n = G.UIT.R,
			config = { align = "c" },
			nodes = line,
		})
	end

	set_object(event_text_container, Moveable())
	G.E_MANAGER:add_event(Event({
		func = function()
			set_object(
				event_text_container,
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
						parent = event_text_container,
					},
				})
			)
			return true
		end,
	}))

	delay(1)

	-- Step buttons
	local event_buttons_content = {}
	local choices = step:get_choices(scenario)
	for _, choice in ipairs(choices) do
		table.insert(event_buttons_content, G.UIDEF.hotpot_event_choice_button(choice))
	end

	set_object(event_choices_container, Moveable())
	G.E_MANAGER:add_event(Event({
		func = function()
			set_object(
				event_choices_container,
				UIBox({
					definition = {
						n = G.UIT.ROOT,
						config = { colour = G.C.CLEAR, padding = 0.1 },
						nodes = event_buttons_content,
					},
					config = {
						parent = event_choices_container,
					},
				})
			)
			return true
		end,
	}))
end

--

function G.FUNCS.select_hotpot_event(e)
	stop_use()
	if G.hpot_event_select then
		G.GAME.facing_hotpot_event = true

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
function G.FUNCS.can_select_hotpot_event(e)
	if G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0) then
		e.config.button = nil
	else
		e.config.button = "select_hotpot_event"
	end
end

function G.FUNCS.finish_hotpot_event(e)
	stop_use()
	if G.hpot_event_ui then
		G.GAME.facing_hotpot_event = nil

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
				delay(0.2)
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
	end
end
function G.FUNCS.can_finish_hotpot_event(e)
	if G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0) then
		e.config.button = nil
	else
		e.config.button = "finish_hotpot_event"
	end
end

--

function G.FUNCS.hotpot_can_execute_choice(e) end
function G.FUNCS.hotpot_execute_choice(e)
	-- local scenario = G.hpot_event_scenario
	-- local step = G.hpot_event_current_step

	local choice_button = e.config.choice_button
	local choice_func = e.config.choice_func

	if choice_func() then
		choice_button()
	end
end

--

function G.UIDEF.hotpot_event_choice_button(choice)
	local localized = SMODS.localize_box(loc_parse_string(choice.text()), {
		default_col = G.C.UI.TEXT_LIGHT,
		vars = {},
	})
	return {
		n = G.UIT.R,
		config = {
			align = "cm",
			padding = 0.1,
			r = 0.1,
			hover = true,
			colour = choice.colour or G.C.MULT,
			-- one_press = true,
			shadow = true,
			func = "hotpot_can_execute_choice",
			button = "hotpot_execute_choice",
			choice_button = choice.button,
			choice_func = choice.func,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = localized,
			},
		},
	}
end

-- TODO: prettify
function G.UIDEF.hotpot_event()
	local scenario = G.hpot_event_scenario

	local container_H = 5.475
	local container_W = 14.9
	local container_padding = 0.1

	local header_H = 0.6
	local header_W = container_W - container_padding * 2
	local header_padding = 0.1

	local content_H = container_H - container_padding * 2 - header_H
	local content_W = container_W - container_padding * 2
	local content_padding = 0.1

	local image_area_size = container_H - container_padding * 2 - header_H - content_padding * 2
	local choices_H = 1.75
	local text_H = image_area_size - content_padding - choices_H

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
			nodes = line,
		})
	end

	return {
		n = G.UIT.ROOT,
		config = {
			colour = G.C.UI.BACKGROUND_DARK,
			r = 0.1,
			padding = container_padding,
			minw = container_W,
			maxw = container_W,
			minh = container_H,
			maxh = container_H,
		},
		nodes = {
			{
				n = G.UIT.R,
				config = {
					minw = header_W,
					maxw = header_W,
					r = 0.1,
					colour = G.C.UI.BACKGROUND_INACTIVE,
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
					colour = G.C.UI.BACKGROUND_INACTIVE,
					padding = content_padding,
					minh = content_H,
					maxh = content_H,
					minw = content_W,
					maxw = content_W,
				},
				nodes = {
					{
						n = G.UIT.C,
						config = {
							minw = image_area_size,
							minh = image_area_size,
							colour = { 0, 0, 0, 0.1 },
							r = 0.1,
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
								},
								nodes = {
									{
										n = G.UIT.O,
										config = {
											id = "event_text",
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
											id = "event_choices",
											object = Moveable(),
										},
									},
									-- G.UIDEF.hotpot_event_choice_button({
									-- 	colour = G.C.CHIPS,
									-- 	event_key = "test",
									-- 	choice_key = "choice1",
									-- }),
									-- G.UIDEF.hotpot_event_choice_button({
									-- 	colour = G.C.CHIPS,
									-- 	event_key = "test",
									-- 	choice_key = "choice2",
									-- }),
								},
							},
						},
					},
				},
			},
		},
	}
end

G.STATES.HOTPOT_EVENT_SELECT = 198275827
G.STATES.HOTPOT_EVENT = 198275828

SMODS.Atlas({
	key = "hpot_event_default",
	px = 34,
	py = 34,
	path = "Events/default.png",
	atlas_table = "ANIMATION_ATLAS",
	frames = 21,
})

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
		if self.loc_txt and self.loc_txt.choices then
			for k, _ in pairs(self.loc_txt.choices) do
				SMODS.process_loc_text(
					G.localization.misc.EventChoices,
					self.key:lower() .. "_" .. k,
					self.loc_txt.choices[k]
				)
			end
		end
	end,

	config = {
		extra = {},
	},

	get_choices = function(self, scenario)
		return {
			{
				key = "leave",
				loc_vars = {},
				text = "Leave",
				button = function()
					hpot_event_end_scenario()
				end,
				func = function()
					return true
				end,
			},
		}
	end,

	load = function(self, scenario, previous_step) end,
	start = function(self, scenario, previous_step, is_load) end,
	finish = function(self, scenario, next_step) end,

	loc_vars = function(self)
		return {}
	end,

	inject = function() end,
})

-- TODO: add card which will represent event in collection
-- Is it needed?
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

	atlas = "hpot_event_default",
	pos = {
		x = 0,
		y = 0,
	},
	colour = "A17CFF",

	weight = 5,
	in_pool = function(self)
		return true
	end,
	get_weight = function(self)
		return self.weight
	end,

	inject = function(self)
		SMODS.insert_pool(G.P_CENTER_POOLS[self.set], self)
		self.colour = type(self.colour) == "string" and HEX(self.colour) or self.colour or G.C.BLIND.Big
	end,
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
})

-----------------

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
						local scenario = SMODS.EventScenarios[G.GAME.round_resets.blind_choices.hpot_event]
						G.hpot_event_select = UIBox({
							definition = create_UIBox_hpot_event_select(scenario),
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

-- TODO: custom blind sprite & desc
function create_UIBox_hpot_event_choice(scenario)
	local disabled = false
	local run_info = false

	local blind_choice = {
		config = G.P_BLINDS[G.GAME.round_resets.blind_choices["Big"]],
	}

	blind_choice.animation = AnimatedSprite(0, 0, 1.4, 1.4, G.ANIMATION_ATLAS[scenario.atlas], scenario.pos)
	blind_choice.animation:define_draw_steps({
		{ shader = "dissolve", shadow_height = 0.05 },
		{ shader = "dissolve" },
	})

	-- TODO: Description
	local loc_target = localize({
		type = "raw_descriptions",
		key = "hpot_event_encounter",
		set = "Other",
		vars = { "" },
	})
	local loc_name = localize({ type = "name_text", key = "hpot_event_encounter", set = "Other" })
	local text_table = loc_target
	local blind_col = scenario.colour

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
									button = "hpot_event_select",
									func = "hpot_event_can_select",
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
											text_table[1] and {
												n = G.UIT.R,
												config = {
													align = "cm",
													minh = 0.7,
													padding = 0.05,
													minw = 2.9,
												},
												nodes = {
													text_table[1] and {
														n = G.UIT.R,
														config = { align = "cm", maxw = 2.8 },
														nodes = {
															{
																n = G.UIT.T,
																config = {
																	text = text_table[1] or "-",
																	scale = 0.32,
																	colour = disabled and G.C.UI.TEXT_INACTIVE
																		or G.C.WHITE,
																	shadow = not disabled,
																},
															},
														},
													} or nil,
													text_table[2] and {
														n = G.UIT.R,
														config = { align = "cm", maxw = 2.8 },
														nodes = {
															{
																n = G.UIT.T,
																config = {
																	text = text_table[2] or "-",
																	scale = 0.32,
																	colour = disabled and G.C.UI.TEXT_INACTIVE
																		or G.C.WHITE,
																	shadow = not disabled,
																},
															},
														},
													} or nil,
												},
											} or nil,
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
														n = G.UIT.O,
														config = {
															object = DynaText({
																string = { "???" },
																colours = { G.C.MONEY },
																float = true,
																spacing = 3,
																scale = 0.7,
															}),
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
function create_UIBox_hpot_event_select(scenario)
	local choice = UIBox({
		definition = {
			n = G.UIT.ROOT,
			config = { align = "cm", colour = G.C.CLEAR },
			nodes = {
				UIBox_dyn_container(
					{ create_UIBox_hpot_event_choice(scenario) },
					false,
					scenario.colour,
					mix_colours(G.C.BLACK, scenario.colour, 0.8)
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
						hpot_event_start_scenario()
						return true
					end,
				}))
				return true
			end,
		}))
	end
end

function hpot_event_start_scenario()
	local scenario_key = G.GAME.round_resets.blind_choices.hpot_event or get_next_hpot_event()
	G.GAME.round_resets.hpot_event_encountered = true
	local scenario = SMODS.EventScenarios[scenario_key]
	G.GAME.hpot_event_scenario_data = {}
	G.GAME.hpot_event_scenario_key = scenario.key
	if not G.GAME.hpot_events_encountered then
		G.GAME.hpot_events_encountered = {}
	end
	G.GAME.hpot_events_encountered[scenario.key] = (G.GAME.hpot_events_encountered[scenario.key] or 0) + 1
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

	SMODS.calculate_context({ hpot_event_scenario_start = true, scenario = G.hpot_event_scenario })

	G.E_MANAGER:add_event(Event({
		func = function()
			G.hpot_event_ui.alignment.offset.y = -8.5
			return true
		end,
	}))
	G.E_MANAGER:add_event(Event({
		trigger = "after",
		delay = 0.75,
		func = function()
			play_sound("cardFan2")
			return true
		end,
	}))
	delay(0.25)
	G.E_MANAGER:add_event(Event({
		func = function()
			hpot_event_start_step(scenario.starting_step_key)
			return true
		end,
	}))
end
function hpot_event_load_scenario()
	local scenario_key = G.GAME.hpot_event_scenario_key
	local step_key = G.GAME.hpot_event_step_key
	local previous_step_key = G.GAME.hpot_event_previous_step_key

	local scenario = SMODS.EventScenarios[scenario_key]
	local step = SMODS.EventSteps[step_key]
	local previous_step = SMODS.EventSteps[previous_step_key]

	G.hpot_event_scenario = scenario
	G.hpot_event_current_step = step
	G.hpot_event_previous_step = previous_step

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
	G.E_MANAGER:add_event(Event({
		func = function()
			hpot_event_load_step()
			return true
		end,
	}))
end
function hpot_event_start_step(key)
	local step = SMODS.EventSteps[key]
	G.hpot_event_previous_step = G.hpot_event_current_step or nil
	G.hpot_event_current_step = step
	G.GAME.hpot_event_previous_step_key = G.hpot_event_previous_step and G.hpot_event_previous_step.key or nil
	G.GAME.hpot_event_step_key = step.key

	G.E_MANAGER:add_event(Event({
		func = function()
			if G.hpot_event_previous_step then
				G.hpot_event_previous_step:finish(G.hpot_event_scenario, G.hpot_event_current_step)
				SMODS.calculate_context({
					hpot_event_step_end = true,
					scenario = G.hpot_event_scenario,
					step = G.hpot_event_previous_step,
				})
			end
			G.E_MANAGER:add_event(Event({
				func = function()
					hpot_event_cleanup()
					G.E_MANAGER:add_event(Event({
						func = function()
							hpot_event_prepare_text_lines()
							G.hpot_event_current_step:start(G.hpot_event_scenario, G.hpot_event_previous_step)
							SMODS.calculate_context({
								hpot_event_step_start = true,
								scenario = G.hpot_event_scenario,
								step = G.hpot_event_current_step,
							})
							G.E_MANAGER:add_event(Event({
								func = function()
									hpot_event_render_current_step()
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
function hpot_event_load_step()
	G.E_MANAGER:add_event(Event({
		func = function()
			G.hpot_event_current_step:load(G.hpot_event_scenario, G.hpot_event_previous_step)
			G.E_MANAGER:add_event(Event({
				func = function()
					hpot_event_cleanup()
					G.E_MANAGER:add_event(Event({
						func = function()
							hpot_event_prepare_text_lines()
							G.hpot_event_current_step:start(G.hpot_event_scenario, G.hpot_event_previous_step, true)
							G.E_MANAGER:add_event(Event({
								func = function()
									hpot_event_render_current_step()
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
function hpot_event_end_scenario()
	stop_use()
	if G.hpot_event_ui then
		G.GAME.facing_hpot_event = nil

		if G.hpot_event_current_step then
			G.hpot_event_current_step:finish()
			G.FUNCS.draw_from_hand_to_deck()
			SMODS.calculate_context({
				hpot_event_step_end = true,
				scenario = G.hpot_event_scenario,
				step = G.hpot_event_current_step,
			})
		end

		G.E_MANAGER:add_event(Event({
			func = function()
				SMODS.calculate_context({ hpot_event_scenario_end = true, scenario = G.hpot_event_scenario })
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
						G.GAME.hpot_event_scenario_data = nil
						G.GAME.hpot_event_scenario_key = nil
						G.GAME.hpot_event_step_key = nil
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

function hpot_event_cleanup()
	G.E_MANAGER:add_event(Event({
		func = function()
			set_element_object(G.hpot_event_ui_text_area, Moveable())
			return true
		end,
	}))
	delay(0.5)
	G.E_MANAGER:add_event(Event({
		func = function()
			set_element_object(G.hpot_event_ui_choices_area, Moveable())
			return true
		end,
	}))
end
function hpot_event_prepare_text_lines()
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
		vars = step:loc_vars() or {},
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

	set_element_object(
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
function hpot_event_render_current_step()
	local scenario = G.hpot_event_scenario
	local step = G.hpot_event_current_step

	-- Step buttons
	local event_buttons_content = {}
	local choices = step:get_choices(scenario)
	for _, choice in ipairs(choices) do
		table.insert(event_buttons_content, G.UIDEF.hpot_event_choice_button(step, choice))
	end

	local text_objects = G.hpot_event_ui_text_objects
	for i = G.hpot_event_ui_next_text_object, #G.hpot_event_ui_text_objects do
		local object = text_objects[i]
		if object then
			G.E_MANAGER:add_event(Event({
				trigger = "after",
				delay = 0.75,
				func = function()
					play_sound("paper1", math.random() * 0.2 + 0.9, 0.75)
					object.states.visible = true
					return true
				end,
			}))
		end
	end
	delay(1)
	G.E_MANAGER:add_event(Event({
		func = function()
			play_sound("paper1", math.random() * 0.2 + 0.9, 0.75)
			set_element_object(
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

function hpot_event_display_lines(amount, no_delay)
	amount = amount or 1
	local text_objects = G.hpot_event_ui_text_objects
	if text_objects and G.hpot_event_ui_next_text_object then
		for i = G.hpot_event_ui_next_text_object, math.min(G.hpot_event_ui_next_text_object + amount - 1, #text_objects) do
			local object = text_objects[i]
			if object then
				G.E_MANAGER:add_event(Event({
					trigger = "after",
					delay = no_delay and 0 or 0.75,
					func = function()
						play_sound("paper1", math.random() * 0.2 + 0.9, 0.75)
						object.states.visible = true
						return true
					end,
				}))
			end
		end
	end
	G.hpot_event_ui_next_text_object = G.hpot_event_ui_next_text_object + amount
end

--

function G.FUNCS.hpot_event_select(e)
	stop_use()
	if G.hpot_event_select then
		G.GAME.facing_hpot_event = true
		play_sound("timpani", 0.8)
		play_sound("generic1")

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
				G.E_MANAGER:add_event(Event({
					trigger = "immediate",
					func = function()
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
function G.FUNCS.hpot_event_can_select(e)
	if G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0) then
		e.config.button = nil
	else
		e.config.button = "hpot_event_select"
	end
end

--

function G.FUNCS.hpot_event_can_execute_choice(e)
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
		e.config.button = "hpot_event_execute_choice"
		e.config.colour = e.config.old_colour
	end
end
function G.FUNCS.hpot_event_execute_choice(e)
	local choice_button = e.config.choice_button
	local choice_func = e.config.choice_func

	if not choice_func or choice_func() then
		choice_button()
	end
end

--

function G.UIDEF.hpot_event_choice_button(step, choice)
	local loc_key = choice.no_prefix and choice.key or (step.key:lower() .. "_" .. choice.key)
	local loc_txt = G.localization.misc.EventChoices[loc_key] or choice.text or "ERROR"
	local localized = SMODS.localize_box(loc_parse_string(loc_txt), {
		default_col = G.C.UI.TEXT_LIGHT,
		vars = choice.loc_vars or {},
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
			func = "hpot_event_can_execute_choice",
			button = "hpot_event_execute_choice",
			choice_button = choice.button,
			choice_func = choice.func,
			choice_key = loc_key,
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

--

function get_next_hpot_event()
	if G.hpot_event_scenario_forced_key then
		local result = G.hpot_event_scenario_forced_key
		G.hpot_event_scenario_forced_key = nil
		return result
	end
	local eligible_events = {}
	local total_weight = 0
	for key, event in pairs(SMODS.EventScenarios) do
		local weight = event:get_weight()
		if weight > 0 and event:in_pool() then
			eligible_events[key] = event
		end
	end

	local min_use = 100
	for k, v in pairs(eligible_events) do
		eligible_events[k] = G.GAME.hpot_events_encountered[k] or 0
		min_use = math.min(min_use, eligible_events[k])
	end

	local weighted_events = {}
	for k, _ in pairs(eligible_events) do
		if eligible_events[k] <= min_use then
			local weight = SMODS.EventScenarios[k]:get_weight()
			total_weight = total_weight + weight
			table.insert(weighted_events, {
				key = k,
				weight = weight,
			})
		end
	end

	local roll = pseudorandom(pseudoseed("hpot_event" .. G.GAME.round_resets.ante))
	print(roll)
	print(weighted_events)
	local weight_i = 0
	for _, v in ipairs(weighted_events) do
		weight_i = weight_i + v.weight
		if roll > 1 - (weight_i / total_weight) then
			return v.key
		end
	end

	return "hpot_nothing"
end

--

local ca_dref = CardArea.draw
function CardArea:draw(...)
	if self == G.hand and (G.STATE == G.STATES.HOTPOT_EVENT_SELECT) then
		return
	end
	return ca_dref(self, ...)
end

local r_bref = reset_blinds
function reset_blinds(...)
	r_bref(...)
	G.GAME.round_resets.blind_choices.hpot_event = get_next_hpot_event()
	G.GAME.round_resets.hpot_event_encountered = false
end

function force_hpot_event(key)
	if G.GAME.round_resets.hpot_event_encountered then
		G.hpot_event_scenario_forced_key = key
	else
		G.GAME.round_resets.blind_choices.hpot_event = key
	end
end

-- Contexts

-- Scenario start
-- {
--     hpot_event_scenario_start = true,
--     scenario = scenario
-- }

-- Scenario end
-- {
--     hpot_event_scenario_end = true,
--     scenario = scenario
-- }

-- Step start
-- {
--     hpot_event_step_start = true,
--     scenario = scenario,
--     step = step
-- }

-- Step end
-- {
--     hpot_event_step_end = true,
--     scenario = scenario,
--     step = step
-- }

-- Variables
-- G.GAME.round_resets.hpot_event_encountered - is event was encountered this ante
-- G.GAME.round_resets.blind_choices.hpot_event - event key in this ante

-- G.hpot_event_scenario - current scenario
-- G.hpot_event_current_step - current step
-- G.hpot_event_previous_step - previous step

-- G.hpot_event_ui - full event ui
-- G.hpot_event_ui_image_area - black box in left side of event ui, primarily for images or showing some cutscenes etc

-- Functions
-- hpot_event_start_step(key) - move scenario to next step
-- hpot_event_display_lines(amount, no_delay) - by default all lines displayed with small delay, this function allows to show each line separately by using event queue

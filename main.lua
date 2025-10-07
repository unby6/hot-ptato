--(idk if this has to go here, but i assume its better if this is done before any files are loaded so nothing crashes because of it not being called yet)
--for adding custom loc_colours, dont touch this!
loc_colour()

-- CONFIG
--#region Config

HotPotato = SMODS.current_mod

--#endregion

--modicon
SMODS.Atlas {
	key = "modicon",
	path = "modicon.png",
	px = 32,
	py = 32
}

--talisman
to_big = to_big or function(x) return x end
to_number = to_number or function(x) return x end
--oh my fucking god at this point just install luajit2

-- FILE LOADING
--#region File Loading
local nativefs = NFS

local path_len = string.len(SMODS.current_mod.path) + 1

local function load_file_native(path)
	if not path or path == "" then
		error("No path was provided to load.")
	end
	local file_path = path
	local file_content, err = NFS.read(file_path)
	if not file_content then return nil,
			"Error reading file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err end
	local short_path = string.sub(path, path_len, path:len())
	local chunk, err = load(file_content, "=[SMODS " .. SMODS.current_mod.id .. ' "' .. short_path .. '"]')
	if not chunk then return nil,
			"Error processing file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err end
	return chunk
end
local blacklist = {
	assets = true,
	lovely = true,
	[".github"] = true,
	[".git"] = true,
	["localization"] = true
}
local function load_files(path, dirs_only)
	local info = nativefs.getDirectoryItemsInfo(path)
	table.sort(info, function(a, b)
		return a.name < b.name
	end)
	for _, v in ipairs(info) do
		if v.type == "directory" and not blacklist[v.name] then
			load_files(path .. "/" .. v.name)
		elseif not dirs_only then
			if string.find(v.name, ".lua") then -- no X.lua.txt files or whatever unless they are also lua files
				local f, err = load_file_native(path .. "/" .. v.name)
				if f then
					f()
				else
					error("error in file " .. v.name .. ": " .. err)
				end
			end
		end
	end
end
local path = SMODS.current_mod.path

-- Annoyingly load title text lua
local f, err = load_file_native(path .. "/Jtem/titletext.lua")
if f then f() end
load_files(path, true)
--#endregion

-- CREDITS SYSTEM
--#region Card Credits System
local smcmb = SMODS.create_mod_badges
function SMODS.create_mod_badges(obj, badges)
	smcmb(obj, badges)
	if not SMODS.config.no_mod_badges and obj and obj.hotpot_credits then
		local function calc_scale_fac(text)
			local size = 0.9
			local font = G.LANG.font
			local max_text_width = 2 - 2 * 0.05 - 4 * 0.03 * size - 2 * 0.03
			local calced_text_width = 0
			-- Math reproduced from DynaText:update_text
			for _, c in utf8.chars(text) do
				local tx = font.FONT:getWidth(c) * (0.33 * size) * G.TILESCALE * font.FONTSCALE
					+ 2.7 * 1 * G.TILESCALE * font.FONTSCALE
				calced_text_width = calced_text_width + tx / (G.TILESIZE * G.TILESCALE)
			end
			local scale_fac = calced_text_width > max_text_width and max_text_width / calced_text_width or 1
			return scale_fac
		end
		if obj.hotpot_credits.art or obj.hotpot_credits.code or obj.hotpot_credits.idea or obj.hotpot_credits.team or obj.hotpot_credits.custom then
			local scale_fac = {}
			local min_scale_fac = 1
			local strings = { HotPotato.display_name }
			for _, v in ipairs({ "idea", "art", "code", "team" }) do
				if obj.hotpot_credits[v] then
					if type(obj.hotpot_credits[v]) == "string" then obj.hotpot_credits[v] = { obj.hotpot_credits[v] } end
					for i = 1, #obj.hotpot_credits[v] do
						strings[#strings + 1] =
							localize({ type = "variable", key = "hotpot_" .. v, vars = { obj.hotpot_credits[v][i] } })
							[1]
					end
				end
			end
			if obj.hotpot_credits.custom then
				strings[#strings + 1] = localize({ type = "variable", key = obj.hotpot_credits.custom.key, vars = { obj.hotpot_credits.custom.text } })
			end
			for i = 1, #strings do
				scale_fac[i] = calc_scale_fac(strings[i])
				min_scale_fac = math.min(min_scale_fac, scale_fac[i])
			end
			local ct = {}
			for i = 1, #strings do
				ct[i] = {
					string = strings[i],
				}
			end
			local hotpot_badge = {
				n = G.UIT.R,
				config = { align = "cm" },
				nodes = {
					{
						n = G.UIT.R,
						config = {
							align = "cm",
							colour = HotPotato.badge_colour,
							r = 0.1,
							minw = 2 / min_scale_fac,
							minh = 0.36,
							emboss = 0.05,
							padding = 0.03 * 0.9,
						},
						nodes = {
							{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
							{
								n = G.UIT.O,
								config = {
									object = DynaText({
										string = ct or "ERROR",
										colours = { obj.hotpot_credits and obj.hotpot_credits.text_colour or G.C.WHITE },
										silent = true,
										float = true,
										shadow = true,
										offset_y = -0.03,
										spacing = 1,
										scale = 0.33 * 0.9,
									}),
								},
							},
							{ n = G.UIT.B, config = { h = 0.1, w = 0.03 } },
						},
					},
				},
			}
			for i = 1, #badges do
				if badges[i].nodes[1].nodes[2].config.object.string == HotPotato.display_name then --this was meant to be a hex code but it just doesnt work for like no reason so its hardcoded
					badges[i].nodes[1].nodes[2].config.object:remove()
					badges[i] = hotpot_badge
					break
				end
			end
		end
	end
end

--#endregion

-- MISC
--#region Miscelaneous

-- Add optional features here
HotPotato.optional_features = {
	retrigger_joker = true,
	post_trigger = true,
}
HotPotato.extra_tabs = function()
	return {
		--nxclicker
		{
			label = "Kill Nxkoo",
			tab_definition_function = G.UIDEF.nxclicker
		},
		-- Jukebox
		{
			label = "Jukebox",
			tab_definition_function = JTJukebox.MusicTab
		},
	}
end
--#endregion

if not HotPotatoConfig then HotPotatoConfig = {} end
HotPotatoConfig = SMODS.current_mod.config

local hpotConfigTab = function()
	hpot_nodes = {}
	config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} } } }
	hpot_nodes[#hpot_nodes + 1] = config
	hpot_nodes[#hpot_nodes + 1] = create_toggle({
		label = localize("hotpot_disable_animations"),
		active_colour = HEX("40c76d"),
		ref_table = HotPotatoConfig,
		ref_value = "animations_disabled",
		callback = function()
		end,
	})
	hpot_nodes[#hpot_nodes + 1] = create_toggle({
		label = localize("hotpot_family_friendly"),
		active_colour = HEX("40c76d"),
		ref_table = HotPotatoConfig,
		ref_value = "family_friendly",
		callback = function()
			HotPotato.reload_localization()
		end
	})
	hpot_nodes[#hpot_nodes + 1] = create_toggle({
		label = localize("hotpot_window_title"),
		active_colour = HEX("40c76d"),
		ref_table = HotPotatoConfig,
		ref_value = "window_title",
		callback = function()
			if HotPotatoConfig.window_title then
				HotPotato.set_window_title()
			else
				love.window.setTitle("Balatro")
			end
		end,
	})
	return {
		n = G.UIT.ROOT,
		config = {
			emboss = 0.05,
			minh = 6,
			r = 0.1,
			minw = 10,
			align = "cm",
			padding = 0.2,
			colour = G.C.BLACK,
		},
		nodes = hpot_nodes,
	}
end

HotPotato.badge_colour = SMODS.Gradients["hpot_advert"]

HotPotato.config_tab = hpotConfigTab

SMODS.current_mod.calculate = function(self, context)
	return SMODS.merge_effects(
		Horsechicot:calculate(context) or {}
	)
end

HotPotato.set_window_title = function()
	if HotPotatoConfig.window_title then
		local title = "Balatro: " ..
		((type(HPJTTT.text[HPJTTT.chosen]) == 'string' and HPJTTT.text[HPJTTT.chosen]) or 'Now with images!')
		if HPJTTT.balala then
			title = "Balala"
		end
		love.window.setTitle(title)
	end
end
HotPotato.set_window_title()

--#region Credits

-- credits button on mod page
HotPotato.custom_ui = function(mod_nodes)
	mod_nodes[#mod_nodes + 1] = {
		n = G.UIT.R,
		config = { minw = 4, minh = 4, align = "cm", padding = 0.2 },
		nodes = {
			UIBox_button({ label = { localize('hotpot_credits_button') }, minw = 5, colour = HotPotato.badge_colour, button =
			"create_UIBox_credits" }),
			UIBox_button({ label = { localize('hotpot_feature_info_button') }, minw = 5, colour = HotPotato.badge_colour, button =
			"feature_info_menu" })
		}
	}
end

-- credits ui

--- Creates credit ui for a specific team number
---@param team integer
HotPotato.generate_credit_UIBox = function(team)
	-- members definition
	local m = G.localization.InfoMenu.hotpot_credits[team or 1].members
	local areas = {}
	if G.HOT_POTATO_CREDIT_AREAS then
		for _, area in ipairs(G.HOT_POTATO_CREDIT_AREAS) do
			area:remove()
		end
	end
	G.HOT_POTATO_CREDIT_AREAS = {}
	G.HOT_POTATO_CREDIT_NODES = {}
	for i, member in ipairs(m) do
		G.HOT_POTATO_CREDIT_AREAS[i] = CardArea(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W / 1.25, G.CARD_H / 1.25,
			{ type = "title_2", card_limit = 1, highlight_limit = 0 })
		-- create a card for this potato
		local atlas = member.atlas or "Joker"
		local pos = member.pos or { x = 0, y = 0 }
		local card = Card(G.ROOM.T.x, G.ROOM.T.y, G.CARD_W / 1.25, G.CARD_H / 1.25, nil, G.P_CENTERS.c_base)
		card.config.center = copy_table(card.config.center)
		card.config.center.atlas = atlas
		card.config.center.pos = pos
		if member.soul_pos then
			card.config.center.soul_pos = member.soul_pos
		end
		card:set_sprites(card.config.center)
		G.HOT_POTATO_CREDIT_AREAS[i]:emplace(card)

		local function create_text_box(args)
			local desc_node = {}
			local loc_target = args.loc_target and copy_table(args.loc_target)
			HotPotato.localize { type = 'descriptions', loc_target = { text = loc_target }, nodes = desc_node, scale = 1, text_colour = G.C.UI.TEXT_LIGHT, vars = args.vars or {}, stylize = true, no_shadow = true }
			desc_node = hp_desc_from_rows(desc_node, true, "cm")
			desc_node.config.align = "cm"

			return {
				n = G.UIT.R,
				config = { align = "cm", colour = G.C.L_BLACK, r = 0.2, shadow = true },
				nodes = {
					{
						n = G.UIT.C,
						config = { align = "cm", padding = 0.05 },
						nodes = {
							desc_node
						}
					},
				}
			}
		end

		-- description
		card.hover = function(self)
			local info_nodes = {
				n = G.UIT.R,
				config = { align = "cm", padding = 0, colour = G.C.CLEAR },
				nodes = {
					{ n = G.UIT.C, config = { align = "cm", padding = 0.2 }, nodes = {} },
				}
			}
			local target = member.text
			if target then
				for _, v in ipairs(target) do
					info_nodes.nodes[1].nodes[#info_nodes.nodes[1].nodes + 1] = create_text_box({ loc_target = v })
				end
			end
			self:juice_up(0.05, 0.03)
			play_sound('paper1', math.random() * 0.2 + 0.9, 0.35)
			card.config.h_popup = info_nodes
			card.config.h_popup_config = self:align_h_popup()
			Moveable.hover(self)
		end

		-- for nxkoo specifically
		if member.name == "Nxkoo" then
			card.click = function(self)
				if not card.cantclicklmao then
					G.E_MANAGER:add_event(Event{
						trigger = 'ease',
						delay = 0.4,
						ease = 'elastic',
						ref_table = card.T,
						ref_value = "h",
						ease_to = 0,
						func = function(n)
							return n
						end
					})
					card.cantclicklmao = true
					G.FUNCS.nxkclick()
				end
				Moveable.click(self)
			end
		end

		-- name node for the fancy people
		local temp_subname_node = {}
		HotPotato.localize{type = 'name', loc_target = {name = member.name}, nodes = temp_subname_node, scale = 0.8, text_colour = G.C.L_BLACK, stylize = true, no_shadow = true, no_pop_in = true, no_bump = true, no_silent = true, no_spacing = true} 
		temp_subname_node = hp_desc_from_rows(temp_subname_node,true,"cm",nil,0)
		temp_subname_node.config.align = "cm"

		-- create node for this mf
		G.HOT_POTATO_CREDIT_NODES[i] = {
			n = G.UIT.C,
			config = { align = "cm", id = "hpot_credit_node_" .. member.name },
			nodes = {
				{
					n = G.UIT.C,
					config = {
						r = 0.2,
						align = "cm",
						padding = 0.125,
						colour = G.C.L_BLACK,
						minw = G.CARD_W / 1.2 + 0.2,
						minh = G.CARD_H * 1.2
					},
					nodes = {
						{
							n = G.UIT.C,
							config = {
								r = 0.2,
								align = "tm",
								padding = 0.1,
								colour = G.C.BLACK,
								minw = G.CARD_W / 1.2,
								minh = G.CARD_H * 1.2
							},
							nodes = {
								{
									n = G.UIT.R,
									config = { align = "cm" },
									nodes = {
										temp_subname_node
									}
								},
								{
									n = G.UIT.R,
									config = {
										align = "cm",
									},
									nodes = {
										{
											n = G.UIT.O,
											config = {
												object = G.HOT_POTATO_CREDIT_AREAS[i],
											},
										}
									}
								},
							}
						},

					}
				},
			}
		}
	end

	local max_columns = 1
	-- can i stop naming this math.ciel initially...
	-- i am not type-moon coded i promise
	local max_pool_len = math.min(math.ceil(#m / max_columns), 3)
	local current_member = 1
	local table_nodes = {}

	for i = 1, max_pool_len do
		table_nodes[#table_nodes + 1] = {
			n = G.UIT.R,
			config = { align = "cm", padding = 0.1 },
			nodes = {}
		}
	end

	local count = 0
	for _, node in ipairs(G.HOT_POTATO_CREDIT_NODES) do
		if count > max_pool_len then
			count = 0
			current_member = current_member + 1
		end
		count = count + 1
		table_nodes[current_member].nodes[#table_nodes[current_member].nodes + 1] = node
	end

	-- create a card for this member
	return {
		n = G.UIT.C,
		config = { minw = 11, colour = G.C.CLEAR, align = "cm", id = "hotpot_credits_page" },
		nodes = table_nodes
	}
end

function G.FUNCS.regenerate_hotpot_credits_page(e)
	if not e then return end
	if not e.cycle_config then return end
	local page = G.OVERLAY_MENU:get_UIE_by_ID("hotpot_credits_page")
	if page then
		page:remove()
		local uibox = HotPotato.generate_credit_UIBox(e.cycle_config.current_option)
		page.UIBox:add_child(uibox, page)
		page.UIBox:recalculate()
	end
end

function G.FUNCS.create_UIBox_credits(e)
	local uibox = HotPotato.generate_credit_UIBox(1)
	local options = {}
	for week, team in ipairs(G.localization.InfoMenu.hotpot_credits) do
		options[#options+1] = localize('hotpot_credits_week').." "..week.." - "..team.name
	end
	SMODS.LAST_SELECTED_MOD_TAB = nil
	local t = create_UIBox_generic_options({
		colour = G.ACTIVE_MOD_UI and
			((G.ACTIVE_MOD_UI.ui_config or {}).collection_colour or (G.ACTIVE_MOD_UI.ui_config or {}).colour),
		bg_colour = G.ACTIVE_MOD_UI and
			((G.ACTIVE_MOD_UI.ui_config or {}).collection_bg_colour or (G.ACTIVE_MOD_UI.ui_config or {}).bg_colour),
		back_colour = G.ACTIVE_MOD_UI and
			((G.ACTIVE_MOD_UI.ui_config or {}).collection_back_colour or (G.ACTIVE_MOD_UI.ui_config or {}).back_colour),
		outline_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_outline_colour or
			(G.ACTIVE_MOD_UI.ui_config or {}).outline_colour),
		back_func = G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or 'your_collection',
		contents = {
			{
				n = G.UIT.C,
				config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05 },
				nodes = {
					{
						n = G.UIT.R,
						config = { align = "cm", padding = 0.2 },
						nodes = {
							{
								n = G.UIT.O,
								config = {
									object = DynaText {
										string = localize('hotpot_credits_title'),
										float = true,
										pop_in = 0,
										pop_in_rate = 4,
										silent = true,
										shadow = true,
										scale = 1,
										rotate = true,
										colours = { G.C.EDITION }
									}
								}
							}
						}
					},
					{
						n = G.UIT.R,
						config = { align = "cm", minh = 8 },
						nodes = {
							uibox
						}
					},
					{
						n = G.UIT.R,
						config = {
							align = "cm"
						},
						nodes = {
							create_option_cycle({options = options, w = 11, scale = 0.8, cycle_shoulders = true, opt_callback = 'regenerate_hotpot_credits_page', current_option = 1, colour = G.ACTIVE_MOD_UI and (G.ACTIVE_MOD_UI.ui_config or {}).collection_option_cycle_colour or G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
						}
					}
				}
			},
		}
	})
	G.FUNCS.overlay_menu {
		definition = t
	}
end

--#endregion

--#region Feature Info

function G.FUNCS.feature_info_menu(e)
	local contents = {}
	for info, menu in pairs(G.localization.InfoMenu) do
		if info ~= "hotpot_credits" then
			local fname = "hotpot_info_menu_"..info
			G.FUNCS[fname] = function(e)
				G.FUNCS.hotpot_info { menu_type = info, back_func = "feature_info_menu", no_first_time = true }
			end
			contents[#contents+1] = UIBox_button({ label = { HotPotato.localize { type = 'name_text', loc_target = { name = menu.name } } }, minw = 5, button = fname })
		end
	end
	SMODS.LAST_SELECTED_MOD_TAB = nil
	G.FUNCS.overlay_menu {
		definition = create_UIBox_generic_options({
			colour = G.ACTIVE_MOD_UI and
				((G.ACTIVE_MOD_UI.ui_config or {}).collection_colour or (G.ACTIVE_MOD_UI.ui_config or {}).colour),
			bg_colour = G.ACTIVE_MOD_UI and
				((G.ACTIVE_MOD_UI.ui_config or {}).collection_bg_colour or (G.ACTIVE_MOD_UI.ui_config or {}).bg_colour),
			back_colour = G.ACTIVE_MOD_UI and
				((G.ACTIVE_MOD_UI.ui_config or {}).collection_back_colour or (G.ACTIVE_MOD_UI.ui_config or {}).back_colour),
			outline_colour = G.ACTIVE_MOD_UI and ((G.ACTIVE_MOD_UI.ui_config or {}).collection_outline_colour or
				(G.ACTIVE_MOD_UI.ui_config or {}).outline_colour),
			back_func = G.ACTIVE_MOD_UI and "openModUI_" .. G.ACTIVE_MOD_UI.id or 'your_collection',
			contents = {
				{
					n = G.UIT.C,
					config = { align = "cm", r = 0.1, colour = G.C.BLACK, emboss = 0.05, padding = 0.1, minw = 7 },
					nodes = {
						{
							n = G.UIT.R,
							config = { minw = 4, minh = 4, align = "cm", padding = 0.15 },
							nodes = contents
						}
					}
				}
			}
		})
	}
end
--#endregion

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
    if not file_content then return  nil, "Error reading file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err end
	local short_path = string.sub(path, path_len, path:len())
    local chunk, err = load(file_content, "=[SMODS " .. SMODS.current_mod.id .. ' "' .. short_path .. '"]')
    if not chunk then return nil, "Error processing file '" .. path .. "' for mod with ID '" .. SMODS.current_mod.id .. "': " .. err end
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
	table.sort(info, function (a, b)
		return a.name < b.name
	end)
	for _, v in ipairs(info) do
		if v.type == "directory" and not blacklist[v.name] then	
			load_files(path.."/"..v.name)
		elseif not dirs_only then
			if string.find(v.name, ".lua") then -- no X.lua.txt files or whatever unless they are also lua files
				local f, err = load_file_native(path.."/"..v.name)
				if f then f() 
				else error("error in file "..v.name..": "..err) end
			end
		end
	end
end
local path = SMODS.current_mod.path

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
					if type(obj.hotpot_credits[v]) == "string" then obj.hotpot_credits[v] = {obj.hotpot_credits[v]} end
					for i = 1, #obj.hotpot_credits[v] do
						strings[#strings + 1] =
							localize({ type = "variable", key = "hotpot_" .. v, vars = { obj.hotpot_credits[v][i] } })[1]
					end
				end
			end
            if obj.hotpot_credits.custom then
                strings[#strings + 1] = localize({ type="variable", key = obj.hotpot_credits.custom.key, vars = { obj.hotpot_credits.custom.text } })
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
HotPotato.extra_tabs = function ()
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
        callback = function ()
			HotPotato.reload_localization()
		end
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

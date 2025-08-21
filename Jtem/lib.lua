-- Might as well lmao
function init_jtem(game)
	game.spark_points = game.spark_points or 0
	game.spark_points_display = game.spark_points_display or "0"
	game.hpot_events_encountered = game.hpot_events_encountered or {}
end

-- For the splash text
function ease_splash_text(delta, reset)
	if not G.SPLASH_TEXT then
		return
	end
	G.SPLASH_TEXT.scale_mod = G.SPLASH_TEXT.scale_mod or 0
	-- ease to desired scale
	G.E_MANAGER:add_event(
		Event({
			trigger = "ease",
			ease = "quad",
			ref_table = G.SPLASH_TEXT,
			ref_value = "scale_mod",
			ease_to = reset and 1 or (1 + delta),
			delay = 0.5,
			pause_force = true,
			func = function(t)
				return t
			end,
		}),
		"splash_text"
	)
	-- call it again as an event, this time backwards or vice versa. yes this is recursive
	G.E_MANAGER:add_event(
		Event({
			pause_force = true,
			func = function()
				ease_splash_text(delta, not reset)
				return true
			end,
		}),
		"splash_text"
	)
end

function simple_add_event(func, config)
	config = config or { delay = 0, trigger = "after" }
	G.E_MANAGER:add_event(Event({
		func = func,
		unpack(config),
	}))
end

function find_index_from_list(_table, object)
	if not _table then
		return nil
	end
	for _i, _e in pairs(_table) do
		if _e == object then
			return _i
		end
	end
	return nil
end

function remove_element_from_list(_table, object)
	local ind = find_index_from_list(_table, object)
	table.remove(_table, ind)
end

function set_element_object(container, object)
	if container then
		container.config.object:remove()
		container.config.object = object
		if object then
			object.config.parent = container
		else
			container.config.object = Moveable()
		end
		container.UIBox:recalculate()
	end
end

function remove_unavailable(_table)
	local _t2 = {}
	for _, v in ipairs(_table) do 
		if v ~= "UNAVAILABLE" then
			table.insert(_t2, v)
		end
	end
	return _t2
end


G.C.HP_JTEM = {
	STATS = {
		SPEED   = HEX("556665"),
		STAMINA = HEX("FF5E73"),
		POWER   = HEX("64A7FF"),
		GUTS    = HEX("FFCD29"),
		WITS    = HEX("5DF158"),
	},
	RANKS = {
		G   = HEX("686868"), 
		F   = HEX("7071AA"),
		E   = HEX("B157C4"),
		D   = HEX("7CCFFF"),
		C   = HEX("55DF39"),
		B   = HEX("FF5D85"),
		A   = HEX("FF9C59"),
		S   = HEX("FCFF3D"),
		SS  = HEX("FFC037"),
	}
}

G.ARGS.LOC_COLOURS.jtem_stats_speed = G.C.HP_JTEM.STATS.SPEED
G.ARGS.LOC_COLOURS.jtem_stats_stamina = G.C.HP_JTEM.STATS.STAMINA
G.ARGS.LOC_COLOURS.jtem_stats_power = G.C.HP_JTEM.STATS.POWER
G.ARGS.LOC_COLOURS.jtem_stats_guts = G.C.HP_JTEM.STATS.GUTS
G.ARGS.LOC_COLOURS.jtem_stats_wits = G.C.HP_JTEM.STATS.WITS

SMODS.Gradient{
	key = "jtem_training_ug",
	colours = {
		HEX("3FD2FF"),
		HEX("A14FFF"),
		HEX("FF55F6"),
	},
	cycle = 4
}
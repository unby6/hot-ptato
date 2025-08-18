-- Might as well lmao
function init_jtem(game)
	game.spark_points = 0
	game.hpot_events_encountered = {}
end

-- For the splash text
function ease_splash_text(delta, reset)
	if not G.SPLASH_TEXT then
		return
	end
	-- ease to desired scale
	G.E_MANAGER:add_event(
		Event({
			trigger = "ease",
			ease = "quad",
			ref_table = G.SPLASH_TEXT,
			ref_value = "scale",
			ease_to = reset and 0.4 or (0.4 + delta),
			delay = 0.4,
			pause_force = true,
			func = function(t)
				G.SPLASH_TEXT.config.spacing = G.SPLASH_TEXT.config.spacing * t
				G.SPLASH_TEXT:update_text(true)
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

-- Might as well lmao
function init_jtem(game)
	game.spark_points = 0
end

-- For the splash text
function ease_splash_text(delta, reset)
    if not G.SPLASH_TEXT then return end
    -- ease to desired scale
    G.E_MANAGER:add_event(Event({
        trigger = 'ease',
        ease = 'quad',
        ref_table = G.SPLASH_TEXT,
        ref_value = 'scale',
        ease_to = reset and 0.4 or (0.4 + delta),
        delay = 0.4,
		pause_force = true,
        func = (function(t)
            G.SPLASH_TEXT.config.spacing = G.SPLASH_TEXT.config.spacing*t
            G.SPLASH_TEXT:update_text(true)
            return t
        end) 
    }), "splash_text")
    -- call it again as an event, this time backwards or vice versa. yes this is recursive
    G.E_MANAGER:add_event(Event({
		pause_force = true,
        func = function() 
            ease_splash_text(delta, not reset)
            return true
        end
    }), "splash_text")
end
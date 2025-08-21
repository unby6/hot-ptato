-- I did this so it can be used elsewhere

-- Default draw function for mood
local function mood_draw(self, card, layer)
	self.sticker_sprite.role.draw_major = card
	self.sticker_sprite:draw_shader('dissolve', 0, nil, nil, card.children.center, nil, nil, 0,
		0.1 + (-8 * (card.T.h / 95) * card.T.scale), nil, 0.6)
	self.sticker_sprite:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, nil, 0,
		(-8 * (card.T.h / 95) * card.T.scale))
end

-- Default loc vars function for mood (using mult)
local function mood_loc_vars(self, info_queue, card)
	return { vars = { math.abs(1 - card.ability[self.key].mult) * 100 } }
end

-- Default apply function for mood (copies config table)
local function mood_apply(self, card, val)
	card.ability[self.key] = val and copy_table(self.config) or nil
end

-- Checks if a card has a mood sticker.
function hpot_has_mood(card)
	for _, sticker in pairs(SMODS.Sticker.obj_buffer) do
		if card.ability and card.ability[sticker] then
			return sticker
		end
	end
	return nil
end

-- Mood stickers
SMODS.Sticker {
	key = "mood_awful",
	atlas = "jtem_mood",
	pos = { x = 0, y = 0 },
	config = { mult = 0.8 },
	hpot_mood_sticker = true,
	loc_vars = mood_loc_vars,
	loc_txt = {
		name = "Awful",
		text = {
			"Lowers training",
			"results by {C:red}#1#%{}"
		},
		label = "Awful"
	},
	apply = mood_apply,
	badge_colour = HEX('955adf'),
	draw = mood_draw,
	hotpot_credits = {
		art = { "Haya" },
		idea = { "Aikoyori" },
		code = { "Haya" },
		team = { "Jtem" }
	}
}
SMODS.Sticker {
	key = "mood_bad",
	atlas = "jtem_mood",
	pos = { x = 1, y = 0 },
	config = { mult = 0.9 },
	hpot_mood_sticker = true,
	loc_vars = mood_loc_vars,
	loc_txt = {
		name = "Bad",
		text = {
			"Lowers training",
			"results by {C:red}#1#%{}"
		},
		label = "Bad"
	},
	apply = mood_apply,
	badge_colour = HEX('0082d3'),
	draw = mood_draw,
	hotpot_credits = {
		art = { "Haya" },
		idea = { "Aikoyori" },
		code = { "Haya" },
		team = { "Jtem" }
	}
}
SMODS.Sticker {
	key = "mood_normal",
	atlas = "jtem_mood",
	pos = { x = 2, y = 0 },
	config = { mult = 1 },
	hpot_mood_sticker = true,
	loc_txt = {
		name = "Normal",
		text = {
			"No effects"
		},
		label = "Normal"
	},
	apply = mood_apply,
	badge_colour = HEX('f4d401'),
	draw = mood_draw,
	hotpot_credits = {
		art = { "Haya" },
		idea = { "Aikoyori" },
		code = { "Haya" },
		team = { "Jtem" }
	}
}
SMODS.Sticker {
	key = "mood_good",
	atlas = "jtem_mood",
	pos = { x = 3, y = 0 },
	config = { mult = 1.1 },
	hpot_mood_sticker = true,
	loc_vars = mood_loc_vars,
	loc_txt = {
		name = "Good",
		text = {
			"Increases training",
			"results by {C:attention}#1#%{}"
		},
		label = "Good"
	},
	apply = mood_apply,
	badge_colour = HEX('f98938'),
	draw = mood_draw,
	hotpot_credits = {
		art = { "Haya" },
		idea = { "Aikoyori" },
		code = { "Haya" },
		team = { "Jtem" }
	}
}
SMODS.Sticker {
	key = "mood_great",
	atlas = "jtem_mood",
	pos = { x = 4, y = 0 },
	config = { mult = 1.2 },
	hpot_mood_sticker = true,
	loc_vars = mood_loc_vars,
	loc_txt = {
		name = "Great",
		text = {
			"Increases training",
			"results by {C:attention}#1#%{}"
		},
		label = "Great"
	},
	apply = mood_apply,
	badge_colour = HEX('f1306d'),
	draw = mood_draw,
	hotpot_credits = {
		art = { "Haya" },
		idea = { "Aikoyori" },
		code = { "Haya" },
		team = { "Jtem" }
	}
}

G.FUNCS.hpot_can_train_joker = function(e)
	---@type Card
	local card = e.config.ref_table
	if not ((G.play and #G.play.cards > 0) or
			(G.CONTROLLER.locked) or
			(G.GAME.STOP_USE and G.GAME.STOP_USE > 0)) then
		e.config.colour = G.C.GREEN
		e.config.button = 'hpot_start_training_joker'
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end

-- This Joker is now training
function G.FUNCS.hpot_start_training_joker(e)
	---@type Card
	local card = e.config.ref_table
	G.CONTROLLER.locks.use = true
	card:highlight(false)
	G.E_MANAGER:add_event(Event{
		trigger = 'after',
		delay = 0.25*G.SPEEDFACTOR,
		func = function()
			SMODS.Stickers["hpot_mood_normal"]:apply(card, true)
			-- This process is irreversible!
			card.ability.hpot_training_mode = true
			card:juice_up(0.3, 0.3)
			play_sound('gold_seal', 1.2, 0.4)
			return true
		end
	})
	G.E_MANAGER:add_event(Event{
		trigger = 'after',
		delay = 0.4*G.SPEEDFACTOR,
		func = function()
			G.CONTROLLER.locks.use = nil
			return true
		end
	})
end

-- Jokers can have a 'TRAIN' button at the bottom when highlighted
function hpot_joker_train_button_definition(card)
	return {
		n = G.UIT.R,
		config = { ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5 * card.T.w - 0.15, maxw = 0.9 * card.T.w - 0.15, minh = 0.3 * card.T.h, hover = true, shadow = true, colour = G.C.UI.BACKGROUND_INACTIVE, one_press = true, button = 'hpot_start_training_joker', func = 'hpot_can_train_joker' },
		nodes = {
			{ n = G.UIT.T, config = { text = localize('b_hpot_train'), colour = G.C.UI.TEXT_LIGHT, scale = 0.45, shadow = true } }
		}
	}
end

SMODS.draw_ignore_keys.hpot_train_button = true

SMODS.DrawStep {
	key = 'train_button',
	order = -30,
	func = function(self)
		--Draw any tags/buttons
		if self.children.hpot_train_button and self.highlighted then self.children.hpot_train_button:draw() end
	end,
}

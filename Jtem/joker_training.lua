-- I did this so it can be used elsewhere

-- Default draw function for mood
local function mood_draw(self, card, layer)
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

local index_to_mood = {
    [1] = "awful",
    [2] = "bad",
    [3] = "normal",
    [4] = "good",
    [5] = "great",
    -- lmaooo
}

local mood_to_index = {
    ["awful"] = 1,
    ["bad"] = 2,
    ["normal"] = 3,
    ["good"] = 4,
    ["great"] = 5,
    -- lmaooo
}

local mood_to_multiply = {
    ["awful"] = 0.8,
    ["bad"] = 0.9,
    ["normal"] = 1,
    ["good"] = 1.1,
    ["great"] = 1.2,
    -- lmaooo
}

-- changes mood
function hot_mod_mood(card, mood_mod)
    
end

HP_MOOD_STICKERS = {}

-- Mood stickers
SMODS.Sticker {
	key = "jtem_mood",
    rate = 0,
	atlas = "jtem_mood",
	pos = { x = 2, y = 0 },
	hpot_mood_sticker = true,
	loc_vars = function (self, info_queue, card)
        return { 
            vars = { math.abs(mood_to_multiply[card.ability["hp_jtem_mood"] or "normal"]) * 100 }, 
            key = self.key .. "_" .. (card.ability.hp_jtem_mood or "normal")  }
    end,
	apply = function(self, card, val)
        card.ability[self.key] = val
        card.ability["hp_jtem_mood_config"] = self.config
        card.ability["hp_jtem_mood"] = "normal"
    end,
    draw = function (self, card, layer)
        local val = card.ability["hp_jtem_mood"] or "normal"
        
        HP_MOOD_STICKERS[val] = HP_MOOD_STICKERS[val] or Sprite(card.T.x, card.T.y, G.CARD_W, G.CARD_H, G.ASSET_ATLAS["hpot_jtem_mood"], { x = (mood_to_index[val] or 3) - 1, y = 0})
        HP_MOOD_STICKERS[val].role.draw_major = card
        HP_MOOD_STICKERS[val]:draw_shader('dissolve', 0, nil, nil, card.children.center, nil, nil, 0,
            0.1 + (-8 * (card.T.h / 95) * card.T.scale), nil, 0.6)
        HP_MOOD_STICKERS[val]:draw_shader('dissolve', nil, nil, nil, card.children.center, nil, nil, 0,
            (-8 * (card.T.h / 95) * card.T.scale))
    end,
	badge_colour = HEX('955adf'),
	hotpot_credits = {
		art = { "Haya" },
		idea = { "Aikoyori" },
		code = { "Haya", "Aikoyori" },
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
			SMODS.Stickers["hpot_jtem_mood"]:apply(card, true)
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

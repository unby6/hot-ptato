function HPTN.process_loc_text()
	G.localization.descriptions.Modification = G.localization.descriptions.Modification or {}
end

HPTN.Modifications = {}
HPTN.Modification = SMODS.GameObject:extend({
	required_params = { "key" },
	set = "Modification",
	atlas = "tname_stickers",
	pos = { x = 0, y = 0 },
	obj_table = HPTN.Modifications,
	obj_buffer = {},
	badge_colour = HEX("FFFFFF"),
	sets = { Joker = true },
	unlocked = true,
	discovered = true,
	config = {},
	morality = "GOOD",
	class_prefix = "modif",
	needs_enable_flag = true,
	draw = function(self, card)
		local x_offset = (card.T.w / 71) * card.T.scale
		G.shared_stickers[self.key].role.draw_major = card
		G.shared_stickers[self.key]:draw_shader("dissolve", nil, nil, nil, card.children.center, nil, nil, x_offset)
	end,
	process_loc_text = function(self)
		SMODS.process_loc_text(G.localization.descriptions[self.set], self.key, self.loc_txt)
		SMODS.process_loc_text(G.localization.misc.labels, self.key, self.loc_txt, "label")
	end,
	register = function(self)
		if self.registered then
			sendWarnMessage(("Detected duplicate register call on object %s"):format(self.key), self.set)
			return
		end
		HPTN.Modification.super.register(self)
		self.order = #self.obj_buffer
	end,
	inject = function(self)
		self.sticker_sprite = Sprite(0, 0, G.CARD_W, G.CARD_H, G.ASSET_ATLAS[self.atlas], self.pos)
		G.shared_stickers[self.key] = self.sticker_sprite
	end,
	apply = function(self, card, val)
		card.ability[self.key] = val
		if val and self.config and next(self.config) then
			card.ability[self.key] = {}
			for k, v in pairs(self.config) do
				if type(v) == "table" then
					card.ability[self.key][k] = copy_table(v)
				else
					card.ability[self.key][k] = v
				end
			end
		end
        SMODS.calculate_context({
			hpot_mod_apply = true,
			hpot_mod_applied = self,
		})
	end,
	loc_vars = function(self)
		return {}
	end,
	pre_inject_class = function(self)
		G.P_CENTER_POOLS[self.set] = {}
	end,
})

SMODS.DrawStep({
	key = "modifications",
	order = 40,
	func = function(self, layer)
		if self.sticker and G.shared_stickers[self.sticker] then
			G.shared_stickers[self.sticker].role.draw_major = self
			G.shared_stickers[self.sticker]:draw_shader("dissolve", nil, nil, nil, self.children.center)
			G.shared_stickers[self.sticker]:draw_shader(
				"voucher",
				nil,
				self.ARGS.send_to_shader,
				nil,
				self.children.center
			)
		elseif (self.sticker_run and G.shared_stickers[self.sticker_run]) and G.SETTINGS.run_stake_stickers then
			G.shared_stickers[self.sticker_run].role.draw_major = self
			G.shared_stickers[self.sticker_run]:draw_shader("dissolve", nil, nil, nil, self.children.center)
			G.shared_stickers[self.sticker_run]:draw_shader(
				"voucher",
				nil,
				self.ARGS.send_to_shader,
				nil,
				self.children.center
			)
		end

		for k, v in pairs(HPTN.Modifications) do
			if self.ability[v.key] then
				if v and v.draw and type(v.draw) == "function" then
					v:draw(self, layer)
				else
					G.shared_stickers[v.key].role.draw_major = self
					G.shared_stickers[v.key]:draw_shader("dissolve", nil, nil, nil, self.children.center)
					G.shared_stickers[v.key]:draw_shader(
						"voucher",
						nil,
						self.ARGS.send_to_shader,
						nil,
						self.children.center
					)
				end
			end
		end
	end,
	conditions = { vortex = false, facing = "front" },
})

function HPTN.modif_apply(modif, card)
	local sticker = HPTN.Modifications[modif]
	sticker:apply(card, true)
	SMODS.enh_cache:write(card, nil)
end

function Card:remove_modification(modif)
	if self.ability[modif] then
		HPTN.Modifications[modif]:apply(self, false)
		SMODS.enh_cache:write(self, nil)
	end
end

function Card:calculate_modification(context, key)
	local modif = HPTN.Modifications[key]
	if self.ability[key] and type(modif.calculate) == "function" then
		local o = modif:calculate(self, context)
		if o then
			if not o.card then
				o.card = self
			end
			return o
		end
	end
end

local function mod_ui()
	local mods = {}

	for k, v in pairs(HPTN.Modifications) do
		mods[k] = v
	end

	return SMODS.card_collection_UIBox(mods, { 5, 5 }, {
		snap_back = true,
		hide_single_page = true,
		collapse_single_page = true,
		center = "c_base",
		h_mod = 1.18,
		back_func = "your_collection_other_gameobjects",
		modify_card = function(card, center)
			center:apply(card, true)
		end,
	})
end

G.FUNCS.your_collection_hpot_modifications = function()
	G.SETTINGS.paused = true
	G.FUNCS.overlay_menu({
		definition = mod_ui(),
	})
end


-- Modifications 

HPTN.Modification({
	key = "ruthless",
	atlas = "tname_stickers",
	morality = "GOOD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        -- brrr
	end,
})


HPTN.Modification({
	key = "greedy",
	atlas = "tname_stickers",
	morality = "GOOD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        if context.post_trigger and context.other_joker == card then
           SMODS.calculate_effect({dollars = 2}, card)
        end
	end,
})

HPTN.Modification({
	key = "jumpy",
	atlas = "tname_stickers",
	morality = "GOOD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        if context.post_trigger and context.other_joker == card then
           SMODS.calculate_effect({x_mult = 1.1}, card)
        end
	end,
})

HPTN.Modification({
	key = "invested",
	atlas = "tname_stickers",
	morality = "GOOD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        if context.end_of_round then
            if card.set_cost then 
                card.ability.extra_value = (card.ability.extra_value or 0) + 1
                card:set_cost()
            end
        end
	end,
})

HPTN.Modification({
	key = "magnified",
	atlas = "tname_stickers",
	morality = "GOOD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        --brrr
	end,
})

HPTN.Modification({
	key = "damaged",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        if context.post_trigger and context.other_card == card then
            if pseudorandom("damaged") < G.GAME.probabilities.normal / 5 then
                SMODS.destroy_cards(card)
            end
        end
	end,
})

HPTN.Modification({
	key = "old",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        --brrr
	end,
})

HPTN.Modification({
	key = "supported",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        --brrr
	end,
})

HPTN.Modification({
	key = "dozing",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        --brrr
	end,
})

HPTN.Modification({
	key = "smudged",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        if context.post_trigger and context.other_joker == card then
           SMODS.calculate_effect({x_mult = 0.9}, card)
        end
	end,
})

HPTN.Modification({
	key = "depreciating",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        if context.end_of_round then
            if card.set_cost then 
                card.ability.extra_value = (card.ability.extra_value or 0) - 1
                card:set_cost()
            end
        end
	end,
})

HPTN.Modification({
	key = "legendary ",
	atlas = "tname_stickers",
	morality = "GOOD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        --brrr
	end,
})

HPTN.Modification({
	key = "dying",
	atlas = "tname_stickers",
	morality = "BAD",
	pos = { x = 0, y = 0 },
	calculate = function(self, card, context)
        --brrr
	end,
})
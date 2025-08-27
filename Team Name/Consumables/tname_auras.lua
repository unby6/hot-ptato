SMODS.ConsumableType({
	key = "auras",
	collection_rows = { 4, 2},
	primary_colour = G.C.GREY,
	secondary_colour = G.C.GREY,
	shop_rate = nil,
})

SMODS.Consumable({
	key = "justice",
	set = "auras",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			slots = 2,
            credits = 60
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.slots, hpt.credits },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    G.jokers.config.card_limit = G.jokers.config.card_limit - hpt.slots
                end
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                HPTN.ease_credits(60, false)
                return true
            end,
        }))
	end,
})

SMODS.Consumable({
	key = "fear",
	set = "auras",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
            credits = 10
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.credits },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
        local badstickers = {
            "eternal",
            "perishable",
            "rental",
            "hpot_cfour",
            "hpot_spinning",
            "hpot_uranium",
            "hpot_nuke",
            "hpot_spore",
            "hpot_rage"
        }
        local function g(joker)
            local appliedsticker = badstickers[pseudorandom("fuck", 1, #badstickers)]
            if joker.ability[appliedsticker] then
                g(joker)
            else
                return appliedsticker
            end
        end
        for k, v in ipairs(G.jokers.cards) do
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                SMODS.Stickers[g(v)]:apply(v, true)
                HPTN.ease_credits(hpt.credits)
                return true
            end
        }))
        end
	end,
})

SMODS.Consumable({
	key = "perception",
	set = "auras",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			leavinghands = 1,
            credits = 20
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.leavinghands, hpt.credits },
		}
	end,
	can_use = function(self, card)
		if G.GAME.round_resets.hands <= card.ability.extra.leavinghands then
			return false
		else
			return true
		end
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		local fuck = G.GAME.round_resets.hands
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.round_resets.hands = hpt.leavinghands
				ease_hands_played(-(fuck - hpt.leavinghands))
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            func = function()
                HPTN.ease_credits((fuck - hpt.leavinghands) * hpt.credits, false)
                return true
            end,
        }))
	end,
})

SMODS.Joker({
	key = "sticker_master",
	rarity = 2,
	config = {
		extra = {
			mult = 5,
		},
	},
	atlas = "tname_jokers",
	pos = {
		x = 0,
		y = 0
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		if G.jokers and G.jokers.cards then
			return {
				vars = { hpt.mult, hpt.mult * sticker_check(G.jokers.cards) },
			}
		else
			return {
				vars = { hpt.mult, hpt.mult * 0 },
			}
		end
	end,
	calculate = function(self, card, context)
		local hpt = card.ability.extra
		if context.joker_main then
			return {
				mult = hpt.mult * sticker_check(G.jokers.cards),
			}
		end
	end,
	in_pool = function(self)
		if G.jokers and G.jokers.cards and sticker_check(G.jokers.cards) > 0 then
			return true
		end
		return false
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"Revo"},
        code = {"Revo"},
        team = {"Team Name"}
    }
})

SMODS.Joker({
	key = "power_plant",
	rarity = 2,
	cost = 0,
	credits = 5,
	config = {
		extra = {
			dollars = 2
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		if G.jokers and G.jokers.cards then
			return {
				vars = { hpt.dollars, hpt.dollars * sticker_check(add_tables({G.jokers.cards, G.playing_cards}), "hpot_uranium") },
			}
		else
			return {
				vars = { hpt.dollars, hpt.dollars * 0 },
			}
		end
	end,

	calc_dollar_bonus = function(self,card)
		local hpt = card.ability.extra
		return hpt.dollars * sticker_check(add_tables({G.jokers.cards, G.playing_cards}), "hpot_uranium")
	end,

	in_pool = function(self)
		if G.jokers and G.jokers.cards and sticker_check(add_tables({G.jokers.cards, G.playing_cards}), "hpot_uranium") > 0 then
			return true
		end
		return false
	end,

    hotpot_credits = {
        art = {"No Art"},
        idea = {"Corobo"},
        code = {"Revo"},
        team = {"Team Name"}
    }
})


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
	key = "missing_texture",
	rarity = 2,
	atlas = "tname_jokers",
	pos = {
		x = 2,
		y = 2
	},
    config = { extra = { max = 25, min = -40 } },
    loc_vars = function(self, info_queue, card)
        local r_mults = {}
		local jank = ""
        for i = card.ability.extra.min, card.ability.extra.max do
			if i < 0 then
				jank = " - "
			else
				jank = " + " 
			end
            r_mults[#r_mults + 1] = jank..math.abs(i)
        end
        local loc_mult = {string = ' ' .. (localize('k_credits')) .. ' ', colour = G.C.PURPLE}
        main_start = {
            { n = G.UIT.O, config = { object = DynaText({ string = r_mults, colours = { G.C.PURPLE }, pop_in_rate = 9999999, silent = true, random_element = true, pop_delay = 0.5, scale = 0.32, min_cycle_time = 0 }) } },
            {
                n = G.UIT.O,
                config = {
                    object = DynaText({
                        string = {
                            { string = 'pseudorand', colour = G.C.JOKER_GREY }, { string = "Oops! the ", colour = G.C.JOKER_GREY }, { string = "game crashed.", colour = G.C.JOKER_GREY }, { string = "..index a nil v..", colour = G.C.JOKER_GREY },
                            loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult, loc_mult,
                            loc_mult, loc_mult, loc_mult, loc_mult },
                        colours = { G.C.UI.TEXT_DARK },
                        pop_in_rate = 9999999,
                        silent = true,
                        random_element = true,
                        pop_delay = 0.2011,
                        scale = 0.32,
                        min_cycle_time = 0
                    })
                }
            },
        }
        return { main_start = main_start }
    end,
	calculate = function(self, card, context)
		local fuck = pseudorandom("fuck", card.ability.extra.min, card.ability.extra.max)
		if context.joker_main then
			HPTN.ease_credits(fuck, false)
			return {
				message = "+c."..fuck,
				colour = G.C.PURPLE
			}
		end
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})
-- fixed this btw
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
	pos = {x=6,y=0},
	atlas = "tname_jokers2",
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
        art = {"GhostSalt"},
        idea = {"Corobo"},
        code = {"Revo"},
        team = {"Team Name"}
    }
})

SMODS.Joker({
	key = "sticker_dealer",
	rarity = 2,
	config = {
		extra = {
			xmult = 1,
			xmultg = 0.1
		},
	},
	pos = {x=7,y=0},
	atlas = "tname_jokers2",
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
			return {
				vars = { hpt.xmult, hpt.xmultg},
			}
	end,
	calculate = function(self, card, context)
		local hpt = card.ability.extra
		if context.setting_blind then
			local rr = nil
			for i = 1, #G.jokers.cards do
				if G.jokers.cards[i] == card then
					rr = i
				end
			end

			local _card =  pseudorandom_element({1,-1},pseudoseed("sticker_dealer"))
			local k = pseudorandom_element(SMODS.Stickers,pseudoseed("sticker_dealer"))
			if G.jokers.cards[rr + (_card)] then
				SMODS.Stickers[k.key]:apply(G.jokers.cards[rr + (_card)], true)

				hpt.xmult = hpt.xmult + hpt.xmultg
				return{
					message = localize("k_upgrade_ex")
				}
			end
		end
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"Revo"},
        code = {"Revo"},
        team = {"Team Name"}
    }
})

SMODS.Joker({
	key = "credits_ex",
	rarity = 2,
	config = {
		extra = {
			xmult = 0.5,
			credits = 10,
			hands = 0
		},
	},
	pos = {x=8,y=0},
	atlas = "tname_jokers2",
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
			return {
				vars = { hpt.xmult, hpt.credits},
			}
	end,
	calculate = function(self, card, context)
		local hpt = card.ability.extra
		if context.end_of_round then
			HPTN.ease_credits(hpt.credits * hpt.hands)
		end
		if context.setting_blind then
			hpt.hands = 0
		end
		if context.press_play then
			hpt.hands = hpt.hands + 1
		end
		if context.joker_main then
			return {
				xmult = hpt.xmult,
			}
		end
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})
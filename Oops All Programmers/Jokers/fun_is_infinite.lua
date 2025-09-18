SMODS.Joker {
    key = "fun_is_infinite",
    blueprint_compat = true,
    rarity = 3,
    cost = 8,
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 },
    config = { extra = { xmult = 1.75 } },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { key = "eternal", set = "Other" }
        return { vars = { card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.other_joker and SMODS.is_eternal(context.other_joker, card) then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    hotpot_credits = {
        art = { "?" },
        code = { "trif" },
        idea = { "th30ne" },
        team = { "Oops! All Programmers" }
    }
}
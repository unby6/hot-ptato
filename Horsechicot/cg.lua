---@diagnostic disable: undefined-field




function Horsechicot.num_jokers()
    if Horsechicot.joker_count_cache then
        return Horsechicot.joker_count_cache
    end
    Horsechicot.joker_count_cache = 0
    for i, v in pairs(G.P_CENTERS) do
        if string.sub(i, 1, 2) == "j_" and not v.no_collection then
            Horsechicot.joker_count_cache = Horsechicot.joker_count_cache + 1
        end
    end
    return Horsechicot.joker_count_cache
end

SMODS.Atlas {
    key = "cg223",
    path = "Horsechicot/cg223.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "cg223",
    rarity = 4,
    atlas = "cg223",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        card.ability.extra.chips = card.ability.extra.extra * Horsechicot.num_jokers()
        return { vars = { card.ability.extra.extra, card.ability.extra.chips } }
    end,
    config = {
        extra = {
            chips = 0,
            extra = 1,
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.chips = card.ability.extra.extra * Horsechicot.num_jokers()
            return { chips = card.ability.extra.chips }
        end
    end,
    hotpot_credits = Horsechicot.credit("cg223", "my shitass ex")
}



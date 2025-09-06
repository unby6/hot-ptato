SMODS.Joker {
    key = "faceblindness",
    config = {
        extra = {
            numerator = 1,
            denominator = 3
        }
    },
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator, card.ability.extra.denominator, 'faceblindness')
        return { vars = { numerator, denominator } }
    end,
    rarity = 3,
    cost = 8,
    atlas = "smiley_jokers",
    pos = {x=1,y=1},
    hotpot_credits = {
        art = {"RGBeet"},
        idea = {"PokéRen"},
        code = {"PokéRen"},
        team = {":)"}
    }
}

-- code is actually in emoticon.lua's hook lmao
SMODS.Joker {
    key = "onemillionifstatements",
    config = {
        extra = {
            x_mult =  2,
            x_chips = 2
        }
    },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.x_mult, card.ability.extra.x_chips } }
    end,
    rarity = 3,
    cost = 8,
    atlas = "smiley_jokers",
    pos = {x=2,y=0},
    hotpot_credits = {
        art = {"notmario"},
        idea = {"notmario"},
        code = {"PokéRen"},
        team = {":)"}
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = (mult % 2 == 0) and card.ability.extra.x_mult,
                x_chips = (hand_chips % 2 == 0) and card.ability.extra.x_chips
            }
        end
    end
}
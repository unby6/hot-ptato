SMODS.Joker {
    key = "hc_genghis_khan",
    config = {
        current = 1,
        increment = 0.5
    },
    cost = 8,
    rarity = 3,
    atlas = "hc_jokers",
    pos = {x = 3, y = 4},
    hotpot_credits = Horsechicot.credit("cg223", "Pangaea", "cg223"),
    loc_vars = function (self, info_queue, card)
        return {vars = {card.ability.increment, card.ability.current}}
    end,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.current
            }
        elseif context.baby_made and context.father == card and not context.blueprint then
            SMODS.scale_card(card, {ref_table = card.ability, ref_value = "current", scalar_value = "increment"})
        end
    end
}
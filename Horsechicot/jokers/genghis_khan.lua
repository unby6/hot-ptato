SMODS.Joker {
    key = "hc_genghis_khan",
    config = {
        current = 1,
        increment = 0.5
    },
    hotpot_credits = Horsechicot.credit("cg223", "Pangaea", "cg223"),
    loc_vars = function (self, info_queue, card)
        return {vars = {card.ability.increment, card.ability.current}}
    end,
    calculate = function (self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.current
            }
        elseif context.baby_made and context.father == card then
            SMODS.scale_card(card, {ref_table = card.ability, ref_value = "current", scalar_value = "increment"})
            card.ability.current = card.ability.current + card.ability.increment
            return {
                message = localize("k_upgrade_ex")
            }
        end
    end
}
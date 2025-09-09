SMODS.Joker {
    key = "yapper",
    hotpot_credits = Horsechicot.credit("cg223", nil, "cg223"),
    rarity = 1,
    cost = 4,
    config = {
        current = HPJTTT.text[1],
        amt = 1
    },
    loc_vars = function (self, info_queue, card)
        return {vars = { card.ability.amt, card.ability.current or HPJTTT.text[1], string.len(card.ability.current) * card.ability.amt}}
    end,
    calculate = function (self, card, context)
        if context.after then
            card.ability.current = pseudorandom_element(HPJTTT.text, "hc_yapper")
            return {
                message = "Reset!"
            }
        elseif context.joker_main then
            return {
                mult = string.len(card.ability.current) * card.ability.amt
            }
        end
    end
}
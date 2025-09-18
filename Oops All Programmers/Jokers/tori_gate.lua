SMODS.Joker {
    key = 'tori_gate',
    rarity = 1,
    cost = 5,
    atlas = "oap_jokers",
    pos = { x = 6, y = 1 },
    config = {
        extra = {
            chips = 20
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips, card.ability.extra.chips * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.Hanafuda or 0) } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Hanafuda" then
            return {
                message = localize { type = 'variable', key = 'a_chips', vars = { card.ability.extra.chips * G.GAME.consumeable_usage_total.Hanafuda } },
                colour = G.C.CHIPS
            }
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.Hanafuda or 0)
            }
        end
    end,
    hotpot_credits = {
        art = { '?' },
        code = { 'theAstra' },
        idea = { 'theAstra' },
        team = { 'Oops! All Programmers' }
    }
}

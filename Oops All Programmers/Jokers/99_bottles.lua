SMODS.Joker {
    key = '99_bottles',
    rarity = 2,
    cost = 6,
    atlas = "oap_jokers",
    pos = { x = 9, y = 1 },
    config = {
        extra = {
            mult = 2
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.mult * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.bottlecap or 0) } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "bottlecap" then
            return {
                message = localize { type = 'variable', key = 'a_mult', vars = { card.ability.extra.mult * G.GAME.consumeable_usage_total.bottlecap } },
                colour = G.C.MULT
            }
        end
        if context.joker_main then
            return {
                mult = card.ability.extra.mult *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.bottlecap or 0)
            }
        end
    end,
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'theAstra' },
        idea = { 'theAstra' },
        team = { 'Oops! All Programmers' }
    }
}

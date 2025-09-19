SMODS.Joker {
    key = 'atm',
    rarity = 1,
    cost = 5,
    atlas = "oap_jokers",
    pos = { x = 8, y = 1 },
    config = {
        extra = {
            money = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.money, card.ability.extra.money * (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.Czech or 0) } }
    end,
    calculate = function(self, card, context)
        if context.using_consumeable and not context.blueprint and context.consumeable.ability.set == "Czech" then
            return {
                message = '+' .. localize('$') .. G.GAME.consumeable_usage_total.Czech,
                colour = G.C.MONEY
            }
        end
        if context.end_of_round and context.cardarea == G.jokers then
            return {
                dollars = card.ability.extra.money *
                    (G.GAME.consumeable_usage_total and G.GAME.consumeable_usage_total.Czech or 0)
            }
        end
    end,
    hotpot_credits = {
        art = { 'SadCube' },
        code = { 'theAstra' },
        idea = { 'theAstra' },
        team = { 'Oops! All Programmers' }
    }
}

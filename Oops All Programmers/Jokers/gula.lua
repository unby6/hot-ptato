SMODS.Joker {
    key = 'gula',
    rarity = 3,
    cost = 7,
    atlas = "oap_jokers",
    config = {extra = {x_mult = 1}},
    perishable_compat = false,
    pos = { x = 8, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced and not context.blueprint then
            local mod = (G.GAME.plincoins > 0 and G.GAME.plincoins or 0) * 0.1 + -- Plincoins
            (G.GAME.cryptocurrency > 0 and G.GAME.cryptocurrency or 0) * 0.1 + -- Cryptocurrency
            (G.GAME.spark_points > 0 and G.GAME.spark_points or 0) * 0.000005 -- Spark Points
            if G.GAME.plincoins > 0 then ease_plincoins(-G.GAME.plincoins) end
            if G.GAME.cryptocurrency > 0 then ease_cryptocurrency(-G.GAME.cryptocurrency) end
            if G.GAME.spark_points > 0 then ease_spark_points(-G.GAME.spark_points) end
            card.ability.extra.x_mult = card.ability.extra.x_mult + mod
            if mod > 0 then
                return {
                    message = localize('k_upgrade_ex')
                }
            end
        end
        if context.joker_main then
            return {
                x_mult = card.ability.extra.x_mult
            }
        end
    end,
    hotpot_credits = {
        art = { 'Mysthaps' },
        code = { 'Mysthaps' },
        idea = { 'Mysthaps' },
        team = { 'Oops! All Programmers' }
    }
}
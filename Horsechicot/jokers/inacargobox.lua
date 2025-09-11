SMODS.Joker {
    key = "inacargobox",
    atlas = "hc_placeholder",
    pos = { x = 0, y = 0 },
    hotpot_credits = {
        art = {"???"},
        code = {"Nxkoo"},
        team = {"Horsechicot"}
    },
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    cost = 8,
    config = { extra = { xmult_per_delivery = 1.5 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.xmult_per_delivery
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            local valid_deliveries = G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue or 0
            if valid_deliveries > 0 then
                for i = 1, valid_deliveries do
                    SMODS.calculate_effect({ xmult = card.ability.extra.xmult_per_delivery }, card)
                end
            end
        end
    end
}

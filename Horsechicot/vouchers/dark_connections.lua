SMODS.Voucher {
    key = "hc_dark_connections",
    hotpot_credits = Horsechicot.credit("cg223"),
    config = {
        pct = 25
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {card.ability.pct}}
    end,
    redeem = function (self, voucher)
        G.GAME.dark_connections = true
        for i, v in pairs(G.market_jokers.cards or {}) do
            v:set_cost()
        end
    end,
}

SMODS.Voucher {
    key = "hc_underground_control",
    hotpot_credits = Horsechicot.credit("cg223"),
    config = {
        pct = 25
    },
    loc_vars = function (self, info_queue, card)
        return {vars = {card.ability.pct}}
    end,
    redeem = function (self, voucher)
        G.GAME.underground_control = true
    end,
    requires = {'v_hpot_hc_dark_connections'}
}
SMODS.Voucher {
    key = "hc_dark_connections",
    hotpot_credits = Horsechicot.credit("cg223"),
    redeem = function (self, voucher)
        G.GAME.dark_connections = true
    end,
}

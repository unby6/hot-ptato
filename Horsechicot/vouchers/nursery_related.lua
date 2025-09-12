SMODS.Voucher {
    key = "hc_parthenogenesis", --todo: atlas
    hotpot_credits = Horsechicot.credit("cg223"),
    redeem = function (self, voucher)
        G.GAME.guaranteed_breed_center = "mother"
    end,
}
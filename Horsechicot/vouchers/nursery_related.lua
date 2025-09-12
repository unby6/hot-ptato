SMODS.Voucher {
    key = "hc_parthenogenesis", --todo: atlas
    hotpot_credits = Horsechicot.credit("cg223", "lord.ruby"),
    redeem = function (self, voucher)
        G.GAME.guaranteed_breed_center = "mother"
    end,
    atlas = "hc_vouchers",
    pos = {x = 0, y = 3},
}

SMODS.Voucher {
    key = "hc_incubator",
    hotpot_credits = Horsechicot.credit("cg223"),
    redeem = function (self, voucher)
        G.GAME.quick_preggo = true
    end,
    requires = {"v_hpot_hc_parthenogenesis"},
    atlas = "hc_vouchers",
    pos = {x = 1, y = 3},
}
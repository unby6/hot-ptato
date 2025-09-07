SMODS.Voucher {
    key = "bitcoin_miner",
    config = {
        bitcoins = 0.5
    },
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.bitcoins
            }
        }
    end,
    atlas = "hc_vouchers",
    pos = {x = 0, y = 0},
    calc_crypto_bonus = function(self, card)
        if G.GAME.blind_on_deck == "Boss" then
            return card.ability.bitcoins
        end
    end
}

SMODS.Voucher {
    key = "crypto_farm",
    config = {
        bitcoins = 0.5
    },
    atlas = "hc_vouchers",
    pos = {x = 1, y = 0},
    loc_vars = function(self, q, card)
        return {
            vars = {
                card.ability.bitcoins
            }
        }
    end,
    calc_crypto_bonus = function(self, card)
        if G.GAME.blind_on_deck ~= "Boss" then
            return card.ability.bitcoins
        end
    end,
    requires = {'v_hpot_bitcoin_miner'}
}
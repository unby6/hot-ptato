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
    end,
    Horsechicot.credit("lord.ruby", "lord.ruby", "lord.ruby")
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
    requires = {'v_hpot_bitcoin_miner'},
    Horsechicot.credit("lord.ruby", "lord.ruby", "lord.ruby")
}

function Horsechicot.spawning_blocked(center)
    return center and G.GAME.spawning_blocked and G.GAME.spawning_blocked[center.key] or nil
end

SMODS.Voucher {
    key = "antibodies",
    atlas = "hc_vouchers",
    pos = {x = 0, y = 1},
    redeem = function()
       G.GAME.spawning_blocked = G.GAME.spawning_blocked or {}
       G.GAME.spawning_reset = "round"
    end,
    Horsechicot.credit("lord.ruby", "lord.ruby", "cg223")
}

SMODS.Voucher {
    key = "vaccination",
    atlas = "hc_vouchers",
    pos = {x = 1, y = 1},
    redeem = function()
       G.GAME.spawning_blocked = G.GAME.spawning_blocked or {}
       G.GAME.spawning_reset = "ante"
    end,
    requires = {'v_hpot_antibodies'},
    Horsechicot.credit("lord.ruby", nil, "cg223")
}

local create_cardref = create_card
function create_card(...)
    local card = create_cardref(...)
    if card.config.center.set == "Joker" and G.GAME.spawning_blocked then
        G.GAME.spawning_blocked[card.config.center_key] = true
    end
    return card
end


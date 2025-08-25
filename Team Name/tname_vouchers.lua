
SMODS.Voucher {
	key = 'digital_payment',
	pos = { x = 0, y = 0 },
    loc_vars = function (self, info_queue, card)
		return {
			vars = {
				(G.GAME.credits_cashout or 0)
			}
		}
	end,
	redeem = function(self, voucher)
		G.GAME.modifiers.interest_to_credits = true
	end,
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'GoldenLeaf'},
        team = {'Team Name'}
    }
}
--[[
SMODS.Voucher {
	key = 'digital_promotion', --i cant think of anything else
	pos = { x = 1, y = 0 },
	redeem = function(self, voucher)
		G.GAME.modifiers.hands_to_credits = true
	end,
	requires = {
		'v_hpot_wip1'
	},
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'GoldenLeaf'},
        team = {'Team Name'}
    }
}]]
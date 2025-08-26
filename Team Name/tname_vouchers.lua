
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

SMODS.Voucher {
	key = 'digital_promotion', --i cant think of anything else
	pos = { x = 1, y = 0 },
	redeem = function(self, voucher)
		G.GAME.modifiers.hands_to_credits = true
	end,
	requires = {
		'v_hpot_digital_payment'
	},
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'GoldenLeaf'},
        team = {'Team Name'}
    }
}

SMODS.Voucher {
	key = 'ref_dollars',
	pos = { x = 2, y = 0 },
    loc_vars = function (self, info_queue, card)
		return {
			vars = {
				(G.GAME.credits_cashout or 0)
			}
		}
	end,
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'Revo'},
        team = {'Team Name'}
    }
}

SMODS.Voucher {
	key = 'ref_joker_exc',
	pos = { x = 3, y = 0 },
	requires = {
		'v_hpot_ref_dollars'
	},
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'Revo'},
        team = {'Team Name'}
    }
}

SMODS.Voucher {
	key = 'cuttingcost',
	pos = { x = 2, y = 0 },
    loc_vars = function (self, info_queue, card)
		return {
			vars = {
				(G.GAME.credits_cashout or 0)
			}
		}
	end,
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'Corobo'},
        team = {'Team Name'}
    }
}

SMODS.Voucher {
	key = 'masters',
	pos = { x = 3, y = 0 },
	requires = {
		'v_hpot_cuttingcost'
	},
	hotpot_credits = {
        art = {'No Art'},
        code = {'Revo'},
        idea = {'Corobo'},
        team = {'Team Name'}
    }
}
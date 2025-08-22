SMODS.Voucher {
	key = 'exchange_rate',
	atlas = "jtem_vouchers",
	pos = { x = 0, y = 0 },
	redeem = function(self, voucher)
		G.GAME.hp_jtem_should_allow_buying_jx_from_plincoin = true
	end,
	hotpot_credits = {
        art = {'MissingNumber'},
        code = {'Haya'},
        idea = {'Aikoyori'},
        team = {'Jtem'}
    }
}

SMODS.Voucher {
	key = 'right_at_your_door',
	atlas = "jtem_vouchers",
	pos = { x = 0, y = 1 },
	redeem = function(self, voucher)
		G.GAME.hp_jtem_can_request_joker = true
	end,
	hotpot_credits = {
        art = {'MissingNumber'},
        code = {'Haya'},
        idea = {'Aikoyori'},
        team = {'Jtem'}
    }
}
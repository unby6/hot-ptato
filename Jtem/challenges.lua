SMODS.Challenge {
	key = 'plinko4ever',
	rules = {
		custom = {
			{ id = 'hpot_plinko_4ever' },
		}
	},
	apply = function(self)
		G.GAME.plincoins_per_round = 0
		G.GAME.current_round.plinko_roll_cost = 0
	end,
}

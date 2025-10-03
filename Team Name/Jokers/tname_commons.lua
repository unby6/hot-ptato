
SMODS.Joker({
	key = "nxkoo_joker",
	rarity = 1,
	pos = {x=0,y=1},
	atlas = "tname_jokers2",
    cost = 3,
	add_to_deck = function (self, card, from_debuff)
		local a = HPTN.nxkoofactor
		HPTN.nxkoofactor = HPTN.cheapkoofactor
		HPTN.cheapkoofactor = a
	end,
	remove_from_deck = function (self, card, from_debuff)
		local a = HPTN.nxkoofactor
		HPTN.nxkoofactor = HPTN.cheapkoofactor
		HPTN.cheapkoofactor = a
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})
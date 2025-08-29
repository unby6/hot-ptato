SMODS.Booster({
	key = "hanafuda_normal_1",
	atlas = "tname_boosters",
	pos = { x = 0, y = 0 },
	config = { extra = 3, choose = 1 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 4,
	weight = 0.6,
    draw_hand = true,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Hanafuda",
			skip_materialize = true,
		})
	end,
    hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "hanafuda_normal_2",
	atlas = "tname_boosters",
	pos = { x = 1, y = 0 },
	config = { extra = 3, choose = 1 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 4,
	weight = 0.6,
    draw_hand = true,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Hanafuda",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "hanafuda_jumbo_1",
	atlas = "tname_boosters",
	pos = { x = 2, y = 0 },
	config = { extra = 5, choose = 1 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 6,
	weight = 0.3,
    draw_hand = true,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Hanafuda",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "hanafuda_mega_1",
	atlas = "tname_boosters",
	pos = { x = 3, y = 0 },
	config = { extra = 5, choose = 2 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 7,
	weight = 0.11,
    draw_hand = true,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Hanafuda",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "hanafuda_ultra_1",
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_hpot_hanafuda_packs",
    draw_hand = true,
	create_card = function(self, card)
		return 
			SMODS.create_card({
				set = "Hanafuda",
				skip_materialize = true,
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

-- aura

SMODS.Booster({
	key = "auras_normal_1",
	atlas = "tname_boosters",
	pos = { x = 0, y = 1 },
	config = { extra = 3, choose = 1 },
	group_key = "k_hpot_auras_packs",
	cost = 4,
	weight = 0.6,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Aura",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "auras_normal_2",
	atlas = "tname_boosters",
	pos = { x = 1, y = 1 },
	config = { extra = 3, choose = 1 },
	group_key = "k_hpot_auras_packs",
	cost = 4,
	weight = 0.6,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Aura",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "auras_jumbo_1",
	atlas = "tname_boosters",
	pos = { x = 2, y = 1 },
	config = { extra = 5, choose = 1 },
	group_key = "k_hpot_auras_packs",
	cost = 6,
	weight = 0.3,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Aura",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "auras_mega_1",
	atlas = "tname_boosters",
	pos = { x = 3, y = 1 },
	config = { extra = 5, choose = 2 },
	group_key = "k_hpot_auras_packs",
	cost = 7,
	weight = 0.11,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "Aura",
			skip_materialize = true,
		})
	end,
        hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "auras_ultra_1",
	weight = 0.025,
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_hpot_auras_packs",
	create_card = function(self, card)
		return 
			SMODS.create_card({
				set = "Aura",
				skip_materialize = true,
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

-- Vanilla ultra packs

SMODS.Booster({
	key = "ultra_arcana",
	weight = 0.025,
	kind = "Arcana",
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_arcana_pack",
	draw_hand = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.choose,
				card.ability.extra,
			},
		}
	end,
	create_card = function(self, card)
		return 
			SMODS.create_card({
				set = "Tarot",
				skip_materialize = true,
				soulable = true,
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Violet" }, -- <- this is the one to blame for the awful code
		team = { "Team Name" },
	},
})
SMODS.Booster({
	key = "ultra_celestial",
	weight = 0.025,
	kind = "Celestial",
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_celestial_pack",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.choose,
				card.ability.extra,
			},
		}
	end,
	create_card = function(self, card)
		return 
			SMODS.create_card({
				set = "Planet",
				skip_materialize = true,
				soulable = true,
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Violet" }, -- <- this is the one to blame for the awful code
		team = { "Team Name" },
	},
})
SMODS.Booster({
	key = "ultra_standard",
	weight = 0.025,
	kind = "Standard",
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_standard_pack",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.choose,
				card.ability.extra,
			},
		}
	end,
	create_card = function(self, card)
		local ultra_card_edition, ultra_card_seal,ultra_card_enhancement = poll_edition(), SMODS.poll_seal(), SMODS.poll_enhancement()
        return 
			SMODS.create_card({
			    set = "Playing Card",
			    skip_materialize = true,
			    edition = ultra_card_edition,
			    seal = ultra_card_seal,
                enhancement = ultra_card_enhancement
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Violet" }, -- <- this is the one to blame for the awful code
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "ultra_spectral",
	weight = 0.025,
	kind = "Spectral",
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_spectral_pack",
	draw_hand = true,
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.choose,
				card.ability.extra,
			},
		}
	end,
	create_card = function(self, card)
		return 
			SMODS.create_card({
				set = "Spectral",
				skip_materialize = true,
				soulable = true,
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Violet" }, -- <- this is the one to blame for the awful code
		team = { "Team Name" },
	},
})

SMODS.Booster({
	key = "ultra_buffoon",
	weight = 0.025,
	kind = "Buffoon",
	cost = 0,
	credits = 100,
	pos = { x = 0, y = 0 },
	config = { extra = 7, choose = 3 },
	group_key = "k_buffoon_pack",
	loc_vars = function(self, info_queue, card)
		return {
			vars = {
				card.ability.choose,
				card.ability.extra,
			},
		}
	end,
	create_card = function(self, card)
		return 
			SMODS.create_card({
				set = "Joker",
				skip_materialize = true,
				soulable = true,
			})
		
	end,
	hotpot_credits = {
		art = { "N/A" },
		idea = { "Revo" },
		code = { "Violet" }, -- <- this is the one to blame for the awful code
		team = { "Team Name" },
	},
})

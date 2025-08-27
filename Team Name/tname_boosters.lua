SMODS.Booster({
	key = "hanafuda_normal_1",
	atlas = "tname_boosters",
	pos = { x = 0, y = 0 },
	config = { extra = 3, choose = 1 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 4,
	weight = 0.6,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "hanafuda",
            skip_materialize = true
		})
	end,
})

SMODS.Booster({
	key = "hanafuda_normal_2",
	atlas = "tname_boosters",
	pos = { x = 1, y = 0 },
	config = { extra = 3, choose = 1 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 4,
	weight = 0.6,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "hanafuda",
            skip_materialize = true
		})
	end,
})

SMODS.Booster({
	key = "hanafuda_jumbo_1",
	atlas = "tname_boosters",
	pos = { x = 2, y = 0 },
	config = { extra = 5, choose = 1 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 6,
	weight = 0.3,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "hanafuda",
            skip_materialize = true
		})
	end,
})

SMODS.Booster({
	key = "hanafuda_mega_1",
	atlas = "tname_boosters",
	pos = { x = 3, y = 0 },
	config = { extra = 5, choose = 2 },
	group_key = "k_hpot_hanafuda_packs",
	cost = 7,
	weight = 0.11,
	create_card = function(self, card, i)
		return SMODS.create_card({
			set = "hanafuda",
            skip_materialize = true
		})
	end,
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
			set = "auras",
            skip_materialize = true
		})
	end,
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
			set = "auras",
            skip_materialize = true
		})
	end,
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
			set = "auras",
            skip_materialize = true
		})
	end,
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
			set = "auras",
            skip_materialize = true
		})
	end,
})


-- Ultra packs

SMODS.Booster {
    key = "ultra_arcana",
    weight = 0.025,
    kind = 'Arcana',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_arcana_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Arcana Pack",
        text = {
            "Choose #1# of up to",
            "#2# Tarot cards to",
            "be used immediately"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Tarot", area = G.pack_cards, skip_materialize = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}
SMODS.Booster {
    key = "ultra_celestial",
    weight = 0.025,
    kind = 'Celestial',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_celestial_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Celestial Pack",
        text = {
            "Choose #1# of up to",
            "#2# Planet cards to",
            "be used immediately"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Planet", area = G.pack_cards, skip_materialize = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}
SMODS.Booster {
    key = "ultra_standard",
    weight = 0.025,
    kind = 'Standard',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_standard_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Standard Pack",
        text = {
            "Choose #1# of up to",
            "#2# Playing cards to",
            "add to your deck"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        local ultra_card_edition, ultra_card_seal = nil, nil
        if pseudorandom("ultra_edition_grab", 1, 50) == 25 then
            ultra_card_edition = poll_edition(pseudoseed("ultra_poll_edition_random_seed"), 1, true, false)
        end
        if pseudorandom("ultra_seal_grab", 1, 10) == 5 then
            ultra_card_seal = SMODS.poll_seal({type_key = "ultra_poll_seaL_random_seed",  guaranteed = true})
        end
        return {set = "Playing Card", area = G.pack_cards, skip_materialize = true, edition = ultra_card_edition, seal = ultra_card_seal}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}

SMODS.Booster {
    key = "ultra_spectral",
    weight = 0.025,
    kind = 'Spectral',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_spectral_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Spectral Pack",
        text = {
            "Choose #1# of up to",
            "#2# Spectral cards to",
            "be used immediately"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Spectral", area = G.pack_cards, skip_materialize = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}

SMODS.Booster {
    key = "ultra_buffoon",
    weight = 0.025,
    kind = 'Buffoon',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_buffoon_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Buffoon Pack",
        text = {
            "Choose #1# of up to",
            "#2# joker cards"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}
SMODS.Booster {
    key = "ultra_arcana",
    weight = 0.025,
    kind = 'Arcana',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_arcana_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Arcana Pack",
        text = {
            "Choose #1# of up to",
            "#2# Tarot cards to",
            "be used immediately"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Tarot", area = G.pack_cards, skip_materialize = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}
SMODS.Booster {
    key = "ultra_celestial",
    weight = 0.025,
    kind = 'Celestial',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_celestial_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Celestial Pack",
        text = {
            "Choose #1# of up to",
            "#2# Planet cards to",
            "be used immediately"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Planet", area = G.pack_cards, skip_materialize = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}
SMODS.Booster {
    key = "ultra_standard",
    weight = 0.025,
    kind = 'Standard',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_standard_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Standard Pack",
        text = {
            "Choose #1# of up to",
            "#2# Playing cards to",
            "add to your deck"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        local ultra_card_edition, ultra_card_seal = nil, nil
        if pseudorandom("ultra_edition_grab", 1, 50) == 25 then
            ultra_card_edition = poll_edition(pseudoseed("ultra_poll_edition_random_seed"), 1, true, false)
        end
        if pseudorandom("ultra_seal_grab", 1, 10) == 5 then
            ultra_card_seal = SMODS.poll_seal({type_key = "ultra_poll_seaL_random_seed",  guaranteed = true})
        end
        return {set = "Playing Card", area = G.pack_cards, skip_materialize = true, edition = ultra_card_edition, seal = ultra_card_seal}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}

SMODS.Booster {
    key = "ultra_spectral",
    weight = 0.025,
    kind = 'Spectral',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_spectral_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Spectral Pack",
        text = {
            "Choose #1# of up to",
            "#2# Spectral cards to",
            "be used immediately"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Spectral", area = G.pack_cards, skip_materialize = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}

SMODS.Booster {
    key = "ultra_buffoon",
    weight = 0.025,
    kind = 'Buffoon',
    cost = 0,
    credits = 100,
    pos = { x = 0, y = 0 },
    config = { extra = 7, choose = 3 },
    group_key = "k_buffoon_pack",
    draw_hand = true,
    loc_txt = { -- Localization files scary
        name = "Ultra Buffoon Pack",
        text = {
            "Choose #1# of up to",
            "#2# joker cards"
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.choose,
                card.ability.extra,
            },
        }
    end,
    create_card = function(self, card)
        return {set = "Joker", area = G.pack_cards, skip_materialize = true, soulable = true}
    end,
    hotpot_credits = {
        art = {"N/A"},
        idea = {"Revo"},
        code = {"Violet"}, -- <- this is the one to blame for the awful code
        team = {"Team Name"}
    }
}
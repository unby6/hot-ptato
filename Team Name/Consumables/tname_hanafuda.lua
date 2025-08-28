SMODS.ConsumableType({
	key = "hanafuda",
	collection_rows = { 4, 4, 4 },
	primary_colour = G.C.RED,
	secondary_colour = G.C.RED,
	shop_rate = nil,
})

function highlight_jokers_hand(val, jokers_only, hand_only)
	local joker_check, hand_check, check = nil, nil, nil

	local ret = false

	if G.jokers and G.jokers.highlighted and (#G.jokers.highlighted <= val and #G.jokers.highlighted > 0) then
		joker_check = true
		check = true
	end

	if G.hand and G.hand.highlighted and (#G.hand.highlighted <= val and #G.hand.highlighted > 0) then
		hand_check = true
		check = true
	end

	if jokers_only then
		if joker_check then
			ret = true
		end
	elseif hand_only then
		if hand_check then
			ret = true
		end
	elseif check then
		ret = true
	end

	return ret
end

-- PINE
SMODS.Consumable({
	key = "pine_1",
	atlas = "tname_hanafuda",
	pos = { x = 0, y = 0 },
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		info_queue[#info_queue + 1] =
			{ key = "hpot_fragile", set = "Other", vars = { SMODS.Stickers["hpot_fragile"].config.xmult } }
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_fragile"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_fragile"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "pine_2",
	atlas = "tname_hanafuda",
	pos = { x = 0, y = 1 },
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] =
			{ key = "hpot_fragile", set = "Other", vars = { SMODS.Stickers["hpot_fragile"].config.xmult } }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_fragile"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_fragile"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "pine_3",
	atlas = "tname_hanafuda",
	pos = { x = 0, y = 2 },
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] =
			{ key = "hpot_uranium", set = "Other", vars = { (G.GAME.probabilities.normal or 1) } }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_uranium"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_uranium"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "pine_4",
	atlas = "tname_hanafuda",
	pos = { x = 0, y = 3 },
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] =
			{ key = "hpot_uranium", set = "Other", vars = { (G.GAME.probabilities.normal or 1) } }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_uranium"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_uranium"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

-- WILLOW

SMODS.Consumable({
	key = "willow_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_redirect", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_redirect"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_redirect"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "willow_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_redirect", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_redirect"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_redirect"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "willow_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_cannibal", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_cannibal"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_cannibal"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "willow_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_cannibal", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_cannibal"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_cannibal"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

-- SAKURA

SMODS.Consumable({
	key = "sakura_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] =
			{ key = "hpot_sporess", set = "Other", vars = { (G.GAME.probabilities.normal or 1) } }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_spores"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_spores"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "sakura_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] =
			{ key = "hpot_spores", set = "Other", vars = { (G.GAME.probabilities.normal or 1) } }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_spores"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_spores"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "sakura_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_cfour", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_cfour"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_cfour"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "sakura_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_cfour", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_cfour"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_cfour"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

-- PAULOWNIA

SMODS.Consumable({
	key = "paulownia_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = {
			key = "hpot_overclock",
			set = "Other",
			vars = { G.GAME.overclock_timer, (card.ability.over_tally or G.GAME.overclock_timer) },
		}
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_overclock"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_overclock"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "paulownia_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = {
			key = "hpot_overclock",
			set = "Other",
			vars = { G.GAME.overclock_timer, (card.ability.over_tally or G.GAME.overclock_timer) },
		}
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_overclock"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_overclock"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "paulownia_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_rage", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_rage"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_rage"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "paulownia_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_rage", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_rage"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_rage"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

-- PEONY

SMODS.Consumable({
	key = "peony_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_spinning", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_spinning"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_spinning"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "peony_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_spinning", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_spinning"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_spinning"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "peony_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_binary", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_binary"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_binary"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "peony_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		info_queue[#info_queue + 1] = { key = "hpot_binary", set = "Other", vars = {} }
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				SMODS.Stickers["hpot_binary"]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				SMODS.Stickers["hpot_binary"]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

-- MAPLE

SMODS.Consumable({
	key = "maple_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		if G.jokers and #G.jokers.cards > 0 then
			return true
		end
		return false
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		ease_dollars(hpt.high * #G.jokers.cards)
	end,
})

SMODS.Consumable({
	key = "maple_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		if G.jokers and #G.jokers.cards > 0 then
			return true
		end
		return false
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		ease_dollars(hpt.high * #G.jokers.cards)
	end,
})

SMODS.Consumable({
	key = "maple_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		if G.jokers and #G.jokers.cards > 0 then
			return true
		end
		return false
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		ease_dollars(hpt.high * #G.jokers.cards)
	end,
})

SMODS.Consumable({
	key = "maple_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		if G.jokers and #G.jokers.cards > 0 then
			return true
		end
		return false
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		ease_dollars(hpt.high * #G.jokers.cards)
	end,
})

-- Chrysanthemum

SMODS.Consumable({
	key = "chrysanthemum_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.jokers.highlighted do
			poll_modification(1, G.jokers.highlighted[i], nil, { BAD = 0 })
			reforge_card(random_joker, true)
		end
	end,
})

SMODS.Consumable({
	key = "chrysanthemum_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.jokers.highlighted do
			poll_modification(1, G.jokers.highlighted[i], nil, { BAD = 0 })
			reforge_card(random_joker, true)
		end
	end,
})

SMODS.Consumable({
	key = "chrysanthemum_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.jokers.highlighted do
			poll_modification(1, G.jokers.highlighted[i], nil, { BAD = 0 })
			reforge_card(random_joker, true)
		end
	end,
})

SMODS.Consumable({
	key = "chrysanthemum_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		for i = 1, #G.jokers.highlighted do
			poll_modification(1, G.jokers.highlighted[i], nil, { BAD = 0 })
			reforge_card(random_joker, true)
		end
	end,
})

-- SUSUKI

SMODS.Consumable({
	key = "susuki_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				local key = poll_sticker(true, G.jokers.highlighted[i])
				SMODS.Stickers[key]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				local key = poll_sticker(true, G.hand.highlighted[i])
				SMODS.Stickers[key]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "susuki_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				local key = poll_sticker(true, G.jokers.highlighted[i])
				SMODS.Stickers[key]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				local key = poll_sticker(true, G.hand.highlighted[i])
				SMODS.Stickers[key]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "susuki_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				local key = poll_sticker(true, G.jokers.highlighted[i])
				SMODS.Stickers[key]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				local key = poll_sticker(true, G.hand.highlighted[i])
				SMODS.Stickers[key]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

SMODS.Consumable({
	key = "susuki_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high)
	end,
	use = function(self, card, area, copier)
		if #G.jokers.highlighted > 0 then
			for i = 1, #G.jokers.highlighted do
				local key = poll_sticker(true, G.jokers.highlighted[i])
				SMODS.Stickers[key]:apply(G.jokers.highlighted[i], true)
			end
		else
			for i = 1, #G.hand.highlighted do
				local key = poll_sticker(true, G.hand.highlighted[i])
				SMODS.Stickers[key]:apply(G.hand.highlighted[i], true)
			end
		end
	end,
})

-- IRIS

SMODS.Consumable({
	key = "iris_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return false
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			card.ability.extra_value = (card.ability.extra_value or 0) + 1
			card:set_cost()
		end
	end,
})

SMODS.Consumable({
	key = "iris_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return false
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			card.ability.extra_value = (card.ability.extra_value or 0) + 1
			card:set_cost()
		end
	end,
})

SMODS.Consumable({
	key = "iris_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return false
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			card.ability.extra_value = (card.ability.extra_value or 0) + 1
			card:set_cost()
		end
	end,
})

SMODS.Consumable({
	key = "iris_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return false
	end,
	calculate = function(self, card, context)
		if context.end_of_round and context.main_eval then
			card.ability.extra_value = (card.ability.extra_value or 0) + 1
			card:set_cost()
		end
	end,
})

-- WISTERIA

SMODS.Consumable({
	key = "wisteria_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		local modif, modif2
		local remove = {}
		for i = 1, #G.jokres.highlighted do
			modif = get_modification(G.jokers.highlighted[i])
			if modif.morality == "BAD" then
				remove[#remove + 1] = G.jokers.highlighted[i]
			end
		end

		if #remove > 0 then
			for i = 1, #remove do
				modif2 = get_modification(remove[i]).key
				HPTN.Modifications[modif2]:apply(remove[i], false)
			end
		end
	end,
})

SMODS.Consumable({
	key = "wisteria_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		local modif, modif2
		local remove = {}
		for i = 1, #G.jokres.highlighted do
			modif = get_modification(G.jokers.highlighted[i])
			if modif.morality == "BAD" then
				remove[#remove + 1] = G.jokers.highlighted[i]
			end
		end

		if #remove > 0 then
			for i = 1, #remove do
				modif2 = get_modification(remove[i]).key
				HPTN.Modifications[modif2]:apply(remove[i], false)
			end
		end
	end,
})

SMODS.Consumable({
	key = "wisteria_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		local modif, modif2
		local remove = {}
		for i = 1, #G.jokres.highlighted do
			modif = get_modification(G.jokers.highlighted[i])
			if modif.morality == "BAD" then
				remove[#remove + 1] = G.jokers.highlighted[i]
			end
		end

		if #remove > 0 then
			for i = 1, #remove do
				modif2 = get_modification(remove[i]).key
				HPTN.Modifications[modif2]:apply(remove[i], false)
			end
		end
	end,
})

SMODS.Consumable({
	key = "wisteria_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return highlight_jokers_hand(hpt.high, true)
	end,
	use = function(self, card, area, copier)
		local modif, modif2
		local remove = {}
		for i = 1, #G.jokres.highlighted do
			modif = get_modification(G.jokers.highlighted[i])
			if modif.morality == "BAD" then
				remove[#remove + 1] = G.jokers.highlighted[i]
			end
		end

		if #remove > 0 then
			for i = 1, #remove do
				modif2 = get_modification(remove[i]).key
				HPTN.Modifications[modif2]:apply(remove[i], false)
			end
		end
	end,
})

-- BUSH CLOVER

SMODS.Consumable({
	key = "bush_clover_1",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 1,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		for i = 1, hpt.high do
			SMODS.add_card({
				set = "hanafuda",
				area = G.consumeables,
				edition = "e_negative",
			})
		end
	end,
})
SMODS.Consumable({
	key = "bush_clover_2",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 2,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		for i = 1, hpt.high do
			SMODS.add_card({
				set = "hanafuda",
				area = G.consumeables,
				edition = "e_negative",
			})
		end
	end,
})
SMODS.Consumable({
	key = "bush_clover_3",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 3,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		for i = 1, hpt.high do
			SMODS.add_card({
				set = "hanafuda",
				area = G.consumeables,
				edition = "e_negative",
			})
		end
	end,
})
SMODS.Consumable({
	key = "bush_clover_4",
	set = "hanafuda",
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},

	config = {
		extra = {
			high = 4,
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.high },
		}
	end,
	can_use = function(self, card)
		local hpt = card.ability.extra
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		for i = 1, hpt.high do
			SMODS.add_card({
				set = "hanafuda",
				area = G.consumeables,
				edition = "e_negative",
			})
		end
	end,
})

SMODS.ConsumableType({
	key = "Aura",
	collection_rows = { 4, 4 },
	primary_colour = G.C.GREY,
	secondary_colour = G.C.GREY,
	shop_rate = nil,
})

SMODS.Atlas { key = "tname_auras", path = "Team Name/tname_auras.png", px = 71, py = 95 }

SMODS.Consumable({
	key = "justice",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 0,
		y = 0
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			slots = 2,
			credits = 60
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.slots, hpt.credits },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.jokers then
					G.jokers.config.card_limit = G.jokers.config.card_limit - hpt.slots
				end
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				HPTN.ease_credits(60, false)
				return true
			end,
		}))
	end,
})

SMODS.Consumable({
	key = "fear",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 1,
		y = 0
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			credits = 10
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.credits },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		local badstickers = {
			"eternal",
			"perishable",
			"rental",
			"hpot_cfour",
			"hpot_spinning",
			"hpot_uranium",
			"hpot_nuke",
			"hpot_spore",
			"hpot_rage"
		}
		local function g(joker)
			local appliedsticker = badstickers[pseudorandom("fuck", 1, #badstickers)]
			if joker.ability[appliedsticker] then
				g(joker)
			else
				return appliedsticker
			end
		end
		for k, v in ipairs(G.jokers.cards) do
			G.E_MANAGER:add_event(Event({
				trigger = 'after',
				delay = 0.2,
				func = function()
					SMODS.Stickers[g(v)]:apply(v, true)
					HPTN.ease_credits(hpt.credits)
					return true
				end
			}))
		end
	end,
})

SMODS.Consumable({
	key = "perception",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 2,
		y = 0
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			leavinghands = 1,
			credits = 20
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.leavinghands, hpt.credits },
		}
	end,
	can_use = function(self, card)
		if G.GAME.round_resets.hands <= card.ability.extra.leavinghands then
			return false
		else
			return true
		end
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		local fuck = G.GAME.round_resets.hands
		G.E_MANAGER:add_event(Event({
			func = function()
				G.GAME.round_resets.hands = hpt.leavinghands
				ease_hands_played(-(fuck - hpt.leavinghands))
				return true
			end,
		}))
		G.E_MANAGER:add_event(Event({
			func = function()
				HPTN.ease_credits((fuck - hpt.leavinghands) * hpt.credits, false)
				return true
			end,
		}))
	end,
})

SMODS.Consumable({
	key = "greatness",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 3,
		y = 0
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			credits = 1.5
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.credits },
		}
	end,
	can_use = function(self, card)
		return G.GAME.dollars ~= 0
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		local g = G.GAME.dollars
		ease_dollars(-G.GAME.dollars, true)
		HPTN.ease_credits(math.floor(hpt.credits * g), false)
	end,
})

SMODS.Consumable({
	key = "clairvoyance",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 0,
		y = 1
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			slots = 2,
			credits = 30
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.slots, hpt.credits },
		}
	end,
	can_use = function(self, card)
		return G.consumeables.config.card_limit - card.ability.extra.slots >= 0
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		G.E_MANAGER:add_event(Event({
			func = function()
				if G.consumeables then
					G.consumeables.config.card_limit = G.consumeables.config.card_limit - card.ability.extra.slots
				end
				HPTN.ease_credits(hpt.slots * hpt.credits)
				return true
			end,
		}))
	end,
})

SMODS.Consumable({
	key = "tenacity",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 1,
		y = 1
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			max = 45,
			credits = 1.1
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.max, hpt.credits },
		}
	end,
	can_use = function(self, card)
		return #G.jokers.cards > 0
	end,
	use = function(self, card, area, copier)
		for _, joker in pairs(G.jokers.cards) do
			joker:start_dissolve(nil, true)
		end
		local hpt = card.ability.extra
		local retval = math.min(hpt.max, (hpt.credits - 1) * G.PROFILES[G.SETTINGS.profile].TNameCredits)
		HPTN.ease_credits(retval, false)
	end,
})

SMODS.Consumable({
	key = "lunacy",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 2,
		y = 1
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	config = {
		extra = {
			credits = 1
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = { hpt.credits },
		}
	end,
	can_use = function(self, card)
		return true
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		HPTN.ease_credits(hpt.credits, false)
	end,
})
SMODS.Consumable({
	key = "power",
	set = "Aura",
	atlas = "tname_auras",
	pos = {
		x = 3,
		y = 1
	},
	config = {
		extra = {
			credits = 50
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
		return {
			vars = {
				hpt.credits,
				math.max(0, math.floor(G.PROFILES[G.SETTINGS.profile].TNameCredits / hpt.credits)),
				((math.floor(G.PROFILES[G.SETTINGS.profile].TNameCredits / hpt.credits) < 0) and "") or "+" }
		}
	end,
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "GoldenLeaf" },
		team = { "Team Name" },
	},
	can_use = function(self, card)
		return ((#G.jokers.cards > 0) and (G.PROFILES[G.SETTINGS.profile].TNameCredits > 0))
	end,
	use = function(self, card, area, copier)
		local hpt = card.ability.extra
		local a = math.floor(G.PROFILES[G.SETTINGS.profile].TNameCredits / hpt.credits)
		HPTN.ease_credits(-G.PROFILES[G.SETTINGS.profile].TNameCredits, false)
		local target_card_key = G.jokers.cards[1].config.center.key
		if target_card_key ~= nil then
			for i = 1, a do
				SMODS.add_card {
					key = target_card_key,
					edition = "e_negative"
				}
			end
		end
	end,
})

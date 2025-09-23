SMODS.Tag({
	key = "credits_tag",
	config = { add = 15 },
	atlas = "tname_tags",
	pos = { x = 3, y = 0 },
	loc_vars = function(self, info_queue, tag)
		return { vars = { tag.config.add } }
	end,
	apply = function(self, tag, context)
		if context.type == "immediate" then
			tag:yep("+", G.C.PURPLE, function()
				HPTN.ease_credits(tag.config.add)
				return true
			end)
			tag.triggered = true
		end
	end,
	hotpot_credits = {
		art = { "Revo" },
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Tag({
	key = "mega_hanafuda",
	atlas = "tname_tags",
	pos = { x = 1, y = 0 },
	loc_vars = function(self, info_queue, tag)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_hpot_hanafuda_mega_1
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
				local key = "p_hpot_hanafuda_mega_1"
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				G.CONTROLLER.locks[1] = nil
				return true
			end)
			self.triggered = true
			return true
		end
	end,
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Jogla" },
		team = { "Team Name" },
	},
})

SMODS.Tag({
	key = "mega_auras",
	atlas = "tname_tags",
	pos = { x = 0, y = 0 },
	loc_vars = function(self, info_queue, tag)
		info_queue[#info_queue + 1] = G.P_CENTERS.p_hpot_auras_mega_1
	end,
	apply = function(self, tag, context)
		if context.type == "new_blind_choice" then
			tag:yep("+", G.C.SECONDARY_SET.Spectral, function()
				local key = "p_hpot_auras_mega_1"
				local card = Card(
					G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
					G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
					G.CARD_W * 1.27,
					G.CARD_H * 1.27,
					G.P_CARDS.empty,
					G.P_CENTERS[key],
					{ bypass_discovery_center = true, bypass_discovery_ui = true }
				)
				card.cost = 0
				card.from_tag = true
				G.FUNCS.use_card({ config = { ref_table = card } })
				card:start_materialize()
				G.CONTROLLER.locks[1] = nil
				return true
			end)
			self.triggered = true
			return true
		end
	end,
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Jogla" },
		team = { "Team Name" },
	},
})

SMODS.Tag({
	key = "credit_econ",
	atlas = "tname_tags",
	pos = { x = 2, y = 0 },
	config = { max = 25 },
	loc_vars = function(self, info_queue, tag)
		return { vars = { tag.config.max } }
	end,
	apply = function(self, tag, context)
		if context.type == "immediate" then
			tag:yep("+", G.C.PURPLE, function()
				G.E_MANAGER:add_event(Event({
					trigger = 'immediate',
					func = function()
						HPTN.ease_credits(math.min(tag.config.max, math.max(0, G.GAME.credits_text)), true)
						return true
					end
				}))
				return true
			end)
			tag.triggered = true
		end
	end,
	hotpot_credits = {
		art = { "GoldeLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})


SMODS.Tag {
	key = "psychedelic_tag",
	min_ante = 2,
	atlas = "tname_tags",
	pos = { x = 4, y = 0 },
	loc_vars = function(self, info_queue, tag)
		info_queue[#info_queue + 1] = G.P_CENTERS.e_hpot_psychedelic
	end,
	apply = function(self, tag, context)
		if context.type == 'store_joker_modify' then
			if not context.card.edition and not context.card.temp_edition and context.card.ability.set == 'Joker' then
				local lock = tag.ID
				G.CONTROLLER.locks[lock] = true
				context.card.temp_edition = true
				tag:yep('+', G.C.DARK_EDITION, function()
					context.card.temp_edition = nil
					context.card:set_edition("e_hpot_psychedelic", true)
					context.card.ability.couponed = true
					context.card:set_cost()
					G.CONTROLLER.locks[lock] = nil
					return true
				end)
				tag.triggered = true
				return true
			end
		end
	end,
	hotpot_credits = {
		art = { "GoldeLeaf" },
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
}

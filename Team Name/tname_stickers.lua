SMODS.Atlas({
	key = "tname_stickers",
	path = "Team Name/tname_stickers.png",
	px = 71,
	py = 95,
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "overclock",
	badge_colour = HEX("fdaf57"),
	loc_vars = function(self, info_queue, card)
		return {
			vars = { G.GAME.overclock_timer, (card.ability.over_tally or G.GAME.overclock_timer) },
		}
	end,
	apply = function(self, card, val)
		card.ability.hpot_overclock = val
		card.ability.over_tally = G.GAME.overclock_timer
	end,
	calculate = function(self, card, context)
		if
			context.other_card == card
			and not card.debuff
			and (context.repetition or (context.retrigger_joker_check and not context.retrigger_joker))
		then
			return {
				repetitions = 1,
			}
		end

		if context.end_of_round and context.main_eval then
			if card.ability.over_tally == nil then
				card.ability.over_tally = G.GAME.overclock_timer - 1
			end
			if card.ability.over_tally > 1 then
				card.ability.over_tally = card.ability.over_tally - 1
				card_eval_status_text(card, "extra", nil, nil, nil, {
					message = localize({
						type = "variable",
						key = "a_remaining",
						vars = {
							card.ability.over_tally,
						},
					}),
					colour = G.C.FILTER,
					delay = 0.45,
				})
			else
				card_eval_status_text(card, "extra", nil, nil, nil, { message = localize("k_debuffed") })
				SMODS.debuff_card(card, true, card.config.center.key) -- source
			end
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 1,
		y = 1,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "Corobo" },
		code = { "Revo"},
		team = { "Team Name" }
	}

})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "redirect",
	badge_colour = HEX("b7a2fd"),
	calculate = function(self, card, context)
		if context.hpot_destroy and context.hpot_destroyed == card then
			local tab = {}

			local area

			if context.hpot_destroyed and context.hpot_destroyed.area then
				area = context.hpot_destroyed.area
			end

			for i = 1, #area.cards do
				if area.cards[i] ~= card and not SMODS.is_eternal(area.cards[i]) then
					tab[#tab + 1] = area.cards[i]
				end
			end

			if #tab > 0 then
				local random_joker = pseudorandom_element(tab)
				SMODS.destroy_cards(random_joker)

				local acard = copy_card(card)
				acard:add_to_deck()
				area:emplace(acard)
				SMODS.calculate_effect({ message = localize("hpot_redirect_ex") }, acard)
			end
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 0,
		y = 0,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "fragile",
	badge_colour = HEX("b7d5d8"),
	config = {
		xmult = 2,
	},
	loc_vars = function(self, info_queue, center)
		return {
			vars = { self.config.xmult },
		}
	end,
	calculate = function(self, card, context)
		if context.joker_main or (context.main_scroing and context.cardarea == G.play) then
			return {
				xmult = self.config.xmult,
			}
		end
		if context.hpot_destroy and context.hpot_destroyed and not context.hpot_destroyed.hpot_cons_used then
			SMODS.destroy_cards(card)
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 2,
		y = 0,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "rage",
	badge_colour = HEX("fd5f55"),
	calculate = function(self, card, context)
		if
			context.other_card == card
			and not card.debuff
			and (context.repetition or (context.retrigger_joker_check and not context.retrigger_joker))
		then
			local area = card.area
			local rr = nil
			for i = 1, #area.cards do
				if area.cards[i] == card then
					rr = i
				end
			end

			if area.cards[rr - 1] then
				SMODS.destroy_cards(area.cards[rr - 1])
			end

			if area.cards[rr + 1] then
				SMODS.destroy_cards(area.cards[rr + 1])
			end

			return {
				repetitions = 1,
			}
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 1,
		y = 0,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "spores",
	badge_colour = HEX("4bc292"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = { (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			or (context.main_scoring and context.cardarea == G.hand)
				and pseudorandom("hpot_spores") < G.GAME.probabilities.normal / 2
		then
			local r = nil
			local l = nil

			local area = card.area
			local rr = nil
			for i = 1, #area.cards do
				if area.cards[i] == card then
					rr = i
				end
			end

			if area.cards[rr - 1] then
				if area.cards[rr - 1].ability.hpot_spores == true then
					l = true
				else
					if not card.just_spored then
						area.cards[rr - 1].ability.hpot_spores = true
						area.cards[rr - 1]:juice_up()
						area.cards[rr - 1].just_spored = true
						SMODS.calculate_effect({ message = localize("hpot_infected_ex") }, area.cards[rr - 1])
					end
				end
			end

			if area.cards[rr + 1] then
				if area.cards[rr + 1].ability.hpot_spores == true then
					r = true
				else
					if not card.just_spored then
						area.cards[rr + 1].ability.hpot_spores = true
						area.cards[rr + 1]:juice_up()
						area.cards[rr + 1].just_spored = true
						SMODS.calculate_effect({ message = localize("hpot_infected_ex") }, area.cards[rr + 1])
					end
				end
			end

			if l and r then
				SMODS.destroy_cards(card)
			end
		end

		if context.before and card.just_spored then
			card.just_spored = nil
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 0,
		y = 1,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "Corobo" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "nuke",
	badge_colour = HEX("a2615e"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = { (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind and pseudorandom("tname_nuke") < G.GAME.probabilities.normal / 6 then
			local destroy_tab = {}

			local area = card.area
			local rr = nil
			for i = 1, #area.cards do
				if area.cards[i] == card then
					rr = i
				end
			end

			destroy_tab[#destroy_tab + 1] = card

			if area.cards[rr + 1] then
				destroy_tab[#destroy_tab + 1] = area.cards[rr + 1]
			end
			if area.cards[rr - 1] then
				destroy_tab[#destroy_tab + 1] = area.cards[rr - 1]
			end

			SMODS.destroy_cards(destroy_tab)
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 2,
		y = 1,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "Revo" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "cannibal",
	badge_colour = HEX("009cfd"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			local stickers = {}
			for k, v in pairs(SMODS.Stickers) do
				if (card.ability[k] or card[k]) and k ~= "hpot_cannibal" then
					stickers[#stickers + 1] = k
				end
			end

		if #stickers > 0 then
			local remove = pseudorandom_element(stickers)

			card:juice_up()
			SMODS.Stickers[remove]:apply(card, false)
			card_eval_status_text(
				card,
				"extra",
				nil,
				nil,
				nil,
				{ message = ("-" .. localize({ type = "name_text", key = remove, set = "Other" })) }
			)
		end
	end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 3,
		y = 1,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "binary",
	badge_colour = HEX("85a6ac"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.setting_blind then
			local stickers, remove_stickers = {}, {}
			for k, v in pairs(SMODS.Stickers) do
				if k ~= "hpot_binary" then
					if not card.ability[k] and not card[k] then
						stickers[#stickers+1] = k
					else
						remove_stickers[#remove_stickers+1] = k
					end
				end
			end

			for i = 1, #remove_stickers do
				SMODS.Stickers[remove_stickers[i]]:apply(card, false)
			end

			for i = 1, #stickers do
				SMODS.Stickers[stickers[i]]:apply(card, true)
			end
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 3,
		y = 0,
	},
	hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "GoldenLeaf" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "mail",
	badge_colour = HEX("85a6ac"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = {},
		}
	end,
	calculate = function(self, card, context)
		if context.selling_card and context.card == card then
			local _set, _area

			if card and card.ability and card.ability.set then
				_set = card.ability.set
			end

			if card and card.area then
				_area = card.area
			end

			SMODS.add_card({
				set = _set,
				area = _area,
			})
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 1,
		y = 2,
	},
	hotpot_credits = {
		art = { "GhostSalt" },
		idea = { "Corobo" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "uranium",
	badge_colour = HEX("85a6ac"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = { (G.GAME.probabilities.normal or 1) },
		}
	end,
	calculate = function(self, card, context)
		if
			context.joker_main
			or (context.main_scoring and (context.cardarea == G.play or context.cardarea == G.hand))
				and pseudorandom("hpot_uranium") < G.GAME.probabilities.normal / 4
		then
			local r = nil
			local l = nil

			local area = card.area
			local rr = nil
			for i = 1, #area.cards do
				if area.cards[i] == card then
					rr = i
				end
			end

			if area.cards[rr - 1] and not area.cards[rr - 1].debuff then
				card_eval_status_text(area.cards[rr - 1], "extra", nil, nil, nil, { message = localize("k_debuffed") })
				SMODS.debuff_card(area.cards[rr - 1], true, card.config.center.key)
			end

			if area.cards[rr + 1] and not area.cards[rr + 1].debuff then
				card_eval_status_text(area.cards[rr + 1], "extra", nil, nil, nil, { message = localize("k_debuffed") })
				SMODS.debuff_card(area.cards[rr + 1], true, card.config.center.key)
			end

		end
	end,
		atlas = "tname_stickers",
	pos = {
		x = 2,
		y = 2,
	},
	hotpot_credits = {
		art = { "GhostSalt" },
		idea = { "Corobo" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})


SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "spinning",
	badge_colour = HEX("85a6ac"),
		atlas = "tname_stickers",
	pos = {
		x = 0,
		y = 1,
	},
	hotpot_credits = {
		art = { "GhostSalt" },
		idea = { "Corobo" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})

SMODS.Sticker({
	needs_enable_flag = false,
	rate = 0.05,
	key = "cfour",
	badge_colour = HEX("b7d5d8"),
	loc_vars = function(self, info_queue, center)
		return {
			vars = { },
		}
	end,
	calculate = function(self, card, context)
		if context.hpot_destroy and context.hpot_destroyed.ability.hpot_cfour and not context.hpot_destroyed.hpot_cons_used then
			SMODS.destroy_cards(card)
		end
	end,
	atlas = "tname_stickers",
	pos = {
		x = 3,
		y = 2,
	},
	hotpot_credits = {
		art = { "GhostSalt" },
		idea = { "Corobo" },
		code = { "Revo"},
		team = { "Team Name" }
	}
})
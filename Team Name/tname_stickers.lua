SMODS.Sticker({
	key = "overclock",
	badge_colour = HEX("ff8686"),
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
			SMODS.debuff_card(card, true, card.config.center.key) -- source
		end
	end,
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Sticker({
	key = "redirect",
	badge_colour = HEX("ff8686"),
	calculate = function(self, card, context)
		if context.hpot_destroy and context.hpot_destroyed == card then
			local tab = {}

			local area

			if context.hpot_destroyed and context.hpot_destroyed.area then
				area = context.hpot_destroyed.area
			end

			for i = 1, #area.cards do
				if area.cards[i] ~= card then
					tab[#tab + 1] = area.cards[i]
				end
			end

			if #tab > 0 then
				local random_joker = pseudorandom_element(tab)
				SMODS.destroy_cards(random_joker)

				local acard = copy_card(card)
				acard:add_to_deck()
				area:emplace(acard)
				SMODS.calculate_effect({ message = "Redirect!" }, acard)
			end
		end
	end,
	hotpot_credits = {
		art = { "No Art" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Sticker({
	key = "fragile",
	badge_colour = HEX("ff8686"),
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
		if context.hpot_destroy then
			SMODS.destroy_cards(card)
		end
	end,
	hotpot_credits = {
		art = { "No Art" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Sticker({
	key = "rage",
	badge_colour = HEX("ff8686"),
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
	hotpot_credits = {
		art = { "No Art" },
		idea = { "GoldenLeaf" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Sticker({
	key = "spores",
	badge_colour = HEX("ff8686"),
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
						SMODS.calculate_effect({ message = "Infected!" }, area.cards[rr - 1])
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
						SMODS.calculate_effect({ message = "Infected!" }, area.cards[rr + 1])
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
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

SMODS.Sticker({
	key = "nuke",
	badge_colour = HEX("ff8686"),
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
	hotpot_credits = {
		art = { "No Art" },
		idea = { "Revo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
})

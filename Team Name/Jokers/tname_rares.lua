local function getcurrentperson(num)
	local array = { "Corobo", "GhostSalt", "GoldenLeaf", "Jogla", "Revo", "Violet" }
	num = num or 1
	return array[num]
end
SMODS.Joker {
	key = "tname_postcard",
	atlas = "tname_jokers2",
	pos = { x = 0, y = 0 },
	rarity = 3,
	cost = 0,
	credits = 300,
	config = {
		extra = {
			functions = { -- values for your stuff, like card.ability.extra[whatever]
				Corobo = { a = 1, b = 0.1 },
				GhostSalt = { 1.5 },
				GoldenLeaf = { 20 },
				Jogla = { 2 },
				Revo = { rep = 2 },
				Violet = { 1 },
				person = 1
			}
		},
	},
	loc_vars = function(self, info_queue, card)
		local key, vars, ret
		key = (self.key .. "_" .. G.GAME.current_team_name_member)
		vars = {
			getcurrentperson((G.GAME.current_team_name_member or 1)),
			card.ability.extra.functions.GoldenLeaf[1],
			card.ability.extra.functions["Jogla"][1],
			card.ability.extra.functions.Corobo.a,
			card.ability.extra.functions.Corobo.b,
			card.ability.extra.functions.Revo.rep,
			card.ability.extra.functions.Violet[1],
			card.ability.extra.functions.GhostSalt[1]
		}
		return { key = key, vars = vars }
	end,

	blueprint_compat = true,
	calculate = function(self, card, context)
		local fuck = card.ability.extra.functions
		if context.starting_shop then
			card.children.center:set_sprite_pos { x = G.GAME.current_team_name_member - 1, y = 0 }
			return {
				message = localize("k_changedperson"),
				colour = G.C.ATTENTION,
				card = card
			}
		end
		local funcs = {
			Corobo = function(self, card, context)
				if context.individual and context.cardarea == G.play then
					SMODS.scale_card(card, {
						ref_table = card.ability.extra.functions.Corobo,
						ref_value = "a",
						scalar_value = "b",
					})
					return { xmult = fuck.Corobo.a }
				end
			end,
			GhostSalt = function(self, card, context)
				if context.other_consumeable then
					return { xmult = fuck.GhostSalt[1] }
				end
			end,
			GoldenLeaf = function(self, card, context)
				if context.joker_main then
					HPTN.ease_credits(fuck.GoldenLeaf[1], false)
					return { message = "Added!" }
				end
			end,
			Jogla = function(self, card, context)
				if context.ending_shop and G.consumeables.cards[1] then
					local target_card_key = G.consumeables.cards[1].config.center.key
					if target_card_key ~= nil then
						card_eval_status_text(card, "extra", nil, nil, nil,
							{ message = localize("k_duplicated_ex", "dictionary"), colour = G.C.ORANGE })
						for i = 1, fuck["Jogla"][1] do
							local new_card = SMODS.add_card {
								key = target_card_key,
								edition = "e_negative"
							}
						end
					end
				end
			end,
			Revo = function(self, card, context)
				if context.repetition and context.other_card:is_suit("Spades") then
					return {
						repetitions = 2
					}
				end
			end,
			Violet = function(self, card, context)
				if context.initial_scoring_step then
					local CArda, CArdb
					local cardLock = false
					for k, v in ipairs(G.play.cards) do
						if v:is_suit("Hearts") then
							if not cardLock then
								CArda = v
								cardLock = true
							end
						end
						if v:is_suit("Spades") then
							CArdb = v
						end
					end
					if CArda and CArda ~= nil then
						CArda:flip()
						local a = SMODS.change_base(CArda, "Spades")
						CArda:flip()
					end
					if CArdb and CArdb ~= nil then
						CArdb:flip()
						local a = SMODS.change_base(CArdb, "Hearts")
						CArdb:flip()
					end
				end
				if context.individual then
					if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Spades") then
						return {
							dollars = card.ability.extra.functions.Violet
						}
					end
				end
			end,
		}
		return funcs[getcurrentperson(G.GAME.current_team_name_member)](self, card, context)
	end,
	hotpot_credits = {
		art = { 'GhostSalt' },
		code = { "Goldenleaf" },
		idea = { 'Team Name (Collectively)' },
		team = { 'Team Name' }
	}
}

SMODS.Joker({
	key = "jankman",
	rarity = 3,
	config = {
		extra = {
			xmultg = 0.5,
			xmult = 1,
			stickers = 0
		},
	},
	pos = {x=9,y=0},
	atlas = "tname_jokers2",
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
			return {
				vars = { hpt.xmultg, hpt.xmult + hpt.xmultg * hpt.stickers},
			}
	end,
	calculate = function(self, card, context)
		local hpt = card.ability.extra
		hpt.stickers = 0
        for k, _ in pairs(SMODS.Stickers) do
            if card.ability[k] == true then
                hpt.stickers = hpt.stickers + 1
            end
        end
		if context.joker_main then
			return {
				xmult = hpt.xmult + hpt.xmultg * hpt.stickers
			}
		end
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})
-- this is really stupid
local function g(x)
	if x then
		return localize("teamname_active")
	else
		return localize("teamname_inactive")
	end
end
SMODS.Joker({
	key = "sunset",
	rarity = 3,
	config = {
		extra = {
			suit = 'Hearts',
			availability = true
		},
	},
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
			return {
				vars = { hpt.suit , g(hpt.availability)},
			}
	end,
	pos = {x=11,y=0},
	atlas = "tname_jokers2",
	calculate = function(self, card, context)
		local bool = false
		if context.scoring_hand then
		    for k, v in ipairs(context.full_hand) do
				if v:is_suit(card.ability.extra.suit) then
					bool = true
					break
				end
		    end
	    end
		if bool and card.ability.extra.availability and context.joker_main then
			SMODS.add_card{set = "Hanafuda"}
			card.ability.extra.availability = false
		end
		if context.end_of_round then
			card.ability.extra.availability = true
		end
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"Revo"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})

SMODS.Joker({
	key = "graveyard",
	rarity = 3,
	config = {
		extra = {
			xmultg = 0.5,
			xmult = 1,
			destroyed = 0
		},
	},
	pos = {x=1,y=1},
	atlas = "tname_jokers2",
	loc_vars = function(self, info_queue, card)
		local hpt = card.ability.extra
			return {
				vars = { hpt.xmultg, hpt.xmult + hpt.xmultg * hpt.destroyed},
			}
	end,
	calculate = function(self, card, context)
		local hpt = card.ability.extra
		if context.joker_type_destroyed then
			hpt.destroyed = hpt.destroyed + 1
			return{
					message = localize("k_upgrade_ex")
			}
		end
		if context.joker_main then
			return {
				xmult = hpt.xmult + hpt.xmultg * hpt.destroyed
			}
		end
	end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})
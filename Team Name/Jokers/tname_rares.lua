local function getcurrentperson(num)
	local array = {"Corobo", "GhostSalt", "GoldenLeaf", "Jogla", "Revo", "Violet"}
	num = num or 1
	return array[num]
end
local function uniquerandom(origival)
    local result = pseudorandom("fuck",1,6)
	if origival ~= result then
		return result
	else
		return uniquerandom(origival)
	end
end
SMODS.Joker {
    key = "tname_postcard",
    atlas = "tname_jokers2",
    pos = {x=0,y=0},
    rarity = 3,
    cost = 0,
	credits = 300,
    config = {
        extra = {
            functions = { -- values for your stuff, like card.ability.extra[whatever]
				Corobo = {a = 1, b = 0.1},
				GhostSalt = {0},
				GoldenLeaf = {20},
				Jogla = {2}, 
				Revo = {rep = 2}, 
				Violet = {1}, 
				person = 1
            }
        },
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                getcurrentperson((G.GAME.current_team_name_member or 1)),
                card.ability.extra.functions.GoldenLeaf[1],
				card.ability.extra.functions["Jogla"][1],
				card.ability.extra.functions.Corobo.a,
				card.ability.extra.functions.Corobo.b,
				card.ability.extra.functions.Revo.rep,
				card.ability.extra.functions.Violet[1]
            }
        }
    end,
    blueprint_compat = true,
    calculate = function(self, card, context)
		local fuck = card.ability.extra.functions
		local funcs = {
				Corobo = function(self,card,context)
					if context.individual and context.cardarea == G.play then
						SMODS.scale_card(card, {
							ref_table = card.ability.extra.functions.Corobo,
						    ref_value = "a",
							scalar_value = "b",
						})
					end
					if context.joker_main then
						return{xmult = fuck.Corobo.a}
					end
				end, 
				GhostSalt = function(self,card,context)end, 
				GoldenLeaf = function (self, card, context) 
					if context.joker_main then
						HPTN.ease_credits(fuck.GoldenLeaf[1], false)
						return{message = "Added!"}
					end
				end,
				Jogla = function(self,card,context)
					if context.ending_shop and G.consumeables.cards[1] then
						local target_card_key = G.consumeables.cards[1].config.center.key
						if target_card_key ~= nil then
							card_eval_status_text(card, "extra", nil, nil, nil,
							{ message = localize("k_duplicated_ex","dictionary"), colour = G.C.ORANGE })
							for i=1, fuck["Jogla"][1] do
								local new_card = SMODS.add_card{
									key = target_card_key,
									edition = "e_negative"
								}
							end
						end
					end
				end,
				Revo = function(self,card,context)
					if context.repetition and context.other_card:is_suit("Spades") then
						return{
							repetitions = 2
						}
					end
				end,
				Violet = function(self,card,context)
					if context.before then
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
							return {dollars = card.ability.extra.functions.Violet}
						end
					end
				end,
		}
		if context.end_of_round and context.cardarea == G.jokers then
			fuck.person = G.GAME.current_team_name_member
			card.children.center:set_sprite_pos{x = fuck.person-1, y = 0}
			return {
				message = localize("k_changedperson"),
				colour = G.C.ATTENTION
			}
		end
		return funcs[getcurrentperson(fuck.person)](self, card, context)
    end,
    hotpot_credits = {
        art = {'GhostSalt'},
        code = {"Goldenleaf"},
        idea = {'Team Name (Collectively)'},
        team = {'Team Name'}
    }
}

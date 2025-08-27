local function getcurrentperson(num)
	num = num or 1
	if num == 1 then
		return "Corobo"
	elseif num == 2 then
		return "GhostSalt"
	elseif num == 3 then
		return "GoldenLeaf"
	elseif num == 4 then
		return "Jogla"
	elseif num == 5 then
		return "Revo" 
	else
		return "Violet"
	end
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
            functions = { 
				Corobo = {0},
				GhostSalt = {0},
				GoldenLeaf = {20},
				Jogla = {0}, 
				Revo = {0}, 
				Violet = {0}, 
				person = 1
            }
        },
    },
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                getcurrentperson(card.ability.extra.functions.person),
                card.ability.extra.functions.GoldenLeaf[1]
            }
        }
    end,
    blueprint_compat = true,
    calculate = function(self, card, context)
		local fuck = card.ability.extra.functions
		local funcs = {
				Corobo = function(self,card,context)end, 
				GhostSalt = function(self,card,context)end, 
				GoldenLeaf = function (self, card, context) 
					if context.joker_main then
						HPTN.ease_credits(fuck.GoldenLeaf[1], false)
						return{message = "Added!"}
					end
				end,
				Jogla = function(self,card,context)end,
				Revo =function(self,card,context)end,
				Violet = function(self,card,context)end,
		}
		if context.end_of_round and context.cardarea == G.jokers then
			fuck.person = uniquerandom(fuck.person)
			card.children.center:set_sprite_pos{x = fuck.person-1, y = 0}
			return {
				message =localize("k_changedperson"),
				colour = G.C.ATTENTION
			}
		end
		return funcs[getcurrentperson(fuck.person)](self, card, context)
    end,
    hotpot_credits = {
        art = {'GhostSalt'},
        code = {'Aikoyori', "Goldenleaf"},
        idea = {'Team Name (Collectively)'},
        team = {'Team Name'}
    }
}

SMODS.Joker {
    key = "emoticon",
    config = {
        extra = {
            x_mult = 1.25
        }
    },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
    rarity = 2,
    cost = 6,
    hotpot_credits = {
        art = {"Nobody yet"},
        idea = {"PokéRen"},
        code = {"PokéRen"},
        team = {"Team :)"}
    },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face(false,{ignore_emoticon = true}) then
            if context.other_card.debuff then
                return {
                    message = localize('k_debuffed'),
                    colour = G.C.RED
                }
            else
                return {
                    x_mult = card.ability.extra.x_mult
                }
            end
        end
    end
}

local original_isface = Card.is_face
function Card:is_face(from_boss,options)
    if self.debuff and not from_boss then return end
    if next(find_joker("j_hpot_emoticon")) and not (options and options.ignore_emoticon) then
        -- Face cards will not be considered face cardss if you have Emoticon. if you want to ignore this, do is_face(false,{ignore_emoticon = true})
        return false
    end
    return original_isface(self,from_boss)
end
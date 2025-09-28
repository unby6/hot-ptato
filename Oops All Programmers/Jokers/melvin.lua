SMODS.Joker {
    key = 'melvin',
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            chips = 30,
        }
    },
    atlas = "oap_jokers",
    pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
    calculate = function(self, card, context)
        if context.before then
			card.ability.extra.active = true
		end
		if context.after then
			card.ability.extra.active = false
		end
        if card.ability.extra.active and context.post_trigger and context.other_card and context.other_card.config.center.key ~= "j_hpot_charlie" and not context.blueprint_card then
            if context.other_ret and context.other_ret.jokers and
                (context.other_ret.jokers.mult and context.other_ret.jokers.mult ~= 0)
                or (context.other_ret.jokers.mult_mod and context.other_ret.jokers.mult_mod ~= 0) then
                return {
                    func = function()
                        SMODS.calculate_effect {
                            card = card,
                            chips = card.ability.extra.chips
                        }
                        return true
                    end
                }
            end
        end
    end,
    hotpot_credits = {
        art = {'th30ne'},
        code = {'trif'},
        idea = {'th30ne'},
        team = {'Oops! All Programmers'}
    }
}
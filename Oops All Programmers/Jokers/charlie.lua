SMODS.Joker {
    key = 'charlie',
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            mult = 8
        }
    },
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.before then
			card.ability.extra.active = true
		end
		if context.after then
			card.ability.extra.active = false
		end
		if card.ability.extra.active and context.post_trigger then
            if context.other_ret and context.other_ret.chips and context.other_ret.chips ~= 0 then
                return {
                    mult = card.ability.extra.mult
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
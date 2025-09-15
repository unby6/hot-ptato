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
		if card.ability.extra.active then
            local mult_count = 0
			for _, v in ipairs(G.jokers.cards) do
				if v.ability.name ~= 'Blueprint' and v.ability.name ~= 'Brainstorm' and v.ability.name ~= "j_hpot_charlie" and v.ability.name ~= "j_hpot_melvin" then
					context.blueprint = nil
					local ret = SMODS.blueprint_effect(card, v, context)
					if ret and ret.mult then
                        mult_count = mult_count + 1
					end
				end
			end
            if mult_count > 0 then
                return {
                    chips = (mult_count * card.ability.extra.chips),
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
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
		if card.ability.extra.active then
            local chips_count = 0
			for _, v in ipairs(G.jokers.cards) do
				if v.ability.name ~= 'Blueprint' and v.ability.name ~= 'Brainstorm' and v.ability.name ~= "j_hpot_charlie" and v.ability.name ~= "j_hpot_melvin" then
					context.blueprint = nil
					local ret = SMODS.blueprint_effect(card, v, context)
					if ret and ret.chips then
                        chips_count = chips_count + 1
					end
				end
			end
            if chips_count > 0 then
                return {
                    mult = (chips_count * card.ability.extra.mult),
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
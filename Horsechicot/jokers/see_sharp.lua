SMODS.Joker {
    key = "c_sharp",
    rarity = 2,
    cost = 5,
    atlas = "hc_jokers",
    pos = { x = 7, y = 1 },
    config = { extra = { reset = 8, left = 8 } },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.before then
            card.ability.extra.left = card.ability.extra.left - 1
            if card.ability.extra.left < 1 then
                card.ability.extra.left = card.ability.extra.reset
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.blind:disable()
                                play_sound('timpani')
                                delay(0.4)
                                return true
                            end
                        }))
                        SMODS.calculate_effect({ message = localize('ph_boss_disabled') }, card)
                        return true
                    end
                }))

            end
        end
    end,
    hotpot_credits = Horsechicot.credit("Lily Felli", "lord.ruby", "lord.ruby"),
    loc_vars = function(self, info_queue, card)
        return {vars = {
            card.ability.extra.reset,
            card.ability.extra.left,
            "#"
        }}
    end
}
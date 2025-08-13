SMODS.Joker {
    key = "slop",
    --still needs sprite
    config = { extra = { xmult = 2 } },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    rarity = 1,
    cost = 4,
    blueprint_compat = true,
    eternal_compat = false,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = 2
            }
        end
        if context.close_ad and not context.blueprint then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound("tarot1")
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.3,
                        blockable = false,
                        func = function()
                            card:remove()
                            return true
                        end
                    }))
                    return true
                end
            }))
            return {
                message = localize("k_eaten_ex")
            }
        end
    end
}
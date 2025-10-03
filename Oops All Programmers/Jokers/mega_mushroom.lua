SMODS.Joker {
    key = 'mega_mushroom',
    rarity = 1,
    cost = 6,
    config = {
        extra = {
            hands_left = 3
        }
    },
    atlas = "oap_jokers",
    pos = { x = 5, y = 0 },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.hands_left,
            }
        }
    end,
    blueprint_compat = true,
    pools = { Food = true },
    calculate = function(self, card, context)
        if context.before
            and G.GAME.current_round.hands_left == 0
            and card.ability.extra.hands_left > 0 
        then
            if not context.blueprint then
                card.ability.extra.hands_left = card.ability.extra.hands_left - 1
            end
            return {
                level_up = 2
            }
        end
        if context.after
            and card.ability.extra.hands_left <= 0 then
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
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
                message = localize('k_eaten_ex'),
                colour = G.C.FILTER
            }
        end
    end,
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'th30ne' },
        idea = { 'th30ne' },
        team = { 'O!AP' }
    }
}

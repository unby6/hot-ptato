
SMODS.Joker {
    key = "golden_apple",
    config = { extra = { uses_left = 5, bonus_highlight = 1} },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.uses_left, card.ability.extra.bonus_highlight } }
    end,
    rarity = 2,
    cost = 5,
    pos = { x = 2, y = 0 },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'SillypostingJokers',
    calculate = function (self, card, context)
        if context.using_consumeable and context.consumeable.ability.max_highlighted and not context.blueprint then
            card.ability.extra.uses_left = card.ability.extra.uses_left - 1
            if card.ability.extra.uses_left <= 0 then
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
                    colour = G.C.GOLD
                }
            else
                return {
                    message = card.ability.extra.uses_left .. '',
                    colour = G.C.GOLD
                }
            end
        end
    end,
    add_to_deck = function (self, card, from_debuff)
        change_max_highlight(card.ability.extra.bonus_highlight)
    end,
    remove_from_deck = function (self, card, from_debuff)
        change_max_highlight(-card.ability.extra.bonus_highlight)
    end,
    hotpot_credits = {
        art = {"TODO"},
        code = {"UnusedParadox"},
        team = {"Sillyposting"}
    }
}
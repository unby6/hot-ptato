SMODS.Joker {
    key = "magic_factory",
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    atlas = "SillypostingJokers",
    pos = { x = 6, y = 0 },
    config = { extra = { bonus_highlight = -1 } },
    loc_vars = function (self, info_queue, card)
        return { vars = { math.abs(card.ability.extra.bonus_highlight) } }
    end,
    add_to_deck = function (self, card, from_debuff)
        change_max_highlight(card.ability.extra.bonus_highlight)
    end,
    remove_from_deck = function (self, card, from_debuff)
        change_max_highlight(-card.ability.extra.bonus_highlight)
    end,
    calculate = function(self, card, context) -- Everyone say thank you N for vanillaremade cartomancer
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer <= G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'hpot_magic_factory',
                                edition = "e_negative"
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    SMODS.calculate_effect({ message = localize('k_plus_tarot'), colour = G.C.PURPLE },
                        context.blueprint_card or card)
                    return true
                end)
            }))
            return nil, true -- This is for Joker retrigger purposes
        end
    end,
    hotpot_credits = {
        art = {"Jaydchw"},
        code = {"UnusedParadox"},
        team = {"Sillyposting"}
    }
}
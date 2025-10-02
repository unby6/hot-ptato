SMODS.Joker {
    key = "magic_factory",
    blueprint_compat = false,
    rarity = 2,
    cost = 6,
    discovered = true,
    atlas = "SillypostingJokers",
    pos = { x = 6, y = 0 },
    config = { extra = { bonus_highlight = -1, consumable_req = 2 } },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.consumable_req, math.abs(card.ability.extra.bonus_highlight) } }
    end,
    add_to_deck = function (self, card, from_debuff)
        change_max_highlight(card.ability.extra.bonus_highlight)
    end,
    remove_from_deck = function (self, card, from_debuff)
        change_max_highlight(-card.ability.extra.bonus_highlight)
    end,
    calculate = function(self, card, context) -- Everyone say thank you N for vanillaremade perkeo
        if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer <= G.consumeables.config.card_limit then
            local eligible_cards = {}
            for _, v in ipairs(G.consumeables.cards) do
                if not v.edition or v.edition.key ~= "e_negative" then
                    eligible_cards[#eligible_cards+1] = v
                end
            end
            if #eligible_cards >= card.ability.extra.consumable_req then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local card_to_copy, _ = pseudorandom_element(eligible_cards, 'hpot_magic_factory')
                        local copied_card = copy_card(card_to_copy)
                        copied_card:set_edition("e_negative", true)
                        copied_card:add_to_deck()
                        G.consumeables:emplace(copied_card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end)
                }))
                return {message = localize("k_duplicated_ex")}
            end
        end
    end,
    hotpot_credits = {
        art = {"Jaydchw"},
        code = {"UnusedParadox"},
        team = {"Sillyposting"}
    }
}
SMODS.Joker {
    key = "prosopagnosia",
    rarity = 3,
    cost = 7,
    atlas = "hc_jokers",
    pos = { x = 1, y = 1 },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    Horsechicot.credit("cg223", "pangaea47", "lord.ruby"),
    loc_vars = function(self, info_queue, card)
        for key, _ in pairs(G.GAME.removed_joker_keys or {}) do
            if G.P_CENTERS[key] and not G.P_CENTERS[key].no_prosopagnosia then
                info_queue[#info_queue + 1] = G.P_CENTERS[key]
            end
        end
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play and context.other_card:is_face() then
            return {
                func = function() calc_random_joker(card, context) return true end
            }
        end
    end
}


local old_sell_card = Card.sell_card
function Card:sell_card()
    if self.config.center.set == "Joker" then
        local key = self.config.center.key
        G.GAME.removed_joker_keys = G.GAME.removed_joker_keys or {}
        G.GAME.removed_joker_keys[key] = true
    end
    old_sell_card(self)
end

function calc_random_joker(card, other_context)
    local jkrs = {}
    for i, _ in pairs(G.GAME.removed_joker_keys or {}) do
        if not G.P_CENTERS[i].no_prosopagnosia then
            jkrs[#jkrs + 1] = G.P_CENTERS[i]
        end
    end
    local jkr = pseudorandom_element(jkrs, pseudoseed("hc_prosopagnosia"))
    if jkr then
        SMODS.calculate_effect({ message = localize { type = 'name_text', set = 'Joker', key = jkr.key } }, card)
        local temp_card = SMODS.create_card { key = jkr.key }
        temp_card:set_ability(jkr)
        temp_card:add_to_deck()
        temp_card:update(G.real_dt * G.SPEEDFACTOR)
        local effect = temp_card:calculate_joker({
            cardarea = G.jokers,
            full_hand = G.play.cards,
            scoring_hand =
                other_context.scoring_hand,
            scoring_name = other_context.scoring_name,
            poker_hands = other_context.poker_hands,
            joker_main = true
        })
        if effect then
            SMODS.calculate_effect(effect, card)
        end
        temp_card:remove_from_deck()
        temp_card:remove()
    end
end

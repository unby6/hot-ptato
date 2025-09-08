SMODS.Joker {
    key = "prosopagnosia",
    rarity = 3,
    atlas = "hc_jokers",
    pos = {x = 1, y = 1},
    Horsechicot.credit("cg223", "pangaea47", "lord.ruby")
}

local old_ec = eval_card
function eval_card(card, context)
    if SMODS.find_card("j_hpot_prosopagnosia")[1] and card.playing_card and card:is_face() and card.area == G.play and context.main_scoring then
        for _, _ in pairs(SMODS.find_card("j_hpot_prosopagnosia")) do
            local reps = { 1 }

            --From Red seal
            local eval = eval_card(card,
                { repetition_only = true, cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name =
                context.text, poker_hands = context.poker_hands, repetition = true })
            if next(eval) then
                for h = 1, eval.seals.repetitions do
                    reps[#reps + 1] = eval
                end
            end
            --From jokers
            for j = 1, #G.jokers.cards do
                --calculate the joker effects
                local eval = eval_card(G.jokers.cards[j],
                    { cardarea = G.play, full_hand = G.play.cards, scoring_hand = context.scoring_hand, scoring_name = context.text, poker_hands =
                    context.poker_hands, other_card = card, repetition = true })
                if next(eval) and eval.jokers then
                    for h = 1, eval.jokers.repetitions do
                        reps[#reps + 1] = eval
                    end
                end
            end
            calc_random_joker(card, context)
            for i = 2, #reps do
                if reps[i].jokers then
                    SMODS.calculate_effect(reps[i].jokers, reps[i].jokers.card)
                else
                    SMODS.calculate_effect(reps[i], card)
                end
                calc_random_joker(card, context)
            end
        end
    else
        return old_ec(card, context)
    end
end

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
        local effect = temp_card:calculate_joker({ cardarea = G.jokers, full_hand = G.play.cards, scoring_hand =
        other_context.scoring_hand, scoring_name = other_context.scoring_name, poker_hands = other_context.poker_hands, joker_main = true })
        if effect then
            SMODS.calculate_effect(effect, card)
        end
        temp_card:remove_from_deck()
        temp_card:remove()
    end
end

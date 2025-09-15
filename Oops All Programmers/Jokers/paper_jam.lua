SMODS.Joker {
    key = 'paper_jam',
    rarity = 1,
    cost = 6,
    config = {
        extra = {
            retriggers = 4,
            card_threshold = 5,
            chosen_card = nil
        }
    },
    atlas = "oap_jokers",
    pos = { x = 6, y = 0 },
    pixel_size = { h = 77 },
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.retriggers,
            card.ability.extra.card_threshold
         } }
    end,
    calculate = function(self, card, context)
        if context.before
        and context.main_eval
        and #context.scoring_hand >= card.ability.extra.card_threshold then
            card.ability.extra.chosen_card = pseudorandom_element(context.scoring_hand)
        end
        if context.repetition
        and card.ability.extra.chosen_card
        and context.other_card == card.ability.extra.chosen_card then
            return {
                repetitions = card.ability.extra.retriggers
            }
        end
        if context.after then
            card.ability.extra.chosen_card = nil
        end
    end,
    hotpot_credits = {
        art = {'th30ne'},
        code = {'th30ne'},
        idea = {'th30ne'},
        team = {'Oops! All Programmers'}
    }
}
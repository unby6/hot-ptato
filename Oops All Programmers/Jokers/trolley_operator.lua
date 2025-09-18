SMODS.Joker {
    key = 'trolley_operator',
    rarity = 2,
    cost = 5,
    atlas = "oap_jokers",
    pos = { x = 7, y = 1 },
    config = {
        extra = {
            money = 3,
            hand_goal = 5
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.hand_goal, card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.before and #G.hand.cards == card.ability.extra.hand_goal then
            local chosen_card = pseudorandom_element(G.hand.cards)
            G.E_MANAGER:add_event(Event({
                func = function()
                    chosen_card:start_dissolve()
                    return true;
                end
            }))
            return {
                dollars = card.ability.extra.money
            }
        end
    end,
    hotpot_credits = {
        art = { '?' },
        code = { 'theAstra' },
        idea = { 'th30ne', 'theAstra' },
        team = { 'Oops! All Programmers' }
    }
}
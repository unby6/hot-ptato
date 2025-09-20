SMODS.Joker {
    key = "sonloaf",
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 },
    hotpot_credits = {
        art = { '?' },
        code = { 'factwixard' },
        idea = { 'theAstra' },
        team = { 'Oops! All Programmers' }
    }
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card.config.center.pools.Food and G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer) then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card {
                        set = 'Food',
                        key_append = "sonloaf"
                    }
                    G.GAME.joker_buffer = 0
                    return true
                end
            }))
        end
    end
}

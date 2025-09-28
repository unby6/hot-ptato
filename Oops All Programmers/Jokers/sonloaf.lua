SMODS.Joker {
    key = "sonloaf",
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 }, -- If you see this comment it means Son Loaf never got a chance to be sprited
    hotpot_credits = {
        art = { '?' },
        code = { 'factwixard' },
        idea = { 'theAstra' },
        team = { 'Oops! All Programmers' }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = { key = "hpot_sonloaf_comment", set = "Other" } -- remove after sprite pls - trif
    end,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card.config.center.pools and context.card.config.center.pools.Food and G.jokers.config.card_limit - (#G.jokers.cards + G.GAME.joker_buffer) then
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

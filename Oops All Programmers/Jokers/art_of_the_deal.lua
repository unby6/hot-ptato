SMODS.Joker {
    key = 'art_of_the_deal',
    rarity = 2,
    cost = 6,
    atlas = "oap_jokers",
    pos = { x = 2, y = 0 },
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.game_over then
            G.E_MANAGER:add_event(Event({
                func = function()
                    SMODS.add_card({set = 'Czech', key_append = 'AofD'})
                    card:juice_up(0.3,0.5)
                    return true;
                end
            }))
        end
    end,
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'theAstra' },
        idea = { 'trif' },
        team = { 'Oops! All Programmers' }
    }
}
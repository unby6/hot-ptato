SMODS.Joker {
    key = 'wumpus',
    rarity = 1,
    cost = 4,
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            money = 5,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {  card.ability.extra.money } }
    end,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card ~= card then
            return {
                no_destroy = true,
                dollars = card.ability.extra.money,
                func = function()
                    card:start_dissolve()
                end
            }
        end
    end,
    hotpot_credits = {
        art = { '?' },
        code = { 'theAstra' },
        idea = { 'th30ne' },
        team = { 'Oops! All Programmers' }
    }
}
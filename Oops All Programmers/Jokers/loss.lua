SMODS.Joker {
    key = 'loss',
    atlas = 'oap_jokers',
    pos = {x = 2, y = 1},
    rarity = 2,
    cost = 6,
    config = {
        extra = {
            Xmult = 1,
            gain = 1
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.Xmult, card.ability.extra.gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'theAstra' },
        idea = { 'th30ne' },
        team = { 'O!AP' }
    }
}
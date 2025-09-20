SMODS.Joker {
    key = 'undying',
    rarity = 3,
    cost = 7,
    atlas = "oap_jokers",
    pos = { x = 0, y = 1 },
    config = {
        extra = {
            Xmult = 1,
            gain = 1,
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {  card.ability.extra.Xmult, card.ability.extra.gain } }
    end,
    calculate = function(self, card, context)
        if context.joker_type_destroyed and context.card == card then
            local new_card = SMODS.add_card {
                key = 'j_hpot_undying'
            }
            SMODS.scale_card (new_card, {
                ref_table = new_card.ability.extra,
                ref_value = 'Xmult',
                scalar_table = card.ability.extra,
                scalar_value = 'gain',
                message_colour = G.C.MULT,
                message_key = 'k_oap_undying'
            })
        end

        if context.joker_main then
            return {
                xmult = card.ability.extra.Xmult
            }
        end
    end,
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'theAstra' },
        idea = { 'th30ne' },
        team = { 'Oops! All Programmers' }
    }
}
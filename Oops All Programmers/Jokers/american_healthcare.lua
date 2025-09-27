SMODS.Joker {
    key = 'american_healthcare',
    blueprint_compat = true,
    rarity = 3,
    cost = 7,
    atlas = "oap_jokers",
    pos = { x = 2, y = 2 },
    config = {
        extra = {
            xmult = 1,
            inc = 0.5,
            this_round = false
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.inc, card.ability.extra.xmult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
        if context.pregnant and not card.ability.extra.this_round and not context.blueprint then
            card.ability.extra.this_round = true
            SMODS.scale_card(card, {ref_table = card.ability.extra, ref_value = "xmult", scalar_value = "inc"})
        end
        if context.leaving_shop then
            card.ability.extra.this_round = false
        end
    end,
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'trif' },
        idea = { 'trif' },
        team = { 'Oops! All Programmers' }
    }
}

local old = G.FUNCS.nursery_breed
function G.FUNCS.nursery_breed(e)
    old(e)
    SMODS.calculate_context {
        pregnant = true
    }
end
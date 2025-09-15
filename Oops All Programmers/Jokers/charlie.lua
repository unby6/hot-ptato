SMODS.Joker {
    key = 'charlie',
    rarity = 1,
    cost = 5,
    config = {
        extra = {
            mult = 0,
            gain = 8
        }
    },
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.other_ret and context.other_ret.jokers and (context.other_ret.jokers.chips or context.other_ret.jokers.h_chips or context.other_ret.jokers.chip_mod) and not context.retrigger_joker_check then
            SMODS.scale_card(card,{
                ref_table = card.ability.extra,
                ref_value = 'mult',
                scalar_value = 'gain',
                message_colour = G.C.MULT
            })
        end

        if context.individual and context.cardarea == G.play and not context.end_of_round and not context.repetition and context.other_card:get_chip_bonus() > 0 then
            SMODS.scale_card(card,{
                ref_table = card.ability.extra,
                ref_value = 'mult',
                scalar_value = 'gain',
                message_colour = G.C.MULT
            })
        end

        if context.joker_main and card.ability.extra.mult > 0 then
            return {
                mult = card.ability.extra.mult
            }
        end
    end,
    hotpot_credits = {
        art = {'th30ne'},
        code = {'theAstra'},
        idea = {'th30ne'},
        team = {'Oops! All Programmers'}
    }
}
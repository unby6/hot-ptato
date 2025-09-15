SMODS.Joker {
    key = 'ouroboros',
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            Xmult = 1,
            gain = 0.5
        }
    },
    atlas = "oap_jokers",
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.gain, card.ability.extra.Xmult } }
    end,
    calculate = function(self, card, context)
        if context.card_added and context.card.ability.set == 'Joker' and #G.jokers.cards == G.jokers.config.card_limit and not (context.card.ability.card_limit and context.card.ability.card_limit >= 1) then
            local eligible_cards = {}

            for k, v in pairs(G.jokers.cards) do
                if v ~= card and v ~= context.card then
                    eligible_cards[#eligible_cards + 1] = v
                end
            end

            local destroy_card = pseudorandom_element(eligible_cards)
            destroy_card:start_dissolve()

            SMODS.scale_card(card, {
                ref_table = card.ability.extra,
                ref_value = 'Xmult',
                scalar_value = 'gain',
                message_colour = G.C.MULT
            })
        end

        if context.joker_main and card.ability.extra.Xmult > 1 then
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

local cfbs = G.FUNCS.check_for_buy_space
G.FUNCS.check_for_buy_space = function(card)
    if next(SMODS.find_card('j_hpot_ouroboros')) and card.ability.set == 'Joker' then
        return true
    end
    return cfbs(card)
end

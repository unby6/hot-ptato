SMODS.Joker {
    key = 'OAP',
    atlas = 'oap_self_insert',
    pos = {x = 0, y = 0},
    rarity = 2,
    discovered = true,
    config = {
        extra = {
            effect = 'trif'
        },
        trif_effect = {

        },
        sadcube_effect = {

        },
        astra_effect = {

        },
        wix_effect = {

        },
        myst_effect = {

        },
        lia_effect = {

        },
        th30ne_effect = {
            xmult = 3
        },
    },
    set_ability = function(self, card, initial, delay_sprites)
        local choices = { 'trif', 'sadcube', 'astra', 'wix', 'myst', 'lia', 'th30ne' } -- Notice: Same order as sprite sheet

        local chosen_index = pseudorandom('oap', 1, 7)
        card.ability.extra.effect = choices[chosen_index]
        card.children.center.atlas = G.ASSET_ATLAS['hpot_oap_self_insert']
        card.children.center:set_sprite_pos({x = chosen_index - 1, y = 0})
    end,
    loc_vars = function(self, info_queue, card)
        return { key = 'j_hpot_OAP_'..card.ability.extra.effect, vars = card.ability[card.ability.extra.effect .. '_effect'] or {} }
    end,

    calculate = function(self, card, context)

        -- th30ne
        if card.ability.extra.effect == 'th30ne' and context.joker_main then
            local aces = {}
            local threes = {}
            for _, playing_card in ipairs(context.scoring_hand) do
                if playing_card:get_id() == 3 then
                    table.insert(threes, playing_card)
                elseif playing_card:get_id() == 14 then
                    table.insert(aces, playing_card)
                end
            end
            if #aces > 0 and #threes > 0 then
                for _, ace in ipairs(aces) do
                    for _, three in ipairs(threes) do
                        if ace.base.suit ~= three.base.suit 
                        and not SMODS.has_enhancement(ace, 'm_wild')
                        and not SMODS.has_enhancement(three, 'm_wild') then
                            return {
                                xmult = card.ability.th30ne_effect.xmult
                            }
                        end
                    end
                end
            end
        end
    end,
    hotpot_credits = {
        art = {'SadCube'},
        team = {'Oops! All Programmers'}
    }
}

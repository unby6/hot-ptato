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
}

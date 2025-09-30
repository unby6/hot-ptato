SMODS.Atlas({key = "SillypostingSeals", path = "Sillyposting/Seals.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

SMODS.Seal {
    key = 'plincoin',
    atlas = 'SillypostingSeals',
    pos = { x = 0, y = 0 },
    config = { extra = { plincoin = 1 } },
    badge_colour = HEX('56a786'),

    -- copy pasted from gold seal (thank you N')
    draw = function(self, card, layer)
        if (layer == 'card' or layer == 'both') and card.sprite_facing == 'front' then
            G.shared_seals[card.seal].role.draw_major = card
            G.shared_seals[card.seal]:draw_shader('dissolve', nil, nil, nil, card.children.center)
            G.shared_seals[card.seal]:draw_shader('voucher', nil, card.ARGS.send_to_shader, nil, card.children.center)
        end
    end,

    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            ease_plincoins(card.ability.seal.extra.plincoin)
            return {
                message = "+$"..card.ability.seal.extra.plincoin,
                colour = G.C.GREEN,
                font = SMODS.Fonts["hpot_plincoin"],
            }
        end
    end,

    hotpot_credits = {
        art = {'Supernova'},
        code = {'Jaydchw'},
        team = {'Sillyposting'}
    },
}

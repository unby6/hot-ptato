SMODS.Joker {
    key = 'OAP',
    atlas = 'oap_self_insert',
    pos = { x = 0, y = 0 },
    rarity = 2,
    cost = 6,
    discovered = true,
    config = {
        extra = {
            effect = 'trif'
        },
        trif_effect = {

        },
        sadcube_effect = {
            modifiers = 2,
            multiplier = 4,
            modifier_resets = 2,
            gain = 2
        },
        astra_effect = {},
        wix_effect = {
            xchips = 2
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
        card.children.center:set_sprite_pos({ x = chosen_index - 1, y = 0 })
    end,
    loc_vars = function(self, info_queue, card)
        local key = 'j_hpot_OAP_' .. card.ability.extra.effect

        if card.ability.extra.effect == 'th30ne' then
            return {
                key = key,
                vars = { card.ability.th30ne_effect.xmult }
            }
        end

        if card.ability.extra.effect == 'wix' then
            return {
                key = key,
                vars = { card.ability.wix_effect.xchips }
            }
        end

        if card.ability.extra.effect == 'sadcube' then
            return {
                key = key,
                vars = { card.ability.sadcube_effect.modifiers, card.ability.sadcube_effect.multiplier, card.ability.sadcube_effect.gain }
            }
        end

        return {
            key = key
        }
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

        -- theAstra
        if card.ability.extra.effect == 'astra' and context.after and #context.full_hand == 1 and not (context.full_hand[1]:is_face() or context.full_hand[1]:get_id() == 14) and not context.blueprint then
            local initial_card = context.full_hand[1]
            local suit = initial_card.base.suit
            local rank1 = math.floor(initial_card.base.id / 2)
            local rank2 = initial_card.base.id - rank1

            rank1 = rank1 == 1 and 'Ace' or rank1
            rank2 = rank2 == 1 and 'Ace' or rank2

            local card1, card2 = {}, {}

            SMODS.destroy_cards(initial_card)

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.2,
                func = function()
                    play_sound('slice1')

                    card1 = SMODS.add_card({
                        set = 'Base',
                        rank = '' .. rank1,
                        suit = suit,
                        area = G.play,
                        skip_materialize = true
                    })

                    card2 = SMODS.add_card({
                        set = 'Base',
                        rank = '' .. rank2,
                        suit = suit,
                        area = G.play,
                        skip_materialize = true
                    })

                    card:juice_up(0.3, 0.4)
                    card1:juice_up(0.3, 0.4)
                    card2:juice_up(0.3, 0.4)

                    return true;
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.5,
                func = function()
                    draw_card(card1.area, G.discard, 1 * 100 / 2, 'down', nil, nil, 0.07, card1)
                    draw_card(card2.area, G.discard, 2 * 100 / 2, 'down', nil, nil, 0.07, card2)
                    return true;
                end
            }))
        end

        --wix
        if card.ability.extra.effect == "wix" and context.individual and context.cardarea == G.play and context.other_card:get_id() == 12 then
            return {
                xchips = card.ability.wix_effect.xchips,
                xchip_message = { message = "X2 Chips", sound = "hpot_forgiveness", colour = G.C.CHIPS }
            }
        end

        --SadCube
        if card.ability.extra.effect == 'sadcube' then
            if context.mod_probability and card.ability.sadcube_effect.modifiers > 0 then
                if context.from_roll then
                    card.ability.sadcube_effect.modifiers = card.ability.sadcube_effect.modifiers - 1
                end
                return {
                    numerator = context.numerator * card.ability.sadcube_effect.multiplier
                }
            end

            if context.end_of_round and context.cardarea == G.jokers then
                SMODS.scale_card(card, {
                    ref_table = card.ability.sadcube_effect,
                    ref_value = 'modifier_resets',
                    scalar_value = 'gain',
                    message_colour = G.C.GREEN
                })
                card.ability.sadcube_effect.modifiers = card.ability.sadcube_effect.modifier_resets
            end
        end
    end,
    hotpot_credits = {
        art = { 'SadCube' },
        team = { 'Oops! All Programmers' }
    }
}

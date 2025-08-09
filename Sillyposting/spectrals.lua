SMODS.Atlas({key = "SillypostingSpectrals", path = "Sillyposting/Spectrals.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

-- Arcade Machine
SMODS.Consumable {
    key = 'arcade_machine',
    set = 'Spectral',
    pos = { x = 0, y = 0 },
    atlas = 'SillypostingSpectrals',
    config = { extra = { seal = 'hpot_plincoin' }, max_highlighted = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { vars = { card.ability.max_highlighted } }
    end,
    use = function(self, card, area, copier)
        local conv_card = G.hand.highlighted[1]
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                conv_card:set_seal(card.ability.extra.seal, nil, true)
                return true
            end
        }))

        delay(0.5)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,

     hotpot_credits = {
        art = {'Jaydchw'},
        code = {'Jaydchw'},
        team = {'Sillyposting'}
    },
    
}
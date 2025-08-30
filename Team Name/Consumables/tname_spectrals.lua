SMODS.Consumable {
    key = 'blossom',
    set = 'Spectral',
    pos = { x = 0, y = 0 },
    atlas = 'tname_spectrals',
    config = { extra = { seal = 'hpot_hanafuda' }, max_highlighted = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local key = self.key
        if (G.GAME.max_highlighted_mod or 0) > 0 then
            key = key .. "_p"
        end
        info_queue[#info_queue + 1] = G.P_SEALS[card.ability.extra.seal]
        return { key = key, vars = { math.max(1, card.ability.max_highlighted + (G.GAME.max_highlighted_mod or 0)) , colours = {HEX('800058')}} }
    end,
    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
        for _, i in ipairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function() 
                    i:set_seal(card.ability.extra.seal, nil, true)
                    return true
                end
            }))
        end
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
		idea = {"GoldenLeaf"},
        art = {'GoldenLeaf'},
        code = {'Goldenleaf'},
        team = {'Team Name'}
    },
    
}
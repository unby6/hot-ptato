SMODS.Consumable {
    key = 'apparition',
    set = 'Spectral',
    pos = { x = 2, y = 0 },
    atlas = 'hc_placeholder',
    discovered = true,
    loc_vars = function(self, info_queue, card)
        if not card.edition or not card.edition.hpot_phantasmic then
            info_queue[#info_queue + 1] = G.P_CENTERS.e_hpot_phantasmic
        end
    end,
    use = function(self, card, area, copier)
        local card = pseudorandom_element(G.consumeables.cards, pseudoseed("apparition"))
        if card then
            card:set_edition("e_hpot_phantasmic")
        end
    end,
    can_use = function()
        return G.consumeables and #G.consumeables.cards > 0
    end,
    hotpot_credits = {
        art = {'lord.ruby'},
        code = {'lord.ruby'},
        team = {'Horsechicot'}
    },
    
}
--#region UBlock Deck
SMODS.Back {
    key = 'ublockdeck',
    atlas = 'pdr_decks',
    pos = { x = 1, y = 0 },
    discovered = true
}

local ref = create_ads
function create_ads(e)
    if G.GAME.selected_back.name ~= 'b_hpot_ublockdeck' then
        return ref(e)
    end
end

--#endregion

--#region Poop Deck
SMODS.Back {
    key = 'poopdeck',
    atlas = 'pdr_decks',
    pos = { x = 0, y = 0 },
    discovered = true,
    skip_materialize = true,
    config = { stones = 30 },
    apply = function(self, back)
        G.E_MANAGER:add_event({
            func = function()
                for _ = 1, self.config.stones do
                    SMODS.add_card {
                        set = "Base",
                        enhancement = "m_stone",
                        edition = 'e_polychrome',
                        rank = '2',
                        area = G.playing_cards,
                    }
                end
                return true
            end
        })
    end
}

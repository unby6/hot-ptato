SMODS.Back {
    key = 'ublockdeck',
    atlas = 'pdr_ublock',
    discovered = true
}

local ref = create_ads
function create_ads(e)
    if G.GAME.selected_back.name ~= 'b_hpot_ublockdeck' then
        return ref(e)
    end
end

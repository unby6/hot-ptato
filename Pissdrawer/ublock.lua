SMODS.Back {
    key = 'gojodeck',
    atlas = 'deckgojo',
    discovered = true,
    apply = function(self, back)
        for k, v in ipairs(G.GAME.hotpot_ads) do
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.FUNCS.remove_ad(v.config.id)
                return true end
            }))
        end
    end
}
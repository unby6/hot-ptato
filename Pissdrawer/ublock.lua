SMODS.Back {
    key = 'ublockdeck',
    discovered = true,
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            func = function()
                for k, v in ipairs(G.GAME.hotpot_ads) do
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            G.FUNCS.remove_ad(v.config.id)
                            return true
                        end
                    }))
                end
                return true
            end
        }))
    end
}

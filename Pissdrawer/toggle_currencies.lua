function G.FUNCS.toggle_currencies()
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            if not Toggle_currencies then Toggle_currencies = true else Toggle_currencies = false end
            G.HUD:remove()
            G.HUD_blind:remove()
            G.HUD, G.HUD_blind = nil, nil
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.HUD = UIBox {
                        definition = create_UIBox_HUD(),
                        config = { align = ('cli'), offset = { x = -0.7, y = 0 }, major = G.ROOM_ATTACH }
                    }
                    return true
                end
            }))
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.HUD_blind = UIBox {
                        definition = create_UIBox_HUD_blind(),
                        config = { major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = { x = 0, y = -10 }, bond = 'Weak' }
                    }
                    return true
                end
            }))
            return true
        end
    }))
end

local uib = UIBox.set_parent_child
function UIBox:set_parent_child(node, parent)
    if node and self then
        return uib(self, node, parent)
    end
end

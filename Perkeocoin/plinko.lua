

function create_plinko()
    
end

function delete_plinko()
    
end

-- Let's go gambling
G.FUNCS.show_plinko = function(e)
    hide_shop()

    -- TODO
end


-- Clicked back to shop
G.FUNCS.hide_plinko = function(e)
    show_shop()

    -- TODO
  --[[G.CONTROLLER.locks.toggle_shop = true
  if G.shop then 
    for i = 1, #G.jokers.cards do
      G.jokers.cards[i]:calculate_joker({ending_shop = true})
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
        G.shop.alignment.offset.y = G.ROOM.T.y + 29
        G.SHOP_SIGN.alignment.offset.y = -15
        return true
      end
    })) 
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.5,
      func = function()
        G.shop:remove()
        G.shop = nil
        G.SHOP_SIGN:remove()
        G.SHOP_SIGN = nil
        G.STATE_COMPLETE = false
        G.STATE = G.STATES.BLIND_SELECT
        G.CONTROLLER.locks.toggle_shop = nil
        return true
      end
    }))
  end]]
end

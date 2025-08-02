
-- Common utility functions



function show_shop()
    if G.shop and G.shop.alignment.offset.py then 
      G.shop.alignment.offset.y = G.shop.alignment.offset.py
      G.shop.alignment.offset.py = nil
    end
end

function hide_shop()
    if G.shop and not G.shop.alignment.offset.py then
      G.shop.alignment.offset.py = G.shop.alignment.offset.y
      G.shop.alignment.offset.y = G.ROOM.T.y + 29
    end
end



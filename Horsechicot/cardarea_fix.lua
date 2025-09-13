--i believe this imporved performance? i think handy had a bug where everything renders regardless. this is almost certainly a reimplementation of a vanilla optimization
local old = CardArea.draw
function CardArea:draw(...)
    if not ((self.T.x >= G.ROOM.T.w) or (self.T.y >= G.ROOM.T.h)) then
        return old(self, ...)
    end
end
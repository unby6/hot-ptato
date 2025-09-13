local old = CardArea.draw
function CardArea:draw(...)
    if not ((self.T.x >= G.ROOM.T.w) or (self.T.y >= G.ROOM.T.h)) then
        return old(self, ...)
    end
end
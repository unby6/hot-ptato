bigButtonBirthdayBash = {}
local peeButtRef = UIBox.init
function UIBox:init(args)
    local ret = peeButtRef(self, args)
    local pissbutton = G.UIDEF.pissbutton()
    if ret then
        if ret[definition] == create_UIBox_buttons() then
            table.insert(ret, pissbutton)
        end
    end
    return ret
end

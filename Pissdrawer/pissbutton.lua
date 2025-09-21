bigButtonBirthdayBash = {}
local peeButtRef = UIBox.init
function UIBox:init(args)
    local ret = peeButtRef(self, args)
    if args.config.button then
        table.insert(bigButtonBirthdayBash, ret)
    end
    return ret
end

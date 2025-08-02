--[[HotPotato.Ad = SMODS.Center:extend {
    class_prefix = 'ad',
    set = 'Ad',
    atlas = 'Ads', pos = {x=0,y=0},
    config = {},
    required_params = {
        'key',
    }
}]]

function create_UIBox_ad(adNum)
    local t = {n = G.UIT.ROOT, config = {colour = G.C.BLACK, minw = 3, minh = 2, instance_type = 'ALERT', r = 0.3, outline = 0.5, outline_colour = G.C.GREY, shadow = true}, nodes = {
        {n=G.UIT.R, config = {colour = G.C.GREY, minw = 3, align = 'cr', r = 0.3}, nodes = {
            {n=G.UIT.C, config = {colour = G.C.CLEAR, align = 'cl', minw = 2.5}, nodes = {
                {n=G.UIT.T, config = {text = 'ad'..adNum, colour = G.C.UI.TEXT_LIGHT, scale = 0.4}}
            }},
            {n=G.UIT.C, config = {align = 'cm', colour = G.C.RED, minw = 0.3, minh = 0.3, r = 0.3}, nodes = {
                {n=G.UIT.T, config = {text = 'X', colour = G.C.UI.TEXT_LIGHT, scale = 0.4}}
            }}
        }},
        {n=G.UIT.R, config = {colour = G.C.BLACK, r = 0.3}}
    }}
    return t
end

local end_round_ref = end_round
function end_round()
    if G.GAME.blind:get_type() == "Boss" then
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.ad = G.GAME.ad or {}
                local new_ad = UIBox{
                    definition = create_UIBox_ad(#G.GAME.ad+1),
                    config = {align="cm", offset = {x=0,y=0}, instance_type = 'ALERT', major = G.ROOM_ATTACH, bond = 'Weak'}
                }
                new_ad.alignment.offset.x = pseudorandom('ad_x_offset', -6, 6)
                new_ad.alignment.offset.y = pseudorandom('ad_y_offset', -4, 4)
                G.GAME.ad[#G.GAME.ad+1] = new_ad
            return true end}))
    end
    return end_round_ref()
end
HotPotato.Ads = {
    ad_tutorial = {atlas = 'hpot_Ads', pos = {x=0,y=0}},
    ad_lusty = {atlas = 'hpot_Ads', pos = {x=1,y=0}}
}

SMODS.Atlas{
    key = 'Ads',
    px = 150,
    py = 100,
    path = 'Ads.png'
}

local apply_to_run_ref = Back.apply_to_run
function Back:apply_to_run()
    G.GAME.hotpot_total_ads = 0
    G.GAME.hotpot_ads_closed = 0
    return apply_to_run_ref(self)
end

function create_UIBox_ad(ad, adNum)
    local ad_image = Sprite(0,0,3.2,2.16,G.ASSET_ATLAS[ad.atlas],ad.pos)
    ad_image.states.drag.can = false
    local t = {n = G.UIT.ROOT, config = {colour = G.C.BLACK, minw = 3, minh = 2, instance_type = 'CARD', r = 0.3, outline = 0.5, outline_colour = G.C.GREY, shadow = true}, nodes = {
        {n=G.UIT.R, config = {colour = G.C.GREY, minw = 3, minh = 0.5, align = 'cr', r = 0.3, padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {colour = G.C.CLEAR, align = 'cl', minw = 2.7}, nodes = {
                {n=G.UIT.T, config = {text = 'ad_'..adNum, colour = G.C.UI.TEXT_LIGHT, scale = 0.4}}
            }},
            {n=G.UIT.C, config = {align = 'cm', colour = G.C.RED, minw = 0.3, minh = 0.3, r = 0.3, button = 'remove_ad', adnum = adNum}, nodes = {
                {n=G.UIT.T, config = {text = 'X', colour = G.C.UI.TEXT_LIGHT, scale = 0.4}}
            }}
        }},
        {n=G.UIT.R, config = {colour = G.C.GREY, r = 0.3, align = 'cm'}, nodes = {
            {n = G.UIT.O, config = {object = ad_image, r = 0.3}}
        }}
    }}
    return t
end

G.FUNCS.remove_ad = function(args)
    local remove_this_ad = nil
    for k, v in ipairs(G.GAME.hotpot_ads) do
        if v.config.id == args.config.adnum then
            remove_this_ad = v
            table.remove(G.GAME.hotpot_ads, k)
            break
        else
        end
    end
    remove_this_ad:remove()
    G.GAME.hotpot_ads_closed = G.GAME.hotpot_ads_closed + 1
end

local end_round_ref = end_round
function end_round()
    if G.GAME.blind:get_type() == "Boss" then
        G.E_MANAGER:add_event(Event({
            func = function()
                local ad_to_use = nil
                if G.GAME.hotpot_total_ads == 0 then
                    local ad_to_use = HotPotato.Ads['ad_tutorial']
                else
                    local ad_to_use = pseudorandom_element(HotPotato.Ads,'generate_ad')
                end
                G.GAME.hotpot_total_ads = G.GAME.hotpot_total_ads + 1
                G.GAME.hotpot_ads = G.GAME.hotpot_ads or {}
                local new_ad = UIBox{
                    definition = create_UIBox_ad(ad_to_use, G.GAME.hotpot_total_ads),
                    config = {align="cm", offset = {x=0,y=0}, instance_type = 'CARD', major = G.ROOM_ATTACH, bond = 'Weak'}
                }
                new_ad.alignment.offset.x = (pseudorandom('ad_x_offset')-0.5)*16
                new_ad.alignment.offset.y = (pseudorandom('ad_y_offset')-0.5)*9
                new_ad.config.id = G.GAME.hotpot_total_ads
                G.GAME.hotpot_ads[#G.GAME.hotpot_ads+1] = new_ad
            return true end}))
    end
    return end_round_ref()
end
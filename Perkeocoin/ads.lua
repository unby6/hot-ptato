HotPotato.Ads = {
    Adverts = {
        ad_lusty = {atlas = 'hpot_Ads', pos = {x=1,y=0}, animated = false, base_size = 0.75},
        ad_boredjoker = {atlas = 'hpot_Ads', pos = {x=2, y=0}, animated = false, base_size = 0.75},
        ad_triboulet = {atlas = 'hpot_TribouletAd', pos = {x=0,y=0}, animated = true, base_size = 0.75},
    },
    Shitposts = {
        ad_digging = {atlas = 'hpot_Ads', pos = {x=3,y=0}, animated = false, base_size = 0.75},
        ad_smoothie = {atlas = 'hpot_ProtoShitposts', pos = {x=0,y=0}, animated = false, base_size = 0.25, max_scale = 0.3},
        ad_peeling = {atlas = 'hpot_ProtoShitposts', pos = {x=1,y=0}, animated = false, base_size = 0.25, max_scale = 0.3},
        ad_spectred = {atlas = 'hpot_SpectredAd', pos = {x=0,y=0}, animated = true, base_size = 0.75},
    },
    Special = {
        ad_tutorial = {atlas = 'hpot_Ads', pos = {x=0,y=0}, animated = false, base_size = 0.75},
        ad_animated = {atlas = 'hpot_AbbieMindwave', pos = {x=0,y=0}, animated = true, base_size = 0.25, max_scale = 0.25}, -- Demonstration. Do not include in final product
    }
    -- Defaults = {atlas = 'hpot_Ads', pos = {x=0,y=0}, animated = false, base_size = 0.75}
}

SMODS.Atlas{ -- Normal ad atlas. Note that size can be anything, but this is the recommended px/py
    key = 'Ads',
    px = 150,
    py = 100,
    path = 'Ads/Ads.png'
}

SMODS.Atlas{ -- Animated ad atlas. PLEASE have a normal amount of frames :(
    key = 'AnimatedAds',
    px = 150,
    py = 100,
    path = 'Ads/AnimatedAds.png',
    frames = 8,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas{
    key = 'TribouletAd',
    px = 150,
    py = 100,
    path = 'Ads/Tribouletad.png',
    frames = 16,
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas{
    key = 'ProtoShitposts',
    px = 300,
    py = 400,
    path = 'Ads/ProtoAds.png'
}

SMODS.Atlas{
    key = 'SpectredAd',
    px = 281,
    py = 118,
    frames = 10,
    path = 'Ads/Spectred.png',
    atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas{
    key = 'AbbieMindwave',
    px = 300,
    py = 300,
    path = 'Ads/AbbieMindwave.png',
    frames = 4,
    atlas_table = 'ANIMATION_ATLAS'
}

local apply_to_run_ref = Back.apply_to_run
function Back:apply_to_run()
    G.GAME.hotpot_total_ads = 0
    G.GAME.hotpot_ads_closed = 0
    return apply_to_run_ref(self)
end

function create_UIBox_ad(ad, adNum, scale)
    local ad_atlas = nil
    local ad_image = nil
    if ad.animated and ad.animated == true then
        ad_atlas = G.ANIMATION_ATLAS[(ad.atlas or 'hpot_Ads')]
        ad_image = AnimatedSprite(0,0,(ad_atlas.px/49)*scale,(ad_atlas.py/49)*scale,ad_atlas,{x = math.ceil((pseudorandom('random_start')*ad_atlas.frames) - 0.5), y = ad.pos.y})
    else
        ad_atlas = G.ASSET_ATLAS[(ad.atlas or 'hpot_Ads')]
        ad_image = Sprite(0,0,(ad_atlas.px/49)*scale,(ad_atlas.py/49)*scale,ad_atlas,(ad.pos or {x=0,y=0}))
    end
    ad_image.states.drag.can = true
    local t = {n = G.UIT.ROOT, config = {colour = G.C.GREY, minh = 2, instance_type = 'CARD', r = 0.3, outline = 2, outline_colour = G.C.GREY, shadow = true}, nodes = {
        {n=G.UIT.R, config = {colour = G.C.GREY, minh = 0.5, align = 'cr', r = 0.3, padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {colour = G.C.CLEAR, align = 'cl'}, nodes = {
                {n=G.UIT.T, config = {text = 'ad_'..adNum, colour = G.C.UI.TEXT_LIGHT, scale = 0.4, align = 'cl'}}
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

    for i=1, #G.jokers.cards do
        local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, close_ad = remove_this_ad})
        if effects.jokers then
            card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, effects.jokers)
        end
    end

    if remove_this_ad then remove_this_ad:remove() end
    G.GAME.hotpot_ads_closed = G.GAME.hotpot_ads_closed + 1
    save_run()
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local result = start_run_ref(self, args)

    G.GAME.hotpot_ads = {}
    if args and args.savetext and type(args.savetext.hotpot_ads) == "table" then
        for k, v in ipairs(args.savetext.hotpot_ads) do
            local new_ad = UIBox{
                definition = create_UIBox_ad(v.key, v.id, v.scale),
                config = {align="cm", offset = v.offset, instance_type = 'CARD', major = G.ROOM_ATTACH, bond = 'Weak'}
            }
            new_ad.config.id = v.id
            new_ad.config.key = v.key
            new_ad.config.scale = v.scale
            G.GAME.hotpot_ads[k] = new_ad
        end
    end
    return result
end

function save_ad(ad)
    return{
        key = ad.config.key,
        id = ad.config.id,
        offset = ad.alignment.offset,
        scale = ad.config.scale
    }
end

local end_round_ref = end_round
function end_round()
    if G.GAME.blind:get_type() == "Boss" then
        local number_of_ads = 1+(math.ceil((pseudorandom('ad_num')-0.5)*2))
        create_ads(number_of_ads)
    end
    return end_round_ref()
end

function create_ads(number_of_ads)
  for i = 1, number_of_ads do
    G.E_MANAGER:add_event(Event({
        func = function()
            local ad_to_use = nil
            if G.GAME.hotpot_total_ads == 0 then
                ad_to_use = HotPotato.Ads.Special['ad_tutorial']
            else
                local ad_type_poll = pseudorandom('ad_type')
                if ad_type_poll <= 0.95 then
                    ad_to_use = pseudorandom_element(HotPotato.Ads.Adverts,'generate_ad')
                else
                    ad_to_use = pseudorandom_element(HotPotato.Ads.Shitposts,'generate_ad')
                end
            end
            local ad_scale = (ad_to_use.base_size or 0.75) + ((ad_to_use.max_scale or 0.5)*pseudorandom('ad_scale'))
            G.GAME.hotpot_total_ads = G.GAME.hotpot_total_ads + 1
            G.GAME.hotpot_ads = G.GAME.hotpot_ads or {}
            local new_ad = UIBox{
                definition = create_UIBox_ad(ad_to_use, G.GAME.hotpot_total_ads, ad_scale),
                config = {align="cm", offset = {x=0,y=0}, instance_type = 'CARD', major = G.ROOM_ATTACH, bond = 'Weak'}
            }
            new_ad.alignment.offset.x = (pseudorandom('ad_x_offset')-0.5)*16
            new_ad.alignment.offset.y = (pseudorandom('ad_y_offset')-0.5)*9
            new_ad.config.id = G.GAME.hotpot_total_ads
            new_ad.config.key = ad_to_use
            new_ad.config.scale = ad_scale
            G.GAME.hotpot_ads[#G.GAME.hotpot_ads+1] = new_ad
        return true end}))
        end
end

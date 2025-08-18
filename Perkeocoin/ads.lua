HotPotato.Ads = {
    Adverts = { -- Adverts are pulled from this pool most of the time.
        ad_lusty = {atlas = 'hpot_Perkeocoin_Ads', pos = {x=1,y=0}, animated = false, base_size = 0.75},
        ad_hawaii = {atlas = 'hpot_Perkeocoin_Ads', pos = {x=2, y=0}, animated = false, base_size = 0.75},
        ad_triboulet = {atlas = 'hpot_TribouletAd', pos = {x=0,y=0}, animated = true, base_size = 0.75},
        ad_attack = {atlas = 'hpot_Perkeocoin_Ads', pos = {x=0, y=0}, animated = false, base_size = 0.75, max_scale = 0.5},
        ad_dotty = {atlas = 'hpot_DottyAd', pos = {x=0, y=0}, animated = false, base_size = 0.6, max_scale = 0.6},
        ad_perkeoboss = {atlas = 'hpot_PerkeoBoss', pos = {x=0, y=0}, animated = false, base_size = 0.3, max_scale = 0.2},
        ad_obsidian = {atlas = "hpot_jtemads",pos = {x=0,y=1}},
        ad_what = {atlas = "hpot_jtemads",pos = {x=2,y=0}},
        ad_blank = {atlas = "hpot_jtemads",pos = {x=0,y=0}},
        ad_naner = {atlas = "hpot_jtemads",pos = {x=1,y=1}},
        ad_rally = {atlas = "hpot_jtemrally",pos = {x=0,y=0},animated = true},
        ad_fuck = {atlas = "hpot_jtemfuck",pos = {x=0,y=0},animated = true}
    },
    Shitposts = { -- Adverts are very rarely pulled from this pool.
        ad_digging = {atlas = 'hpot_Perkeocoin_Ads', pos = {x=3,y=0}, animated = false, base_size = 0.75},
        ad_smoothie = {atlas = 'hpot_ProtoShitposts', pos = {x=0,y=0}, animated = false, base_size = 0.25, max_scale = 0.3},
        ad_peeling = {atlas = 'hpot_ProtoShitposts', pos = {x=1,y=0}, animated = false, base_size = 0.25, max_scale = 0.3},
        ad_spectred = {atlas = 'hpot_SpectredAd', pos = {x=0,y=0}, animated = true, base_size = 0.75},
        ad_sweebro = {atlas = 'hpot_Perkeocoin_Ads', pos = {x=0,y=1}, animated = false, base_size = 0.75},
        ad_moonpiss = {atlas = "hpot_jtemads",pos = {x=1,y=0}}
    },
    Special = { -- Adverts in this pool can never naturally spawn.
        ad_animated = {atlas = 'hpot_AbbieMindwave', pos = {x=0,y=0}, animated = true, base_size = 0.25, max_scale = 0.25},
    }
    -- Defaults = {atlas = 'hpot_Perkeocoin_Ads', pos = {x=0,y=0}, animated = false, base_size = 0.75, max_scale = 0.5}
}

--- In case you haven't played HotPot yet, Ads appear after the Boss Blind is defeated.
--- They can also appear from a certain Joker, or a particular Consumable type.
--- Ads are not *actually* advertising anything - they are just meant to be silly :3

-- Normal ad atlas. Note that size can be anything, but this is the recommended px/py
SMODS.Atlas({key = 'Perkeocoin_Ads', px = 150, py = 100, path = 'Ads/Ads.png', atlas_table = "ASSET_ATLAS"}):register()

-- Animated ad atlas - animated ads use the default animation logic (i.e. have the same fps as Blind Chips)
SMODS.Atlas({key = 'TribouletAd', px = 150, py = 100, path = 'Ads/Tribouletad.png', frames = 16, atlas_table = 'ANIMATION_ATLAS'}):register()

-- Tutorial banner:
SMODS.Atlas({ key = 'TutorialAdBanner', px = 150, py = 31, path = 'Ads/AdBanners.png', atlas_table = "ASSET_ATLAS"}):register()

-- Other ad atli used by Perkeocoin:
SMODS.Atlas({key = 'ProtoShitposts', px = 300, py = 400, path = 'Ads/ProtoAds.png', atlas_table = "ASSET_ATLAS"}):register()
SMODS.Atlas({ key = 'SpectredAd', px = 281, py = 118, frames = 10, path = 'Ads/Spectred.png', atlas_table = 'ANIMATION_ATLAS'}):register()
SMODS.Atlas({ key = 'AbbieMindwave', px = 300, py = 300, path = 'Ads/AbbieMindwave.png', frames = 4, atlas_table = 'ANIMATION_ATLAS'}):register()
SMODS.Atlas({ key = 'DottyAd', px = 170, py = 150, path = 'Ads/DottyAd.png', atlas_table = 'ASSET_ATLAS'}):register()
SMODS.Atlas({ key = 'PerkeoBoss', px = 470, py = 326, path = 'Ads/PerkeoBoss.png', atlas_table = 'ASSET_ATLAS'}):register()


local apply_to_run_ref = Back.apply_to_run
function Back:apply_to_run()
    G.GAME.hotpot_total_ads = 0
    G.GAME.hotpot_ads_closed = 0
    return apply_to_run_ref(self)
end

function create_UIBox_ad(args)
    local ad = args.ad
    local adNum = args.id
    local scale = args.scale
    local ad_atlas = nil
    local ad_image = nil

    if ad.animated and ad.animated == true then
        ad_atlas = G.ANIMATION_ATLAS[(ad.atlas or 'hpot_Perkeocoin_Ads')]
        ad_image = AnimatedSprite(0,0,(ad_atlas.px/49)*scale,(ad_atlas.py/49)*scale,ad_atlas,{x = math.ceil((pseudorandom('random_start')*ad_atlas.frames) - 0.5), y = ad.pos.y})
    else
        ad_atlas = G.ASSET_ATLAS[(ad.atlas or 'hpot_Perkeocoin_Ads')]
        ad_image = Sprite(0,0,(ad_atlas.px/49)*scale,(ad_atlas.py/49)*scale,ad_atlas,(ad.pos or {x=0,y=0}))
    end

    local ad_content = {n=G.UIT.R, config = {colour = G.C.GREY, r = 0.3, align = 'cm'}, nodes = {
                        {n = G.UIT.O, config = {object = ad_image, r = 0.3}}
                    }}
    
    local tutorial_banner = nil
    local tutorial = args.tutorial or false
    local tutorial_content = nil

    if tutorial then
        tutorial_banner = Sprite(0,0,(150/49)*scale,(31/49)*scale,G.ASSET_ATLAS['hpot_TutorialAdBanner'], {x=0,y=0})
        tutorial_content = {n=G.UIT.R, config = {colour = G.C.GREY, r = 0.3, align = 'cm'}, nodes = {
                        {n = G.UIT.O, config = {object = tutorial_banner, r = 0.3}}
                        }}
                    
    end

    local t = {n = G.UIT.ROOT, config = {colour = G.C.GREY, minh = 2, instance_type = 'CARD', r = 0.3, outline = 2, outline_colour = G.C.GREY, shadow = true}, nodes = {
        {n=G.UIT.R, config = {colour = G.C.GREY, minh = 0.5, align = 'cr', r = 0.3, padding = 0.1}, nodes = {
            {n=G.UIT.C, config = {colour = G.C.CLEAR, align = 'cl'}, nodes = {
                {n=G.UIT.T, config = {text = 'ad_'..adNum, colour = G.C.UI.TEXT_LIGHT, scale = 0.4, align = 'cl'}}
            }},
            {n=G.UIT.C, config = {align = 'cm', colour = G.C.RED, minw = 0.3, minh = 0.3, r = 0.3, button = 'remove_ad', adnum = adNum}, nodes = {
                {n=G.UIT.T, config = {text = 'x', colour = G.C.UI.TEXT_LIGHT, scale = 0.4}}
            }}
        }},
        tutorial_content,
        ad_content
    }}
    return t
end

G.FUNCS.remove_ad = function(args)
    local remove_this_ad = nil
    if type(args) == 'table' then
        for k, v in ipairs(G.GAME.hotpot_ads) do
            if v.config.id == args.config.adnum then
                remove_this_ad = v
                table.remove(G.GAME.hotpot_ads, k)
                break
            else
            end
        end
    else
        for k, v in ipairs(G.GAME.hotpot_ads) do
            if v.config.id == args then
                remove_this_ad = v
                table.remove(G.GAME.hotpot_ads, k)
                break
            else
            end
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
                definition = create_UIBox_ad{ad = v.key, id = v.id, scale = v.scale, tutorial = v.tutorial},
                config = {align="cm", offset = v.offset, instance_type = 'CARD', major = G.ROOM_ATTACH, bond = 'Weak'}
            }
            new_ad.config.id = v.id
            new_ad.config.key = v.key
            new_ad.config.scale = v.scale
            new_ad.config.tutorial = v.tutorial
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
        scale = ad.config.scale,
        tutorial = ad.config.tutorial,
    }
end

local end_round_ref = end_round
function end_round()
    if G.GAME.blind:get_type() == "Boss" then
        local number_of_ads = 1+(math.ceil((pseudorandom('ad_num')-0.5)*2))
        create_ads(number_of_ads)
    else
        local number_of_ads = math.floor(pseudorandom('ad_num')*2)
        create_ads(number_of_ads)
    end
    return end_round_ref()
end

function create_ads(number_of_ads)
    local ad_index = #G.GAME.hotpot_ads or 0 --TODO: Find logic error that causes the bug. This default value is a temporary fix.
    for i = 1, number_of_ads do
        if next(SMODS.find_card("j_hpot_balatro_premium", false)) then
            G.GAME.hotpot_total_ads = G.GAME.hotpot_total_ads + 1
            for i=1, #G.jokers.cards do
                local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, close_ad = true})
                if effects.jokers then
                    card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, effects.jokers)
                end
            end
        else
            G.E_MANAGER:add_event(Event({
            func = function()
                local ad_to_use = nil
                local tutorial_ad = false
                if G.GAME.hotpot_total_ads == 0 then
                    tutorial_ad = true
                end

                local ad_type_poll = pseudorandom('ad_type')
                if ad_type_poll <= 0.95 then
                    ad_to_use = pseudorandom_element(HotPotato.Ads.Adverts,'generate_ad')
                else
                    ad_to_use = pseudorandom_element(HotPotato.Ads.Shitposts,'generate_ad')
                end

                local ad_scale = (ad_to_use.base_size or 0.75) + ((ad_to_use.max_scale or 0.5)*pseudorandom('ad_scale'))
                G.GAME.hotpot_total_ads = G.GAME.hotpot_total_ads + 1
                G.GAME.hotpot_ads = G.GAME.hotpot_ads or {}
                local new_ad = UIBox{
                    definition = create_UIBox_ad{ad = ad_to_use, id = G.GAME.hotpot_total_ads,scale = ad_scale, tutorial = tutorial_ad},
                    config = {align="cm", offset = {x=0,y=0}, instance_type = 'CARD', major = G.ROOM_ATTACH, bond = 'Weak'}
                }
                new_ad.alignment.offset.x = (pseudorandom('ad_x_offset')-0.5)*16
                new_ad.alignment.offset.y = (pseudorandom('ad_y_offset')-0.5)*9
                new_ad.config.id = G.GAME.hotpot_total_ads
                new_ad.config.key = ad_to_use
                new_ad.config.scale = ad_scale
                new_ad.config.tutorial = tutorial_ad
                G.GAME.hotpot_ads[#G.GAME.hotpot_ads+1] = new_ad
            return true end}))
        end
    end
    if number_of_ads > 0 then
        for i=1, #G.jokers.cards do
            local effects = eval_card(G.jokers.cards[i], {cardarea = G.jokers, create_ad = number_of_ads})
            if effects.jokers then
                card_eval_status_text(G.jokers.cards[i], 'jokers', nil, nil, nil, effects.jokers)
            end
        end
    end
end


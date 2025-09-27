
PissDrawer = {
    shop_scale = 0.85
}
PissDrawer.Shop = {}

SMODS.Atlas({
    key = 'pissdrawer_shop',
    path = 'Pissdrawer/shop_buttons.png',
    px = 66,
    py = 66
})

SMODS.Atlas({
    key = 'pissdrawer_shop_icons',
    path = 'Pissdrawer/shop_icons.png',
    px = 36,
    py = 36
})

SMODS.Atlas({
    key = 'pissdrawer_shop_sign_currency',
    path = 'Pissdrawer/shop_sign_currency.png',
    px = 113,
    py = 57,
    frames = 4,
    atlas_table = 'ANIMATION_ATLAS'
})

SMODS.Atlas({
    key = 'pissdrawer_shop_sign_training',
    path = 'Pissdrawer/shop_sign_training.png',
    px = 113,
    py = 57,
    frames = 4,
    atlas_table = 'ANIMATION_ATLAS'
})

local pissdrawer_cardarea_align_cards = CardArea.align_cards
function CardArea:align_cards()
    pissdrawer_cardarea_align_cards(self)
    if self.config.hotpot_shop then 
        for _, card in ipairs(self.cards or {}) do
            if not card.pissdrawer then
                card.pissdrawer = {original_scale = card.T.scale, original_VT_scale = card.VT.scale}
                card.T.scale = card.T.scale * PissDrawer.shop_scale
                card.VT.scale = card.VT.scale * PissDrawer.shop_scale
            end
        end
    else
         for _, card in ipairs(self.cards or {}) do
            if card.pissdrawer then
                card.T.scale = card.pissdrawer.original_scale
                card.VT.scale = card.pissdrawer.original_VT_scale
                card.pissdrawer = nil
            end
        end
    end
end

function PissDrawer.Shop.currency_node(args)
    assert(type(args) == 'table', 'No table provided to shop_currency_node')

    return {n=G.UIT.C, config = {align = 'cm', minh = 0.6, minw = 2, colour = G.C.DYN_UI.BOSS_MAIN, r = 0.1}, nodes = {
                {n=G.UIT.R, config = {align='cm'}, nodes = {
                    {n=G.UIT.O, config={object = DynaText({string = {{ref_table = args.ref_table or G.GAME, ref_value = args.ref_value, prefix = args.symbol}},
                        maxw = 2, colours = {args.colour}, font = args.font, shadow = true, spacing = 2, bump = not args.no_bump, scale = 0.5})}}
                }}
            }}
end

function PissDrawer.Shop.currency_display()
    return {n=G.UIT.R, config = {align = 'cm', colour = G.C.L_BLACK, r = 0.1, padding = 0.1}, nodes = {
                PissDrawer.Shop.currency_node({
                    symbol = localize('$'), colour = G.C.GOLD, ref_value = 'dollars', no_bump = true
                }),
                PissDrawer.Shop.currency_node({
                    symbol = '$', font = SMODS.Fonts.hpot_plincoin, colour = SMODS.Gradients["hpot_plincoin"], ref_value = 'plincoins'
                }),
                PissDrawer.Shop.currency_node({
                    symbol = '£', font = SMODS.Fonts.hpot_plincoin, colour = SMODS.Gradients["hpot_advert"], ref_value = 'cryptocurrency'
                }),
                PissDrawer.Shop.currency_node({
                    symbol = localize('hotpot_reforge_sparks'), font = SMODS.Fonts.hpot_plincoin, colour = G.C.BLUE, ref_value = 'spark_points', no_bump = true
                }),
                PissDrawer.Shop.currency_node({
                    symbol = localize('hotpot_reforge_credits'), font = SMODS.Fonts.hpot_plincoin, colour = G.C.PURPLE, ref_value = 'TNameCredits', ref_table = G.PROFILES[G.SETTINGS.profile], no_bump = true
                }),
                {n=G.UIT.C, config = {align = 'cm', minh = 0.6, minw = 0.6, colour = G.C.DYN_UI.BOSS_MAIN, r = 0.1, padding = 0.05, hover = true, button = 'open_exchange', button_dist = 0.1}, nodes = {
                    {n=G.UIT.O, config = {object = Sprite(0, 0, 0.4, 0.4, G.ASSET_ATLAS['hpot_pissdrawer_shop_icons'], { x = 1, y = 0 })}},
                }}
            }}
end

function PissDrawer.Shop.tab_button(args)
    assert(type(args) == 'table', 'No table provided to shop_tab_button')


    return 
        {n=G.UIT.C, config = {align = 'bm'}, nodes = {
            {n=G.UIT.R, config = {align = 'tl', padding = 0.1, r = 0.1, colour = G.C.DYN_UI.MAIN, minh = 0.75, hover = true, func = 'shop_tab_active', button = 'toggle_shop_tab', destination = args.destination, id = 'hotpot_shop_tab_'..args.destination}, nodes = {
                {n=G.UIT.R, config = {align = 'cl'}, nodes = {
                    {n=G.UIT.O, config = {object = Sprite(0, 0, 0.4, 0.4, G.ASSET_ATLAS[args.atlas or 'hpot_jtem_pkg'], { x = args.x or 0, y = args.y or 0 })}},
                    {n=G.UIT.T, config = {text= args.label or ' no label', colour =G.C.WHITE, scale = 0.35, shadow = true}},
                }}
            }},
        }}
end

G.FUNCS.shop_tab_active = function(e)
    if e.config.id == PissDrawer.Shop.active_tab then
        e.config.colour = lighten(G.C.DYN_UI.MAIN, 0.2) 
        if e.config.minh ~= 1.1 then
            e.config.minh = 1.1
            e.UIBox:recalculate()
            e.UIBox:recalculate()
        end
    else
        e.config.colour = G.C.DYN_UI.BOSS_MAIN
        if e.config.minh ~= 0.75 then
            e.config.minh = 0.75
            e.UIBox:recalculate()
            e.UIBox:recalculate()
        end
    end
end

G.FUNCS.toggle_shop_tab = function(e)
    PissDrawer.Shop.active_tab = e.config.id
    G.FUNCS[e.config.destination]()
end

G.FUNCS.open_exchange = function(e)
    print('open currency exchange page')
    PissDrawer.Shop.change_shop_sign("hpot_pissdrawer_shop_sign_currency")
end

PissDrawer.Shop.change_shop_sign = function(atlas, sound)
    local sign_sprite = G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object
    ease_background_colour_blind(G.STATES.SHOP)
    G.HP_JTEM_DELIVERY_VISIBLE = nil
    simple_add_event(function()
        sign_sprite.pinch.y = true
        delay(0.5)
        simple_add_event(function()
            sign_sprite.atlas = G.ANIMATION_ATLAS[atlas]
            sign_sprite.pinch.y = false
            return true
        end)
        return true
    end, { trigger = "after", delay = 0 })
    if type(sound) ~= 'table' then
        sound = {key = sound}
    end
    play_sound(sound.key or "hpot_sfx_whistleup", sound.percent or nil, sound.volume or 0.25)
end

PissDrawer.Shop.change_shop_panel = function(shop_ui, pre, post, areas)
    local main_shop_body = G.shop:get_UIE_by_ID('main_shop_body')
    main_shop_body:remove()
    if pre then pre() end
        main_shop_body.UIBox:add_child(shop_ui(), main_shop_body)
    if post then post(areas) end
    main_shop_body.UIBox:recalculate()
end

G.FUNCS.return_to_shop = function()
    PissDrawer.Shop.change_shop_sign("shop_sign")
    PissDrawer.Shop.change_shop_panel(PissDrawer.Shop.main_shop, PissDrawer.Shop.create_shop_areas, PissDrawer.Shop.reload_shop_areas, PissDrawer.Shop.area_keys.shop)
end

G.FUNCS.hotpot_pissdrawer_toggle_training = function()
    PissDrawer.Shop.change_shop_sign("hpot_pissdrawer_shop_sign_training")
    PissDrawer.Shop.change_shop_panel(G.UIDEF.hotpot_pd_training_section, PissDrawer.Shop.create_training_areas, PissDrawer.Shop.reload_shop_areas, PissDrawer.Shop.area_keys.training)
    print('not yet implemented')
end

local shop = G.UIDEF.shop
function G.UIDEF.shop()
    local ret = shop()
    PissDrawer.Shop.create_shop_areas()
    PissDrawer.Shop.active_tab = 'hotpot_shop_tab_return_to_shop'
    return {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
                {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                    -- Buttons across top of shop to swtich between different shop areas
                    {n=G.UIT.R, config = {align = 'bl', minh = 0.8, colour = G.C.CLEAR, padding = -0.2}, nodes = {
                        {n=G.UIT.B, config = {w = 0.75, h=0.1}},
                        PissDrawer.Shop.tab_button({
                            atlas = 'hpot_pissdrawer_shop_icons', destination = 'return_to_shop', label = ' Shop'
                        }),
                        {n=G.UIT.B, config = {w = 0.55, h=0.1}},
                        PissDrawer.Shop.tab_button({
                            atlas = 'hpot_jtem_pkg', destination = 'hotpot_jtem_toggle_delivery', label = ' Deliveries'
                        }),
                        {n=G.UIT.B, config = {w = 0.55, h=0.1}},
                        PissDrawer.Shop.tab_button({
                            atlas = 'hpot_tname_shop_reforge', destination = 'hotpot_tname_toggle_reforge', label = ' Reforge'
                        }),
                        {n=G.UIT.B, config = {w = 0.55, h=0.1}},
                        PissDrawer.Shop.tab_button({
                            atlas = 'hpot_horsechicot_market', destination = 'hotpot_horsechicot_toggle_market', label = ' Black Market'
                        }),
                        {n=G.UIT.B, config = {w = 0.55, h=0.1}},
                        PissDrawer.Shop.tab_button({
                            atlas = 'hpot_pissdrawer_shop_icons', x = 2, destination = 'hotpot_pissdrawer_toggle_training', label = ' Training'
                        }),
                    }},
                    -- Main shop nodes
                    {n=G.UIT.R, config = {align = 'cm', colour = G.C.DYN_UI.MAIN, padding = 0.08, r = 0.1}, nodes = {
                        {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                            -- Currency container
                            PissDrawer.Shop.currency_display(),
                            -- spacer
                            {n=G.UIT.R, config={minh = 0.2}},
                            -- Top shop row
                            {n=G.UIT.R, config = {id = 'main_shop_body', align = 'cm'}, nodes = {
                                PissDrawer.Shop.main_shop()
                            }},
                            {n=G.UIT.R, config={minh = 0.5}},
                        }},
                    }},
                }},
            }}
    end

function PissDrawer.Shop.main_shop()
    return 
    {n=G.UIT.C, nodes = {
        {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                {n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 1.8, minh = 1.3, r=0.15,colour = G.C.RED, one_press = true, button = 'toggle_shop', hover = true,shadow = true}, nodes = {
                {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                    {n=G.UIT.T, config={text = localize('b_next_round_1'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                    {n=G.UIT.T, config={text = localize('b_next_round_2'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                    }}   
                }},              
                }},
                {n=G.UIT.R, config={align = "cm", minw = 1.8, minh = 1.3, r=0.15,colour = G.C.GREEN, button = 'reroll_shop', func = 'can_reroll', hover = true,shadow = true}, nodes = {
                {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                    {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                    {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                    }},
                    {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                    {n=G.UIT.T, config={text = localize('$'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                    {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                    }}
                }}
                }},                                    
            }},
            {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.0}, nodes={
                {n=G.UIT.O, config={object = G.shop_jokers}},
            }},
            {n=G.UIT.C, config = {align='cm', padding = 0.1}, nodes = {
                {n=G.UIT.R, config={align = "cm", minw = 0.5, maxw = 0.7, minh = 0.8, r=0.15,colour = G.C.CLEAR}, nodes = {
                    {n=G.UIT.O, config = {object = Sprite(0, 0, 0.9, 0.9, G.ASSET_ATLAS['hpot_pissdrawer_shop'], { x = 0, y = 0 }), shadow = true, hover = true, button = 'show_plinko', button_dist = 0.63}},
                }},
                
                {n=G.UIT.R, config={align = "cm", minw = 0.5, maxw = 0.7, minh = 0.8, r=0.15,colour = G.C.CLEAR}, nodes = {
                    {n=G.UIT.O, config = {object = Sprite(0, 0, 0.9, 0.9, G.ASSET_ATLAS['hpot_pissdrawer_shop'], { x = 1, y = 0 }), shadow = true, hover = true, button = 'show_wheel', button_dist = 0.63}},
                }},
                
                {n=G.UIT.R, config={align = "cm", minw = 0.5, maxw = 0.7, minh = 0.8, r=0.15,colour = G.C.CLEAR}, nodes = {
                    {n=G.UIT.O, config = {object = Sprite(0, 0, 0.9, 0.9, G.ASSET_ATLAS['hpot_pissdrawer_shop'], { x = 2, y = 0 }), shadow = true, hover = true, button = 'show_nursery', button_dist = 0.63}},
                }},
            }}
        }},
        -- spacer
        {n=G.UIT.R, config={minh = 0.1}},
        -- bottom shop row
        {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
            {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.shop_vouchers.T.h+0.4}, nodes={
                    {n=G.UIT.T, config={text = localize{type = 'variable', key = 'ante_x_voucher', vars = {G.GAME.round_resets.ante}}, scale = 0.45, colour = G.C.L_BLACK, vert = true}},
                    {n=G.UIT.O, config={object = G.shop_vouchers}},
                }},
            }},
            {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                {n=G.UIT.O, config={object = G.shop_booster}},
            }},
        }}
    }} 
end

function PissDrawer.Shop.delivery_shop()
    return 
    {n=G.UIT.C, nodes = {
        PissDrawer.Shop.help_button('delivery_help'),
        {n=G.UIT.R, config = {align = 'cm', padding = 0.05}, nodes = {
            {n=G.UIT.C, config = {padding = 0.15, colour = G.C.L_BLACK, r = 0.2, emboss = 0.05, align = "tm" }, nodes = {
                {n=G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.BLACK}, nodes = {
                    {n=G.UIT.R, config = {align = "cm"}, nodes = {
                        {n=G.UIT.T, config = { text = localize("hpot_delivery_queue"), scale = 0.45, colour = G.C.L_BLACK }}
                    }},
                    {n=G.UIT.R, nodes = {
                        {n=G.UIT.B, config = {w = 0.4, h = 1.2}}
                    }},
                    {n=G.UIT.R, nodes = {
                        {n=G.UIT.O, config = {object = G.hp_jtem_delivery_queue}},
                    }},
                }}
            }},
            {n=G.UIT.C, config = { padding = 0.15, colour = G.C.L_BLACK, r = 0.2, emboss = 0.05, align = "tm" }, nodes = {
                {n=G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.BLACK}, nodes = {
                    {n=G.UIT.R, config = {minw = 0.5, align = "cm"}, nodes = {
                        {n=G.UIT.T, config = { text = localize("hpot_special_deals"), scale = 0.45, colour = G.C.L_BLACK }}
                    }},
                    {n=G.UIT.R, nodes = {
                        {n=G.UIT.B, config = {w = 0, h = 1}}
                    }},
                    {n=G.UIT.R, nodes = {
                        {n=G.UIT.O, config = {object = G.hp_jtem_delivery_special_deals}},
                    }},
                }}
            }}
        }},
        {n=G.UIT.R, config = {minh = 2, align = 'tr', padding = 0.05}, nodes = {
            {n=G.UIT.R, config = {minw = 6.7, align = 'cm'}, nodes = {
                {n=G.UIT.C, config = { colour = G.C.RED, align = "cm", padding = 0.05, r = 0.1, minw = 2.8, minh = 1, shadow = true,
                 button = 'hotpot_jtem_delivery_request_item', func = "hp_jtem_can_request_joker", hover = true }, nodes = {
                    G.GAME.hp_jtem_should_allow_custom_order and 
                    {n=G.UIT.C, config = {padding = 0.05}, nodes = {
                        {n=G.UIT.R, config = { align = "cm" }, nodes = {
                            {n=G.UIT.T, config = { text = localize("hotpot_request_joker_line_1"), scale = 0.5, colour = G.C.WHITE}},
                        }},
                        {n=G.UIT.R, config = { align = "cm" }, nodes = {
                            {n=G.UIT.T, config = { text = localize("hotpot_request_joker_line_3"), scale = 0.35, colour = G.C.WHITE}},
                        }}
                    }} or {n=G.UIT.C, config = {padding = 0.05}, nodes = {
                        {n=G.UIT.R, config = { align = "cm" }, nodes = {
                            {n=G.UIT.T, config = { text = localize("hotpot_request_joker_line_2"), scale = 0.5, colour = G.C.WHITE}},
                        }},
                        {n=G.UIT.R, config = { align = "cm" }, nodes = {
                            {n=G.UIT.T, config = { text = localize({set = 'Voucher', key = 'v_hpot_right_at_your_door', type = 'name_text'}), scale = 0.4, colour = G.C.WHITE}},
                        }}
                    }}
                }}
            }}
        }}
    }}
end

G.FUNCS.update_modification_info = function(e)
    for _, child in ipairs(e.children) do
        child.children[1].config.text = ''
    end     
    if G.reforge_area.cards[1] and get_modification(G.reforge_area.cards[1]) then
        local mod = get_modification(G.reforge_area.cards[1])
        e.children[1].children[1].config.text = localize({set = 'Modification', key = mod, type = 'name_text'})
        e.children[1].children[1].config.colour = HPTN.Modifications[mod].morality == 'GOOD' and G.C.GREEN or G.C.RED
        local desc = localize({set = 'Modification', key = mod, type = 'raw_descriptions'})
        for i, line in ipairs(desc) do
            if e.children[i+1] then
                e.children[i+1].children[1].config.text = desc[i]
            end
        end    
    end
    e.UIBox:recalculate()
end

function PissDrawer.Shop.reforge_shop()
    local name = {}
    if G.reforge_area.cards[1] then
        localize({desc_nodes = name, set = 'Modification', key = get_modification(G.reforge_area.cards[1]), type = 'name'})
    end
    return 
    {n=G.UIT.C, config = {minh = 10, align = 'tm'}, nodes = {
        PissDrawer.Shop.help_button('reforge_help'),
        {n=G.UIT.R, config = {align = 'cm', padding = 0.05}, nodes = {
            {n=G.UIT.C, config = {align = 'cm', minw = 4.5, colour = G.C.CLEAR, padding = 0.1, func = 'update_modification_info'}, nodes = {
                G.reforge_area.cards[1] and name or nil,
                {n=G.UIT.R, config = {align = 'cm', padding = 0.2}, nodes = {
                    {n=G.UIT.T, config = {text = '', scale = 0.8, colour = G.C.WHITE}}
                }},
                {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                    {n=G.UIT.T, config = {text = '', scale = 0.35, colour = G.C.WHITE}}
                }},
                {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                    {n=G.UIT.T, config = {text = '', scale = 0.35, colour = G.C.WHITE}}
                }},
                
            }},
            {n=G.UIT.C, config = {minw = 0.3}},
            {n=G.UIT.C, config = {align = 'cm'}, nodes = {
                
                {n=G.UIT.C, config = {padding = 0.15, colour = G.C.L_BLACK, r = 0.2, emboss = 0.05, align = "tm", minw = 0.5 }, nodes = {
                    {n=G.UIT.C, config = {align = "cm", padding = 0.2, r = 0.2, colour = G.C.BLACK}, nodes = {
                        {n=G.UIT.R, config = {align = "cm"}, nodes = {
                            {n = G.UIT.T, config = {text = localize("k_place_card_text"), colour = G.C.GREY, scale = 0.4, align = "tm"}},
                        }},
                        {n=G.UIT.R, config = {align = 'cm'}, nodes = {
                            {n=G.UIT.O, config = {object = G.reforge_area}},
                        }},
                    }}
                }},
            }}
        }},
        {n=G.UIT.R, config = {align = 'cm'}, nodes = {
            {n=G.UIT.C, config = {padding = -0.1}, nodes = {
                {n=G.UIT.R, config = {padding = 0.2, colour = G.C.CLEAR, align = 'cm'}, nodes = {
                    PissDrawer.Shop.reforge_button({currency = 'dollars'}),
                    PissDrawer.Shop.reforge_button({currency = 'credits', font = SMODS.Fonts.hpot_plincoin,}),
                    PissDrawer.Shop.reforge_button({currency = 'sparks', font = SMODS.Fonts.hpot_plincoin,}),
                }},
                {n=G.UIT.R, config = {padding = 0.2, colour = G.C.CLEAR, align = 'cm'}, nodes = {
                    PissDrawer.Shop.reforge_button({currency = 'plincoins', font = SMODS.Fonts.hpot_plincoin,}),
                    PissDrawer.Shop.reforge_button({currency = 'cryptocurrency', font = SMODS.Fonts.hpot_plincoin,}),
                }}
            }}
        }}
    }}
end

PissDrawer.Shop.reforge_button = function(args)
    return
    {n = G.UIT.C, config = {minw = 2, align = 'cm', r=0.1, padding = 0.1, emboss = 0.1, colour = args.colour or G.C.L_BLACK, currency = args.currency, button = 'reforge_with_'..args.currency, func = 'can_reforge', hover = true, button_dist = 0.5}, nodes = {
        {n=G.UIT.C, config = {padding = 0.1}, nodes = {
            {n=G.UIT.R, nodes = {
                {n=G.UIT.O, config={id = 'text_'..args.currency, object = DynaText({string = {{ref_table = args.ref_table or G.GAME, ref_value = 'cost_'..args.currency, prefix = localize('hotpot_reforge_'..args.currency)}},
                        maxw = 2, colours = {args.text_colour}, font = args.font, shadow = true, spacing = 1, scale = 0.5})}}
            }}
        }}
    }}
end


PissDrawer.Shop.help_button = function(func)
    return
    {n=G.UIT.R, config = {align = 'br', padding = -0.3}, nodes = {
        {n=G.UIT.C, config = {align = 'tm', colour = G.C.RED, r = 0.8, padding = 0.025, minw = 0.5, minh = 0.6, emboss = 0.05, hover = true, button = func, button_dist = 0.1}, nodes = {
            {n=G.UIT.T, config = {text = '?', colour = G.C.WHITE, scale = 0.35}}
        }},
        {n=G.UIT.C, config = {minw = 0.85}}
    }}
end

G.FUNCS.delivery_help = function()
    print('show delivery help screen')
end

G.FUNCS.reforge_help = function()
    print('show reforge help screen')
end

G.FUNCS.black_market_help = function()
    print('show black market help screen')
end

G.FUNCS.training_help = function()
    G.FUNCS.hotpot_info{menu_type = "hotpot_training"}
end

PissDrawer.Shop.area_keys = {}

PissDrawer.Shop.area_keys.shop = {
    'shop_jokers', 'shop_vouchers', 'shop_booster'
}
PissDrawer.Shop.area_keys.delivery = {
    'hp_jtem_delivery_queue', 'hp_jtem_delivery_special_deals'
}
PissDrawer.Shop.area_keys.reforge = {
    'reforge_area'
}
PissDrawer.Shop.area_keys.black_market = {
    'market_jokers'
}
PissDrawer.Shop.area_keys.training = {
    'train_jokers'
}

local car = CardArea.remove
function CardArea:remove()
    for _, tab in pairs(PissDrawer.Shop.area_keys) do
        for _, key in ipairs(tab) do
            if self == G[key] then PissDrawer.Shop['load_'..key] = self:save() end
        end
    end
    car(self)
end


function PissDrawer.Shop.reload_shop_areas(keys)
    for _, key in ipairs(keys) do
        if PissDrawer.Shop['load_'..key] then
            G[key]:load(PissDrawer.Shop['load_'..key])
            for k, v in ipairs(G[key].cards) do
                if key == 'hp_jtem_delivery_queue' then
                    local temp_str = { str = (v.ability.hp_delivery_obj.rounds_passed .. "/" .. v.ability.hp_delivery_obj.rounds_total) }
                    local args = generate_currency_string_args(v.ability.hp_jtem_currency_bought)
                    hpot_jtem_create_delivery_boxes(v, { { ref_table = temp_str, ref_value = 'str' } }, args)
                elseif key == 'hp_jtem_delivery_special_deals' then
                    local args = generate_currency_string_args(v.ability.hp_jtem_currency_bought)
                    hpot_jtem_create_special_deal_boxes(v, {{prefix = args.symbol, ref_table = v.ability, ref_value = "hp_jtem_currency_bought_value"}}, args)
                elseif key == 'reforge_area' or key == 'train_jokers' then
                elseif key == 'market_jokers' then
                    create_market_card_ui(v)
                else
                    create_shop_card_ui(v)
                end
                if v.ability.consumeable then v:start_materialize() end
            end
            PissDrawer.Shop['load_'..key] = nil
        end
    end
end

function PissDrawer.Shop.create_shop_areas()
    G.shop_jokers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      math.min(G.GAME.shop.joker_max*1.02*G.CARD_W,3.6*G.CARD_W),
      1.15*G.CARD_H * PissDrawer.shop_scale, 
      {card_limit = G.GAME.shop.joker_max, type = 'shop', highlight_limit = 1, negative_info = true, hotpot_shop = true})


     G.shop_vouchers = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        G.GAME.ortalab.vouchers.mythos_shop_slot and 1.5*G.CARD_W or 2.1*G.CARD_W,
        1.05*G.CARD_H * PissDrawer.shop_scale, 
        {card_limit = 1, type = 'shop', highlight_limit = 1, hotpot_shop = true})

    G.shop_booster = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        G.GAME.ortalab.vouchers.mythos_shop_slot and 2.0*G.CARD_W or 2.4*G.CARD_W,
        1.15*G.CARD_H * PissDrawer.shop_scale, 
        {card_limit = 2, type = 'shop', highlight_limit = 1, card_w = 1.22*G.CARD_W, hotpot_shop = true})
end

function PissDrawer.Shop.create_reforge_areas()
    G.reforge_area = CardArea(
        0, 0, G.CARD_W, G.CARD_H,
        {card_limit = 1, type = "shop", highlight_limit = 1, hotpot_shop = true}
    )
end

function PissDrawer.Shop.create_training_areas()
    G.train_jokers = CardArea(
        G.hand.T.x + 0,
        G.hand.T.y + G.ROOM.T.y + 9,
        math.min(1.02 * G.CARD_W, 4.08 * G.CARD_W),
        1.05 * G.CARD_H,
        { card_limit = 1, type = 'shop', highlight_limit = 1, negative_info = true, hotpot_shop = true }
    )
end

function PissDrawer.Shop.create_black_market_areas()
    G.market_jokers = CardArea(
      G.hand.T.x + 0,
      G.hand.T.y + G.ROOM.T.y + 9,
      math.min(G.GAME.shop.market_joker_max * 1.02 * G.CARD_W, 4.08 * G.CARD_W),
      1.05 * G.CARD_H,
      { card_limit = G.GAME.shop.market_joker_max, type = 'shop', highlight_limit = 1, negative_info = true, hotpot_shop = true })
end

SMODS.draw_ignore_keys.hpot_reforge_button = true
SMODS.draw_ignore_keys.hpot_move_to_train = true

function PissDrawer.Shop.create_delivery_order_button(card)
    if card.highlighted then
        local t2 = {n=G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes ={
            {n=G.UIT.C, config = { ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, 
                shadow = true, r = 0.08, minh = 0.94, func = 'hp_jtem_can_order', one_press = true, button = 'hp_jtem_order', hover = true }, nodes = {
                {n=G.UIT.T, config = { text = localize('hotpot_delivery_order'), colour = G.C.WHITE, scale = 0.5 } }
            }}
        }}
    
        card.children.hp_jtem_price_side = UIBox {
            definition = t2,
            config = {
                align = "bm",
                offset = { x = 0, y = -0.34 },
                parent = card
            }
        }
    elseif card.children.hp_jtem_price_side then
        card.children.hp_jtem_price_side:remove() 
    end
end

function PissDrawer.Shop.create_delivery_refund_button(card)
    if card.highlighted then
        local t2 = {n=G.UIT.ROOT, config = {colour = G.C.CLEAR}, nodes ={
            {n=G.UIT.C, config = { ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.RED, 
                shadow = true, r = 0.08, minh = 0.94, func = 'hp_jtem_can_cancel', one_press = true, button = 'hp_jtem_cancel', hover = true }, nodes = {
                {n=G.UIT.T, config = { text = localize('hotpot_delivery_order_cancel'), colour = G.C.WHITE, scale = 0.5 } }
            }}
        }}
    
        card.children.hp_jtem_cancel_order = UIBox {
            definition = t2,
            config = {
                align = "bm",
                offset = { x = 0, y = -0.34 },
                parent = card
            }
        }
    elseif card.children.hp_jtem_cancel_order then
        card.children.hp_jtem_cancel_order:remove() 
    end
end

PissDrawer.Shop.delivery_post = function(keys)
    PissDrawer.Shop.reload_shop_areas(keys)
    if not PissDrawer.Shop.delivery_spawn then hotpot_delivery_refresh_card(); PissDrawer.Shop.delivery_spawn = true end
end

PissDrawer.Shop.black_market_post = function(keys)
    PissDrawer.Shop.reload_shop_areas(keys)
    if not PissDrawer.Shop.market_spawn then hotpot_horsechicot_market_section_init_cards(); PissDrawer.Shop.market_spawn = true end
end
    

local pissdrawer_card_highlight = Card.highlight
function Card:highlight(highlighted)
    pissdrawer_card_highlight(self, highlighted)
    if self.area == G.hp_jtem_delivery_special_deals then
        PissDrawer.Shop.create_delivery_order_button(self)
    elseif self.area == G.hp_jtem_delivery_queue then
        PissDrawer.Shop.create_delivery_refund_button(self)
    end
    if not self.highlighted and self.children.hpot_reforge_button then
        self.children.hpot_reforge_button:remove()
        self.children.hpot_reforge_button = nil
    end
    if self.highlighted and PissDrawer.Shop.active_tab == 'hotpot_shop_tab_hotpot_tname_toggle_reforge' and self.ability.set == 'Joker' then
        self.children.hpot_reforge_button = UIBox{
            definition = PissDrawer.Shop.reforge_emplace(self),
            config = {
            align = "bmi",
            offset ={x=0,y=0.5},
            parent = self
            }
        }
    end
    if not self.highlighted and self.children.hpot_move_to_train then
        self.children.hpot_move_to_train:remove()
        self.children.hpot_move_to_train = nil
    end
    if self.highlighted and PissDrawer.Shop.active_tab == 'hotpot_shop_tab_hotpot_pissdrawer_toggle_training' and self.ability.hp_jtem_mood and self.ability.set == 'Joker' then
        self.children.hpot_move_to_train = UIBox{
            definition = PissDrawer.Shop.training_emplace(self),
            config = {
            align = "bmi",
            offset ={x=0,y=0.5},
            parent = self
            }
        }
    end
end

function PissDrawer.Shop.reforge_emplace(card)
	return 
    {n = G.UIT.R, config = {ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5 * card.T.w - 0.15, maxw = 0.9 * card.T.w - 0.15, minh = 0.4 * card.T.h,
        hover = true, shadow = true, colour = G.C.RED, one_press = true, button = 'reforge_place', func = 'place_return_reforge' }, nodes = {
        {n=G.UIT.R, config={align = 'cm'}, nodes = {{n = G.UIT.T, config = { text = localize('hotpot_go_reforge'), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true }}}}
    }}
end

function PissDrawer.Shop.training_emplace(card)
	return 
    {n = G.UIT.R, config = {ref_table = card, r = 0.08, padding = 0.1, align = "bm", minw = 0.5 * card.T.w - 0.15, maxw = 0.9 * card.T.w - 0.15, minh = 0.4 * card.T.h,
        hover = true, shadow = true, colour = G.C.RED, one_press = true, button = 'training_emplace', func = 'can_emplace_training' }, nodes = {
        {n=G.UIT.R, config={align = 'cm'}, nodes = {{n = G.UIT.T, config = { text = localize('hotpot_go_train'), colour = G.C.UI.TEXT_LIGHT, scale = 0.4, shadow = true }}}}
    }}
end

G.FUNCS.training_emplace = function ()
    if G.jokers and G.jokers.highlighted and #G.jokers.highlighted > 0 then
        local c = G.jokers.highlighted[1]
        HotPotato.draw_card(G.jokers, G.train_jokers, 1, 'up', nil, c ,0)
    end
end

G.FUNCS.training_return = function ()
    if G.train_jokers and G.train_jokers.cards then
        if #G.train_jokers.cards > 0 then
            HotPotato.draw_card(G.train_jokers, G.jokers, 1, 'up', nil, nil ,0)
        end
    end
end

function G.FUNCS.can_emplace_training(e)
    if e.config.ref_table.area == G.jokers then
        e.children[1].config.text = localize('hotpot_go_train')
        if G.reforge_area and G.reforge_area.cards and #G.reforge_area.cards > 0 then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.BLUE
            e.config.button = 'training_emplace'
        end
    else
        e.children[1].config.text = localize('hotpot_leave_train')
        if G.jokers and #G.jokers.cards < G.jokers.config.card_limit then
            e.config.colour = G.C.BLUE
            e.config.button = 'training_return'
        else
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil

        end
    end
end

function PissDrawer.Shop.black_market()
    return 
    {n=G.UIT.C, config = {align = 'tm', minh = 8}, nodes = {
        PissDrawer.Shop.help_button('black_market_help'),
        {n = G.UIT.R, config = { align = "cm", padding = 0.05 }, nodes = {
            {n = G.UIT.C, config = { align = "cm", padding = 0.1 }, nodes = {
                {n = G.UIT.R, config = { align = "cm", minw = 2.5, minh = 1.4, r = 0.15, colour = SMODS.Gradients.hpot_advert, button = 'reroll_market', func = 'can_reroll_market', hover = true, shadow = true }, nodes = {
                    {n = G.UIT.R, config = { align = "cm", padding = 0.07, focus_args = { button = 'x', orientation = 'cr' }, func = 'set_button_pip' }, nodes = {
                        {n = G.UIT.R, config = { align = "cm", maxw = 1.3 }, nodes = {
                            {n = G.UIT.T, config = { text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true }},
                        }},
                        {n = G.UIT.R, config = { align = "cm", maxw = 1.3, minw = 1 }, nodes = {
                            {n = G.UIT.T, config = { text = "£", font = SMODS.Fonts['hpot_plincoin'], scale = 0.7, colour = G.C.WHITE, shadow = true }},
                            {n = G.UIT.T, config = { ref_table = G.GAME.current_round, ref_value = 'market_reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true }},
                        }}
                    }}
                }},
                {n = G.UIT.R, config = { align = "cm", minw = 2.5, minh = 1.4, r = 0.15, colour = SMODS.Gradients.hpot_advert, button = 'harvest_market', func = 'can_harvest_market', hover = true, shadow = true }, nodes = {
                    {n = G.UIT.R, config = { align = "cm", padding = 0.07, focus_args = { button = 'x', orientation = 'cr' }, func = 'set_button_pip' }, nodes = {
                        {n = G.UIT.R, config = { align = "cm", maxw = 1.3 }, nodes = {
                            {n = G.UIT.T, config = { text = localize('k_harvest'), scale = 0.6, colour = G.C.WHITE, shadow = true }},
                        }},
                        {n = G.UIT.R, config = { align = "cm", maxw = 1.3, minw = 1 }, nodes = {
                            {n = G.UIT.T, config = { text = "£", font = SMODS.Fonts['hpot_plincoin'], scale = 0.7, colour = G.C.WHITE, shadow = true }},
                            {n = G.UIT.T, config = { ref_table = G, ref_value = 'harvest_cost', scale = 0.75, colour = G.C.WHITE, shadow = true }},
                        }}
                    }}
                }},
            }},
            {n = G.UIT.C, config = { align = "cm", padding = 0.1, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2 }, nodes = {
                {n = G.UIT.O, config = { object = G.market_jokers }},
            }},
        }}
    }}
end
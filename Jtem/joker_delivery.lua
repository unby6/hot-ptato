-- SHOP Button for Delivery
-- this is patched into the code via jtem_shop_ui.toml
function G.UIDEF.hotpot_jtem_delivery_section()
end
-- like in React, I made stuff I reuse into buttons
function G.UIDEF.hotpot_jtem_shop_delivery_btn_component(btntype)
    local btnx, localized
    if btntype == "to_delivery" or not btntype then
        localized = "hotpot_delivery"
        btnx = 0
    elseif btntype == "back_from_delivery" then
        localized = "hotpot_delivery_back"
        btnx = 1
    end
    return {
        n = G.UIT.R,
        config = {colour = G.C.RED, padding = 0.05, r = 0.02, w = 0.1, h = 0.1, shadow = true, button = 'hotpot_jtem_toggle_delivery', hover = true},
        nodes = {
            {
                n = G.UIT.R,
                config = {  },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = Sprite(0,0, 0.5,0.5, G.ASSET_ATLAS['hpot_jtem_pkg'], {x=btnx,y=0})
                        }
                    },
                }
            },
            {
                n = G.UIT.R,
                config = { },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = { text = localize(localized), scale = 0.5, colour = G.C.WHITE, opposite_vert = true}
                    },
                }
            },
        }
    }
end
function G.UIDEF.hotpot_jtem_shop_delivery_btn()
    return {
        n = G.UIT.C,
        config = { padding = 0.1, r = 0.05, w = 0.1, h = 0.1},
        nodes = {
            G.UIDEF.hotpot_jtem_shop_delivery_btn_component(),
            {
                n = G.UIT.R,
                nodes = {
                    {
                        n = G.UIT.B,
                        config = {
                            h = 12,
                            w = 0.1
                        }
                    }
                }
            },
            G.UIDEF.hotpot_jtem_shop_delivery_btn_component("back_from_delivery"),
        }
    }
end

function G.UIDEF.hotpot_jtem_shop_delivery_section()
    return 
    {
        n = G.UIT.R,
        nodes = {
            {
                n = G.UIT.B,
                config = {
                    h = 6,
                    w = 0.1
                }
            }
        }
    },
    {
        n = G.UIT.R,
        nodes = {
            {
                n = G.UIT.C,
                config = { padding = 0.1 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = {colour = G.C.RED, align = "cm", padding = 0.05, r = 0.02, minw = 3.5, minh = 0.8, shadow = true, button = 'hotpot_jtem_delivery_request_item', hover = true},
                        nodes = {
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize("hotpot_request_joker_line_1"), scale = 0.5, colour = G.C.WHITE,}
                                    },
                                }
                            },
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize("hotpot_request_joker_line_2"), scale = 0.3, colour = G.C.WHITE,}
                                    },
                                }
                            },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = {colour = G.C.RED, align = "cm", padding = 0.05, r = 0.02, minw = 3.5, minh = 0.8, shadow = true, button = 'hotpot_jtem_delivery_request_item', hover = true},
                        nodes = {
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize("hotpot_request_joker_line_1"), scale = 0.5, colour = G.C.WHITE,}
                                    },
                                }
                            },
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize("hotpot_request_joker_line_2"), scale = 0.3, colour = G.C.WHITE,}
                                    },
                                }
                            },
                        }
                    },
                }
            },
            {
                n = G.UIT.O,
                config = {
                    object = G.hp_jtem_delivery_queue,
                }
            }
        }
    },
    {
        n = G.UIT.R,
        nodes = {
            {
                n = G.UIT.C,
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = G.hp_jtem_delivery_special_deals,
                        }
                    }
                }
            },
        }
    }
end

-- literally copied from price boxes
function hpot_jtem_create_price_boxes(card, price_text, price_colour)
    G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = 0.43,
    blocking = false,
    blockable = false,
    func = (function()
        if card.opening then return true end
        local t1 = {
            n=G.UIT.ROOT, config = {minw = 0.6, align = 'tm', colour = darken(G.C.BLACK, 0.2), shadow = true, r = 0.05, padding = 0.05, minh = 1}, nodes={
                {n=G.UIT.R, config={align = "cm", colour = lighten(G.C.BLACK, 0.1), r = 0.1, minw = 1, minh = 0.55, emboss = 0.05, padding = 0.03}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = { unpack(price_text) }, colours = {price_colour or G.C.MONEY},shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
                }}
            }}
        local t2 = card.ability.set == 'Voucher' and {
        n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'can_redeem', one_press = true, button = 'redeem_from_shop', hover = true}, nodes={
            {n=G.UIT.T, config={text = localize('b_redeem'),colour = G.C.WHITE, scale = 0.4}}
        }} or card.ability.set == 'Booster' and {
        n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GREEN, shadow = true, r = 0.08, minh = 0.94, func = 'can_open', one_press = true, button = 'open_booster', hover = true}, nodes={
            {n=G.UIT.T, config={text = localize('b_open'),colour = G.C.WHITE, scale = 0.5}}
        }} or {
        n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, func = 'can_buy', one_press = true, button = 'buy_from_shop', hover = true}, nodes={
            {n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
        }}
        local t3 = {
        n=G.UIT.ROOT, config = {id = 'buy_and_use', ref_table = card, minh = 1.1, padding = 0.1, align = 'cr', colour = G.C.RED, shadow = true, r = 0.08, minw = 1.1, func = 'can_buy_and_use', one_press = true, button = 'buy_from_shop', hover = true, focus_args = {type = 'none'}}, nodes={
            {n=G.UIT.B, config = {w=0.1,h=0.6}},
            {n=G.UIT.C, config = {align = 'cm'}, nodes={
            {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('b_buy'),colour = G.C.WHITE, scale = 0.5}}
            }},
            {n=G.UIT.R, config = {align = 'cm', maxw = 1}, nodes={
                {n=G.UIT.T, config={text = localize('b_and_use'),colour = G.C.WHITE, scale = 0.3}}
            }},
            }} 
        }}
        

        card.children.price = UIBox{
        definition = t1,
        config = {
            align="tm",
            offset = {x=0,y=1.5},
            major = card,
            bond = 'Weak',
            parent = card
            
        }
        }
        --[[

        card.children.buy_button = UIBox{
        definition = t2,
        config = {
            align="bm",
            offset = {x=0,y=-0.3},
            major = card,
            bond = 'Weak',
            parent = card
        }
        }
        if card.ability.consumeable then --and card:can_use_consumeable(true, true)
        card.children.buy_and_use_button = UIBox{
            definition = t3,
            config = {
            align="cr",
            offset = {x=-0.3,y=0},
            major = card,
            bond = 'Weak',
            parent = card
            }
        }
        end
        ]]

        card.children.price.alignment.offset.y = card.ability.set == 'Booster' and 0.5 or 0.38

        return true
    end)
    }))
end
function hotpot_jtem_init_extra_shops_area()
    -- i just copied this from the shop definition lol
    G.hp_jtem_delivery_special_deals = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        5.6*G.CARD_W,
        1.15*G.CARD_H, 
        {card_limit = 5, type = 'shop', highlight_limit = 0, card_w = 1.27*G.CARD_W})
    G.hp_jtem_delivery_queue = CardArea(
        G.hand.T.x+0,
        G.hand.T.y+G.ROOM.T.y + 9,
        3.3*G.CARD_W,
        1.15*G.CARD_H, 
        {card_limit = 2, type = 'shop', highlight_limit = 0, card_w = 1.27*G.CARD_W})
    G.hp_jtem_delivery_queue.cards = G.hp_jtem_delivery_queue.cards or {}
    G.hp_jtem_delivery_special_deals.cards = G.hp_jtem_delivery_special_deals.cards or {}
    G.hp_jtem_delivery_queue.children = G.hp_jtem_delivery_queue.children or {}
    G.hp_jtem_delivery_special_deals.children = G.hp_jtem_delivery_special_deals.children or {}
end
-- destroy all cards in an area, I am too lazy to make a god damn loop damn it
function hotpot_jtem_destroy_all_card_in_an_area(area, nofx)
    if not area or not area.cards then return end
    for _,_c in ipairs(area.cards) do
        
        area:remove_card(_c)
        if nofx then
            _c:remove()
        else
            _c:start_dissolve({G.C.RED},G.SPEEDFACTOR * 1.2)
        end
    end
end

function hotpot_jtem_add_card_to_delivery_queue()
end

local update_shop_hook_to_create_cards = Game.update_shop
function Game:update_shop()
    if not G.HP_SHOP_CREATED_CARDS then

        hotpot_jtem_init_extra_shops_area()
        simple_add_event(function()
            simple_add_event(function()
                for i = 1, 5 do
                    local _c = SMODS.create_card{ area = G.hp_jtem_delivery_special_deals, key = "j_joker", skip_materialize = true, no_edition = true}
                    hpot_jtem_create_price_boxes(_c,{{prefix = localize('$'), ref_table = _c, ref_value = 'sell_cost'}}, G.C.BLUE)
                    G.hp_jtem_delivery_special_deals:emplace(_c)
                end
                for i = 1, 2 do
                    local _c = SMODS.create_card{ area = G.hp_jtem_delivery_queue, key = "j_joker", skip_materialize = true, no_edition = true}
                    G.hp_jtem_delivery_queue:emplace(_c)
                end
                return true
            end)
            return true
        end)
        G.HP_SHOP_CREATED_CARDS = true
            
    end
    return update_shop_hook_to_create_cards(self)
end

-- destroy cards below
local next_round_button_for_delivery_area_destruction = G.FUNCS.toggle_shop
function G.FUNCS.toggle_shop(e)
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_special_deals,true)
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_queue,true)
    G.HP_SHOP_CREATED_CARDS = nil
    return next_round_button_for_delivery_area_destruction(e)
end

function G.FUNCS.hotpot_jtem_delivery_request_item()
end

-- this moves the shop up and down along with slide whistle sound :joy::ok_hand:
function G.FUNCS.hotpot_jtem_toggle_delivery()
    if G.shop.alignment.offset.y == -5.3 then
        G.shop.alignment.offset.y = -20
        G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object.atlas = G.ANIMATION_ATLAS["hpot_jtem_postlatro"] 
        play_sound("hpot_sfx_whistleup",nil, 0.25)
    else
        G.shop.alignment.offset.y = -5.3
        G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object.atlas = G.ANIMATION_ATLAS["shop_sign"]
        play_sound("hpot_sfx_whistledown",nil, 0.25)
    end
end

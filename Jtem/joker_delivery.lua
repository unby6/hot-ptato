-- SHOP Button for Delivery
-- this is patched into the code via jtem_delivery.toml
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
                config = { align = "cm" },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = { text = localize(localized), scale = 0.4, colour = G.C.WHITE, opposite_vert = true}
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
function hpot_jtem_create_delivery_boxes(card, price_text, price_colour)
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
        card.children.price.alignment.offset.y = card.ability.set == 'Booster' and 0.5 or 0.38
        return true
    end)
    }))
end
function hpot_jtem_create_special_deal_boxes(card, price_text, price_colour)
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
                {n=G.UIT.O, config={object = DynaText({string = { unpack(price_text) }, colours = {price_colour or G.C.MONEY},shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5, font = SMODS.Fonts["hpot_plincoin"]})}},
                }}
            }}
            
        local t2 =  {
        n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, func = 'can_buy', one_press = true, button = 'hp_jtem_order', hover = true}, nodes={
            {n=G.UIT.T, config={text = localize('hotpot_delivery_order'),colour = G.C.WHITE, scale = 0.5}}
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
        {card_limit = 5, type = 'shop', highlight_limit = 0, card_w = 1.27*G.CARD_W, lr_padding = 0.1})
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
    for i = #area.cards, 1,-1 do
        local _c = area.cards[i]
        area:remove_card(_c)
        if nofx then
            _c:remove()
        else
            _c:start_dissolve({G.C.RED},G.SPEEDFACTOR * 1.2)
        end
    end
    area.cards = {}
end

local skip_align_card_if_no_card = CardArea.align_cards
function CardArea:align_cards()
    if not self.cards then return end
    return skip_align_card_if_no_card(self)
end

local init_game_object_for_delivery = Game.init_game_object
function Game:init_game_object()
    local r = init_game_object_for_delivery(self)
    r.hp_jtem_delivery_queue = {}
    --[[
        okay so before i get murdered for not documenting my code here's the rundown on the format
        the queue consist of
            key - the key of the card that was queue in delivery
            rounds_passed - rounds waited for delivery
            rounds_total - rounds that you would have to wait in total
            price - cost in case of refunds
            extras - other attributes that should apply to card ability directly, for example eternal, rental
    ]]
    r.hp_jtem_special_offer = {}
    return r
end
function hotpot_jtem_center_to_round_wait(center) -- accept ONLY center object
    local rounds = 2
    if center.set == "Joker" then
        rounds = 24
        if center.rarity == 1 then
            rounds = 3
        elseif center.rarity == 2 then
            rounds = 5
        elseif center.rarity == 3 then
            rounds = 10
        elseif center.rarity == 4 then
            rounds = 24
        end
    elseif center.set == "Spectral" then
        rounds = 6
    end
    -- target: for custom rounds :3
    return rounds
end
function hotpot_jtem_add_card_to_delivery_queue( key )
    if not G.P_CENTERS[key] then return end
    local ct = G.P_CENTERS[key]
    local delivery_table = {
        key = key,
        rounds_passed = 0,
        rounds_total = hotpot_jtem_center_to_round_wait(ct),
        price = ct.cost,
        extras = {}
    }
    -- target patch for custom delivery queue
    G.GAME.hp_jtem_delivery_queue = G.GAME.hp_jtem_delivery_queue or {}
    table.insert(G.GAME.hp_jtem_delivery_queue, delivery_table)
    if G.GAME.hp_jtem_delivery_queue then
        hotpot_delivery_refresh_card()
    end
end

function hotpot_delivery_refresh_card()
    
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_special_deals,true)
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_queue,true)
    for _,_obj in ipairs(G.GAME.hp_jtem_delivery_queue) do
        local temp_str = { str = (_obj.rounds_passed .. "/" .. _obj.rounds_total)}
        local _c = SMODS.create_card{ area = G.hp_jtem_delivery_queue, key = _obj.key, skip_materialize = true, no_edition = true}
        hpot_jtem_create_delivery_boxes(_c,{{ref_table = temp_str, ref_value = 'str'}}, G.C.BLUE)
        
        if _obj.extras then
            for k,v in pairs(_obj.extras) do
                _c[k] = v
            end
        end
        G.hp_jtem_delivery_queue:emplace(_c)
    end
    for i = 1, 5 do
        local _c = SMODS.create_card{ area = G.hp_jtem_delivery_special_deals, key = "j_joker", skip_materialize = true, no_edition = true}
        hpot_jtem_create_special_deal_boxes(_c,{{prefix = "͸", ref_table = _c, ref_value = "cost"}}, G.C.BLUE)
        G.hp_jtem_delivery_special_deals:emplace(_c)
    end
end

local update_shop_hook_to_create_cards = Game.update_shop
function Game:update_shop()
    if not self.HP_SHOP_CREATED_CARDS then
        self.HP_SHOP_CREATED_CARDS = true
        hotpot_jtem_init_extra_shops_area()
        simple_add_event(function()
            simple_add_event(function()
                hotpot_delivery_refresh_card()
                return true
            end)
            return true
        end)
            
    end
    return update_shop_hook_to_create_cards(self)
end
local cash_out_hook_for_refresh_card = G.FUNCS.cash_out
function G.FUNCS.cash_out(e)
    local x = cash_out_hook_for_refresh_card(e)
    simple_add_event(function()
        hotpot_delivery_refresh_card()
        return true
    end)
    return x
end
local update_new_round_to_reset_card = Game.update_new_round
function Game:update_new_round()
    -- this one is for creating delivery cards
    if not self.HP_SHOP_CREATED_CARDS then
        self.HP_SHOP_CREATED_CARDS = nil   
    end
    return update_new_round_to_reset_card(self)
end

-- calculate delivery
function hotpot_jtem_calculate_deliveries()
    
    G.GAME.hp_jtem_delivery_queue = G.GAME.hp_jtem_delivery_queue or {}
    for _,delivery in pairs(G.GAME.hp_jtem_delivery_queue) do
        delivery.rounds_total = delivery.rounds_total or 999 -- just in case an order was badly made
        delivery.rounds_passed = (delivery.rounds_passed or 0) + 1
        if delivery.rounds_passed > delivery.rounds_total then
            
            local area = G.P_CENTERS[delivery.key].consumeable and G.consumeables or G.P_CENTERS[delivery.key].set == 'Joker' and G.jokers
            if area and area.cards and #area.cards < area.config.card_limit then
                local c = SMODS.add_card({ key = delivery.key })
                if delivery.extras then
                    for k,v in pairs(delivery.extras) do
                        c[k] = v
                    end
                end
            else
                ease_dollars(delivery.price)
            end
        end
    end
    
    for i = #G.GAME.hp_jtem_delivery_queue, 1,-1 do
        local delivery = G.GAME.hp_jtem_delivery_queue[i]
        if delivery.rounds_passed > delivery.rounds_total then
            remove_element_from_list(G.GAME.hp_jtem_delivery_queue, delivery)
        end
    end
end

local start_run_to_init_areas = Game.start_run
function Game:start_run(args)
    local x = {start_run_to_init_areas(self,args)}

    local saveTable = args.savetext or nil
    if not saveTable or (saveTable and not saveTable.GAME) then
        G.HP_SHOP_CREATED_CARDS = nil
    end
    
    if G.STATE == G.STATES.SHOP then 
        hotpot_jtem_init_extra_shops_area() 
        simple_add_event(function ()
            hotpot_delivery_refresh_card() 
            return true
        end)
    end
    return unpack(x)
end
-- destroy cards below
local next_round_button_for_delivery_area_destruction = G.FUNCS.toggle_shop
function G.FUNCS.toggle_shop(e)
    G.HP_SHOP_CREATED_CARDS = nil   
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_special_deals,true)
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_queue,true)
    return next_round_button_for_delivery_area_destruction(e)
end

function G.FUNCS.hotpot_jtem_delivery_request_item()
end



-- this moves the shop up and down along with slide whistle sound :joy::ok_hand:
function G.FUNCS.hotpot_jtem_toggle_delivery()
    if (G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)) then return end
    stop_use()
    local sign_sprite = G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object
    if G.shop.alignment.offset.y == -5.3 then
        G.shop.alignment.offset.y = -20
        simple_add_event(function ()
            sign_sprite.pinch.y = true
            delay(0.5)
            simple_add_event(function()
                sign_sprite.atlas = G.ANIMATION_ATLAS["hpot_jtem_postlatro"] 
                sign_sprite.pinch.y = false
                return true
            end)
            return true
        end, {trigger = "after", delay = 0})
        play_sound("hpot_sfx_whistleup",nil, 0.25)
    else
        G.shop.alignment.offset.y = -5.3
        simple_add_event(function ()
            sign_sprite.pinch.y = true
            delay(0.5)
            simple_add_event(function()
                sign_sprite.atlas = G.ANIMATION_ATLAS["shop_sign"] 
                sign_sprite.pinch.y = false
                return true
            end)
            return true
        end, {trigger = "after", delay = 0})
        play_sound("hpot_sfx_whistledown",nil, 0.25)
    end
end

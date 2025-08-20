-- SHOP Button for Delivery
-- this is patched into the code via jtem_delivery.toml

-- little reminder that unless absolutely needed, don't use "at" target for patches :3

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
    -- dollars to jx
    G.GAME.hp_jtem_d2j_rate = G.GAME.hp_jtem_d2j_rate or { from = 1, to = 5000 }
    G.GAME.hp_jtem_p2j_rate = G.GAME.hp_jtem_p2j_rate or { from = 1, to = 32000 }
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
                        config = {colour = G.C.RED, align = "cm", padding = 0.05, r = 0.02, minw = 3, minh = 0.8, shadow = true, button = 'hotpot_jtem_delivery_request_item',func = "hp_jtem_can_request_joker", hover = true},
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
                        config = {colour = G.C.BLUE, align = "cm", padding = 0.05, r = 0.02, minw = 3, minh = 0.8, shadow = true, button = 'hp_jtem_exchange_d2j', func = "hp_jtem_can_exchange_d2j", hover = true},
                        nodes = {
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize({type = "variable", key = "hotpot_exchange_for_jx_line_1", vars = {G.GAME.hp_jtem_d2j_rate.to}}), scale = 0.5, colour = G.C.WHITE, font = SMODS.Fonts['hpot_plincoin']}
                                    },
                                }
                            },
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize({type = "variable", key = "hotpot_exchange_for_jx_line_2",vars = {"$",G.GAME.hp_jtem_d2j_rate.from}} ), scale = 0.3, colour = G.C.WHITE}
                                    },
                                }
                            },
                        }
                    },
                    {
                        n = G.UIT.R,
                        config = {colour = G.C.BLUE, align = "cm", padding = 0.05, r = 0.02, minw = 3, minh = 0.8, shadow = true, button = 'hp_jtem_exchange_p2j', func = "hp_jtem_can_exchange_p2j", hover = true},
                        nodes = {
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize({type = "variable", key = "hotpot_exchange_for_jx_line_1", vars = {G.GAME.hp_jtem_p2j_rate.to}}), scale = 0.5, colour = G.C.WHITE, font = SMODS.Fonts['hpot_plincoin']}
                                    },
                                }
                            },
                            {
                                n = G.UIT.R, config = { align = "cm" },
                                nodes = { { n = G.UIT.T,
                                        config = { text = localize({type = "variable", key = "hotpot_exchange_for_jx_line_2",vars = {"$",G.GAME.hp_jtem_p2j_rate.from}} ), scale = 0.3, colour = G.C.WHITE, font = SMODS.Fonts['hpot_plincoin']}
                                    },
                                }
                            },
                        }
                    },
                }
            },
            {
                n = G.UIT.C,
                config = { padding = 0.2, colour = G.C.UI.TRANSPARENT_DARK, r = 0.05 },
                nodes = {
                    {
                        n = G.UIT.O,
                        config = {
                            object = G.hp_jtem_delivery_queue,
                        }
                    }
                }
            }
        }
    },
    {
        n = G.UIT.R,
        nodes = {
            {
                n = G.UIT.B,
                config = {
                    h = 0.5,
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
                config = { padding = 0.05, colour = G.C.UI.TRANSPARENT_DARK, r = 0.05 },
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
    },
    {
        n = G.UIT.R,
        nodes = {
            {
                n = G.UIT.B,
                config = {
                    h = 0.5,
                    w = 0.1
                }
            }
        }
    }
end

G.FUNCS.hp_jtem_can_exchange_d2j = function(e)
    if (G.GAME.hp_jtem_d2j_rate.from > G.GAME.dollars - G.GAME.bankrupt_at) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'hp_jtem_exchange_d2j'
    end
end
G.FUNCS.hp_jtem_can_exchange_p2j = function(e)
    if (G.GAME.hp_jtem_p2j_rate.from > G.GAME.plincoins) or not G.GAME.hp_jtem_should_allow_buying_jx_from_plincoin then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.BLUE
        e.config.button = 'hp_jtem_exchange_p2j'
    end
end
G.FUNCS.hp_jtem_can_order = function(e)
    local _c = e.config.ref_table
    if (_c.hp_jtem_currency_bought_value > get_currency_amount(_c.hp_jtem_currency_bought) - (_c.hp_jtem_currency_bought == "dollars" and G.GAME.bankrupt_at or 0)) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'hp_jtem_order'
    end
end
G.FUNCS.hp_jtem_can_request_joker = function(e)
    local _c = e.config.ref_table
    if not G.GAME.hp_jtem_should_allow_custom_order then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = 'hotpot_jtem_delivery_request_item'
    end
end

function G.FUNCS.hotpot_jtem_delivery_request_item(e)
    print(e)
end

G.FUNCS.hp_jtem_can_cancel = function(e)
    return false
end
G.FUNCS.hp_jtem_exchange_d2j = function(e)
    ease_dollars(-G.GAME.hp_jtem_d2j_rate.from)
    ease_spark_points(G.GAME.hp_jtem_d2j_rate.to)
end
G.FUNCS.hp_jtem_exchange_p2j = function(e)
    ease_plincoins(-G.GAME.hp_jtem_p2j_rate.from)
    ease_spark_points(G.GAME.hp_jtem_p2j_rate.to)
end

G.FUNCS.hp_jtem_order = function(e)
    G.GAME.hp_jtem_queue_max_size = G.GAME.hp_jtem_queue_max_size or 2
    local card = e.config.ref_table
    if #G.GAME.hp_jtem_delivery_queue >= G.GAME.hp_jtem_queue_max_size then
        alert_no_space(card, G.hp_jtem_delivery_queue)
        e.disable_button = nil
        return
    end
    local object = card.hp_delivery_obj
    ease_currency(object.currency, -object.price)
    table.insert(G.GAME.hp_jtem_delivery_queue, object)
    remove_element_from_list(G.GAME.round_resets.hp_jtem_special_offer,object)
    draw_card(G.hp_jtem_delivery_special_deals, G.hp_jtem_delivery_queue, nil, 'up', false, card)
    if card.children.price then
        card.children.price:remove()
        card.children.price = nil
    end
    if card.children.hp_jtem_price_side then
        card.children.hp_jtem_price_side:remove()
        card.children.hp_jtem_price_side = nil
    end
    if card.children.hp_jtem_cancel_order then
        card.children.hp_jtem_cancel_order:remove()
        card.children.hp_jtem_cancel_order = nil
    end
    local args = generate_currency_string_args(card.hp_jtem_currency_bought)
    local temp_str = { str = (object.rounds_passed .. "/" .. object.rounds_total)}
    hpot_jtem_create_delivery_boxes(card,{{ref_table = temp_str, ref_value = 'str'}},args)
    --hotpot_delivery_refresh_card()
end
G.FUNCS.hp_jtem_cancel = function(e)
    local card = e.config.ref_table
    local object = card.hp_delivery_obj
    local returncost = math.ceil(object.price * 0.5)
    ease_currency(object.currency, returncost)
    remove_element_from_list(G.GAME.hp_jtem_delivery_queue,object)
    card:start_dissolve()
    --hotpot_delivery_refresh_card()
end

-- literally copied from price boxes
function hpot_jtem_create_delivery_boxes(card, rounds_text, args)
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
                {n=G.UIT.O, config={object = DynaText({string = { unpack(rounds_text) }, colours = { G.C.GREEN },shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5})}},
                }}
            }}
        local t2 =  {
        n=G.UIT.ROOT, config = {ref_table = card, minw = 2.1, maxw = 2.4, padding = 0.1, align = 'mc', colour = args.colour, shadow = true, r = 0.08, minh = 0.94}, nodes={
            {
                n = G.UIT.R,
                nodes = {
                    {n=G.UIT.T, config={font = args.font, text = localize("hotpot_cashback")..((args.symbol)..number_format(math.ceil(card.hp_jtem_currency_bought_value * 0.5))) ,colour = G.C.WHITE, scale = 0.3}}
                }
            },
            { n = G.UIT.R, nodes = { {n = G.UIT.B,config = {h = 1,w = 0.1}}}},
        }}
        card.children.price = UIBox{
        definition = t1,
        config = {
            align="tm",
            offset = {x=0,y=1.5},
            major = card,
            bond = 'Weak',
            parent = card
            
        }}
        card.children.hp_jtem_price_side = UIBox{
        definition = t2,
        config = {
            align="tm",
            offset = {x=0,y=0.5},
            major = card,
            bond = 'Weak',
            parent = card
            
        }}


        local t3 = {
            n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.RED, shadow = true, r = 0.08, minh = 0.94, func = 'hp_jtem_can_cancel', one_press = true, button = 'hp_jtem_cancel', hover = true}, nodes={
                {n=G.UIT.T, config={text = localize('hotpot_delivery_order_cancel'),colour = G.C.WHITE, scale = 0.5}}
            }}

        card.children.hp_jtem_cancel_order = UIBox{
            definition = t3,
            config = {
            align="bm",
            offset = {x=0,y=-0.5},
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
function hpot_jtem_create_special_deal_boxes(card, price_text, args)
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
                {n=G.UIT.O, config={object = DynaText({string = { unpack(price_text) }, colours = {args.colour or G.C.MONEY},shadow = true, silent = true, bump = true, pop_in = 0, scale = 0.5, font = args.font or SMODS.Fonts["hpot_plincoin"]})}},
                }},
                {n=G.UIT.R, config={align = "cm", r = 0.1, minw = 1, minh = 0.2, emboss = 0.05, padding = 0.01}, nodes={
                {n=G.UIT.T, config={text = localize{key="hotpot_round_total_eta",type="variable",vars = {card.hp_delivery_obj.rounds_total,(card.hp_delivery_obj.rounds_total ~= 1 and localize("rounds_plural") or localize("rounds_singular"))}}, colour = G.C.WHITE, scale = 0.2}},
                }},
                { n = G.UIT.R, nodes = { {n = G.UIT.B,config = {h = 0.2,w = 0.1}}}},
                
            }}
            
        local t2 =  {
        n=G.UIT.ROOT, config = {ref_table = card, minw = 1.1, maxw = 1.3, padding = 0.1, align = 'bm', colour = G.C.GOLD, shadow = true, r = 0.08, minh = 0.94, func = 'hp_jtem_can_order', one_press = true, button = 'hp_jtem_order', hover = true}, nodes={
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
    G.GAME.hp_jtem_d2j_rate = G.GAME.hp_jtem_d2j_rate or { from = 1, to = 5000 }
    G.GAME.hp_jtem_p2j_rate = G.GAME.hp_jtem_p2j_rate or { from = 1, to = 32000 }
        

        card.children.hp_jtem_price_side = UIBox{
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
            price - cost in case of refunds (is a table now lol)
                price.value and price.currency - should be self explanatory (ok so currency at the moment has 3, 
                    dollars, plincoin, and joker exchange (internally spark_points) )
            extras - other attributes that should apply to card ability directly, for example eternal, rental
    ]]
    r.round_resets.hp_jtem_special_offer = {}
    --[[
        the offer should reset EVERY round with the following format which is basically the same as above (there should be 5 of them at most)
            key - the center key thing (lol)
            extras - shit like rental and eternal and stuff like that
            price - same as above really
            rounds_passed, rounds_total should be lower than normally ordering jokers to incentivise doing this 
                instead of ordering everything and so should the price
    ]]
    -- from 1 dollar to 500 jx
    r.hp_jtem_queue_max_size = 2
    -- d2j is dollars to joker exchange
    r.hp_jtem_d2j_rate = { from = 1, to = 5000 }
    -- p2j is plincoin to joker exchange
    r.hp_jtem_p2j_rate = { from = 1, to = 32000 }
    r.hp_jtem_special_offer_count = 3
    r.hp_jtem_should_allow_custom_order = false
    r.hp_jtem_should_allow_buying_jx_from_plincoin = false
    return r
end

SMODS.current_mod.reset_game_globals = function(run_start)
    if not run_start then
        G.GAME.round_resets.hp_jtem_special_offer = {}
        hotpot_jtem_generate_special_deals()
    end
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

-- very useful for multiple currencies like this
function get_currency_amount(currency)
    currency = currency or "dollars"
    value = value or 0
    if currency == "dollars" then return G.GAME.dollars end
    if currency == "plincoin" then return G.GAME.plincoins end
    if currency == "joker_exchange" then return G.GAME.spark_points end
end
function ease_currency(currency, value, instant)
    currency = currency or "dollars"
    value = value or 0
    if currency == "dollars" then ease_dollars(value,instant) end
    if currency == "plincoin" then ease_plincoins(value,instant) end
    if currency == "joker_exchange" then ease_spark_points(value, instant) end
    -- patches for other currencies ease
end
function generate_currency_string_args(currency)
    currency = currency or "dollars"
    if currency == "dollars" then return { colour = G.C.MONEY, symbol = "$", font = G.LANG.font } end
    if currency == "plincoin" then return { colour = SMODS.Gradients["hpot_plincoin"], symbol = "$", font = SMODS.Fonts["hpot_plincoin"] } end
    if currency == "joker_exchange" then return { colour = G.C.BLUE, symbol = "͸", font = SMODS.Fonts["hpot_plincoin"] } end
    -- patches for other currencies strings
end

function hotpot_jtem_add_card_to_delivery_queue( key, price )
    -- price accepts the following value
    -- number - defaults to dollars
    -- table with key currency and value for 
    price = price or 0
    local value = type(price) == "table" and price.value or price
    local currency = type(price) == "table" and price.currency or "dollars"
    if not G.P_CENTERS[key] then return end
    local ct = G.P_CENTERS[key]
    local delivery_table = {
        key = key,
        rounds_passed = 0,
        rounds_total = hotpot_jtem_center_to_round_wait(ct),
        price = value,
        currency = currency,
        extras = {}
    }
    -- target patch for custom delivery queue
    G.GAME.hp_jtem_delivery_queue = G.GAME.hp_jtem_delivery_queue or {}
    table.insert(G.GAME.hp_jtem_delivery_queue, delivery_table)
    if G.hp_jtem_delivery_queue then
        hotpot_delivery_refresh_card()
    end
end
function hotpot_jtem_add_to_offers( key, args )
    -- args accepts like weird shit you can probably just understand it by looking at it
    if not G.P_CENTERS[key] then return end

    local price = args.price or 0
    local value = type(price) == "table" and price.value or price
    local currency = type(price) == "table" and price.currency or "dollars"
    local ct = G.P_CENTERS[key]
    local delivery_table = {
        key = key,
        rounds_passed = args.rounds_passed or 0,
        rounds_total = args.rounds_total or math.ceil(hotpot_jtem_center_to_round_wait(ct) * (args.rounds_total_factor or 0)),
        price = value,
        currency = currency,
        extras = args.extras or {},
        create_card_args = args.create_card_args or {},
    }
    -- target patch for custom special deals
    G.GAME.round_resets.hp_jtem_special_offer = G.GAME.round_resets.hp_jtem_special_offer or {}
    table.insert(G.GAME.round_resets.hp_jtem_special_offer, delivery_table)
    if G.hp_jtem_delivery_special_deals then
        hotpot_delivery_refresh_card()
    end
end
local currencies = {"dollars", "joker_exchange", "plincoin"}
function hotpot_jtem_generate_special_deals( deals )
    -- generate 5 deals
    -- to other people who see this
    -- feel free to tweak the balanced
    G.GAME.round_resets.hp_jtem_special_offer = {}
    G.GAME.hp_jtem_special_offer_count = G.GAME.hp_jtem_special_offer_count or 3
    for i = 1, (deals or G.GAME.hp_jtem_special_offer_count) do
        local _pool, _pool_key = get_current_pool("Joker")
        _pool = remove_unavailable(_pool)
        local center_key = pseudorandom_element(_pool, pseudoseed(_pool_key))
        local center = G.P_CENTERS[center_key]
        local should_spawn_with_rental = pseudorandom("hpjtem_delivery_rental") < 0.1 and true
        local should_spawn_with_eternal = center.eternal_compat and pseudorandom("hpjtem_delivery_eternal") < 0.1 and true
        local should_spawn_with_perishable = center.perishable_compat and pseudorandom("hpjtem_delivery_perishable") < 0.1 and not should_spawn_with_eternal
        local currency = pseudorandom_element(currencies, pseudoseed("hpjtem_delivery_currency"))
        local price_factor = currency == "joker_exchange" and 7331 or currency == "plincoin" and 0.3 or 0.8
        local plincoin = currency == "plincoin"
        local jx = currency == "joker_exchange"
        -- add factor of 0.87 to 1.15
        local random_price_factor = pseudorandom("hpjtem_delivery_price_factor") * 0.28 + 0.87
        price_factor = price_factor * (should_spawn_with_eternal and 0.8 or 1) * (should_spawn_with_rental and 0.5 or 1) * (should_spawn_with_perishable and 0.3 or 1)
        if center then
            hotpot_jtem_add_to_offers( center.key , {
                price = { currency = currency, value = math.ceil(center.cost * price_factor * random_price_factor) },
                rounds_total_factor = 0.4 * (should_spawn_with_perishable and 0.2 or 1)* (should_spawn_with_rental and 0.3 or 1)* (should_spawn_with_rental and 0.5 or 1) * (plincoin and 2 or 1),
                extras = {
                    rental = should_spawn_with_rental,
                    eternal = should_spawn_with_eternal,
                    perishable = should_spawn_with_perishable,
                    perish_tally = should_spawn_with_perishable and G.GAME.perishable_rounds,
                },
                create_card_args = {
                    hp_jtem_silent_edition = plincoin and poll_edition("hpjtem_delivery_edition",nil,nil,true) or (not jx and poll_edition("hpjtem_delivery_edition")),
                    no_edition = jx
                }
            } )
        end

    end
end

function hotpot_delivery_refresh_card()
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_special_deals,true)
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_queue,true)
    for _,_obj in ipairs(G.GAME.hp_jtem_delivery_queue) do
        local temp_str = { str = (_obj.rounds_passed .. "/" .. _obj.rounds_total)}
        local cct = { area = G.hp_jtem_delivery_queue, key = _obj.key, skip_materialize = true, no_edition = true }
        for k,v in pairs(_obj.create_card_args) do
            cct[k] = v
        end
        local _c = SMODS.create_card(cct)
        _c.hp_jtem_currency_bought = _obj.currency
        _c.hp_jtem_currency_bought_value = _obj.price
        _c.hp_delivery_obj = _obj
        local args = generate_currency_string_args(_c.hp_jtem_currency_bought)
        hpot_jtem_create_delivery_boxes(_c,{{ref_table = temp_str, ref_value = 'str'}},args)
        if _obj.extras then
            for k,v in pairs(_obj.extras) do
                _c.ability[k] = v
            end
        end
        G.hp_jtem_delivery_queue:emplace(_c)
    end
    for _,_obj in ipairs(G.GAME.round_resets.hp_jtem_special_offer) do
        local cct = { area = G.hp_jtem_delivery_special_deals, key = _obj.key, skip_materialize = true, no_edition = true }
        for k,v in pairs(_obj.create_card_args) do
            cct[k] = v
        end
        local _c = SMODS.create_card(cct)
        _c.hp_jtem_currency_bought = _obj.currency
        _c.hp_jtem_currency_bought_value = _obj.price
        _c.hp_delivery_obj = _obj
        local args = generate_currency_string_args(_c.hp_jtem_currency_bought)
        hpot_jtem_create_special_deal_boxes(_c,{{prefix = args.symbol, ref_table = _c, ref_value = "hp_jtem_currency_bought_value"}}, args)
        if _obj.extras then
            for k,v in pairs(_obj.extras) do
                _c.ability[k] = v
            end
        end
        G.hp_jtem_delivery_special_deals:emplace(_c)
    end
end
-- this part is for saving card value
local card_init_val = Card.init
function Card:init(x,y,w,h,_card,_center,_params)
    local _c = card_init_val(self,x,y,w,h,_card,_center,_params)
    self.hp_jtem_currency_bought = self.hp_jtem_currency_bought or "dollars"
    self.hp_jtem_currency_bought_value = self.hp_jtem_currency_bought_value or 0
    return _c
end
local card_save_additional_props = Card.save
function Card:save()
    local st = card_save_additional_props(self)
    st.hp_jtem_currency_bought = self.hp_jtem_currency_bought or "dollars"
    st.hp_jtem_currency_bought_value = self.hp_jtem_currency_bought_value or 0
    return st
end
local card_load_additional_props = Card.load
function Card:load(ct, oc)
    local st = card_load_additional_props(self, ct, oc)
    self.hp_jtem_currency_bought = ct.hp_jtem_currency_bought or "dollars"
    self.hp_jtem_currency_bought_value = ct.hp_jtem_currency_bought_value or 0
    return st
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

-- calculate delivery which is calculated at the start of the round along with giving out cards
function hotpot_jtem_calculate_deliveries()
    
    G.GAME.hp_jtem_delivery_queue = G.GAME.hp_jtem_delivery_queue or {}
    for _,delivery in pairs(G.GAME.hp_jtem_delivery_queue) do
        delivery.rounds_total = delivery.rounds_total or 999 -- just in case an order was badly made
        delivery.rounds_passed = (delivery.rounds_passed or 0) + 1
        if delivery.rounds_passed > delivery.rounds_total then
            
            local area = G.P_CENTERS[delivery.key].consumeable and G.consumeables or G.P_CENTERS[delivery.key].set == 'Joker' and G.jokers
            if area and area.cards and #area.cards < area.config.card_limit then
                
                local cct = { key = delivery.key, skip_materialize = true}
                for k,v in pairs(delivery.create_card_args) do
                    cct[k] = v
                end
                local c = SMODS.add_card(cct)
                if delivery.extras then
                    for k,v in pairs(delivery.extras) do
                        c.ability[k] = v
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
    G.HP_JTEM_DELIVERY_VISIBLE = false
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_special_deals,true)
    hotpot_jtem_destroy_all_card_in_an_area(G.hp_jtem_delivery_queue,true)
    return next_round_button_for_delivery_area_destruction(e)
end



-- this moves the shop up and down along with slide whistle sound :joy::ok_hand:
function G.FUNCS.hotpot_jtem_toggle_delivery()
    if (G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)) then return end
    stop_use()
    local sign_sprite = G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object
    if not G.HP_JTEM_DELIVERY_VISIBLE then
		ease_background_colour({new_colour = G.C.BLUE, special_colour = G.C.RED, tertiary_colour = darken(G.C.BLACK,0.4), contrast = 2})
        G.shop.alignment.offset.y = -20
        G.HP_JTEM_DELIVERY_VISIBLE = true
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
		ease_background_colour_blind(G.STATES.SHOP)
        G.shop.alignment.offset.y = -5.3
        G.HP_JTEM_DELIVERY_VISIBLE = nil
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

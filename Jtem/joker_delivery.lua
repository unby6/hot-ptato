-- SHOP Button for Delivery
-- this is patched into the code via jtem_shop_ui.toml
function G.UIDEF.hotpot_jtem_delivery_section()
end

function G.FUNCS.hotpot_jtem_toggle_delivery()
    if G.shop.alignment.offset.y == -5.3 then
        G.shop.alignment.offset.y = -20
        play_sound("hpot_sfx_whistleup")
    else
        G.shop.alignment.offset.y = -5.3
        play_sound("hpot_sfx_whistledown")
    end
end

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
    
    G.hp_jtem_delivery_queue = G.hp_jtem_delivery_queue or CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      5.6*G.CARD_W,
      1.15*G.CARD_H, 
      {card_limit = 5, type = 'shop', highlight_limit = 0, card_w = 1.27*G.CARD_W})

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
                n = G.UIT.O,
                config = {
                    object = G.hp_jtem_delivery_queue,
                }
            }
        }
    }
end
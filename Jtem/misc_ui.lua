local index_to_jx_mult = {
-- from_multiplier, to multiplier, first_time_bonus_multiplier
    { 1 , 1, 1 },
    { 3 , 3.1, 1.25 },
    { 7 , 7.5, 1.5 },
    { 13 , 14.2, 1.8 },
    { 22 , 24, 2.2 },
}
local function hp_jtem_buy_jx_individual( b_type, index )
    local am
    if b_type == "plincoin" then
        am = "p2j"
    else
        am = "d2j"
    end
    local st = G.GAME["hp_jtem_".. am .."_rate"] or G.GAME.hp_jtem_d2j_rate
    local price_mult = index_to_jx_mult[index]
    local price = st.from * price_mult[1]
    local price_display = st.from * price_mult[1] - 0.01
    local gives_out = st.to * price_mult[2]
    local first_time_bonus = gives_out * price_mult[3]
    local args = generate_currency_string_args(b_type)

    local numbertext = {
        {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.T,
                    config = { text = "͸"..(number_format(gives_out, 1e10)), colour = G.C.BLUE, scale = 0.6, font = SMODS.Fonts.hpot_plincoin }
                }
            }
        },
    }

    if not G.GAME.jp_jtem_has_ever_bought_jx then
        table.insert(numbertext, {
            n = G.UIT.C,
            config = { align = "cm" },
            nodes = {
                {
                    n = G.UIT.T,
                    config = { text = localize{type = "variable", vars = {number_format(first_time_bonus, 1e10)}, key = "hotpot_exchange_bonus"}, colour = G.C.RED, scale = 0.4, font = SMODS.Fonts.hpot_plincoin }
                }
            }
        })
    end
    
    return {
        n = G.UIT.C,
        config = { minw = 3.5, minh = 4, maxw = 3.5, maxh = 4, align = "cm", padding = 0.1, colour = G.C.UI.TRANSPARENT_DARK, r = 0.1},
        nodes = {
            { n = G.UIT.R, config = { align = "cm" }, nodes = {
                    {
                        n = G.UIT.O,
                        config = {object = Sprite(0,0,2,2,G.ASSET_ATLAS['hpot_jtem_jx_bundle'],{ x = index - 1, y = b_type == "plincoin" and 1 or 0})}
                    }
                }
            },
            { n = G.UIT.R, config = { align = "cm" }, nodes = {
                    {
                        n = G.UIT.T,
                        config = { text = localize("hotpot_exchange_option_"..(b_type == "plincoin" and "plin_" or "")..index), colour = G.C.WHITE, scale = 0.4, font = SMODS.Fonts.hpot_plincoin }
                    }
                }
            },
            { n = G.UIT.R, config = { align = "cm" }, nodes = numbertext
            },
            { n = G.UIT.R, config = { align = "cm", func = "hpot_can_buy_jx_screen", button = 'hpot_buy_jx_button', shadow = true, ref_table = {currency = b_type, take = price, gives = gives_out, args = args}, hover = true, colour = args.colour, font = args.font, padding = 0.1, r = 0.05,minw = 3.5}, nodes = {
                    {
                        n = G.UIT.T,
                        config = { text = args.symbol..price_display, colour = G.C.WHITE, scale = 0.5, font = args.font }
                    }
                }
            },
        }
    }
end

G.FUNCS.hpot_can_buy_jx_screen = function (e)
    local buy_table = e.config.ref_table
    
    if (buy_table.take > get_currency_amount(buy_table.currency) - (buy_table.currency == "dollars" and G.GAME.bankrupt_at or 0)) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = buy_table.args.colour
        e.config.button = 'hpot_buy_jx_screen'
    end
    
end

G.FUNCS.hpot_buy_jx_screen = function (e)
    local buy_table = e.config.ref_table
    G.GAME.jp_jtem_has_ever_bought_jx = true
    ease_currency(buy_table.currency,-buy_table.take)
    ease_spark_points(buy_table.gives)
    G.FUNCS.exit_overlay_menu()
end

local function hp_jtem_buy_jx_row( type )
    local ch = {}
    for i = 1, 5 do 
        table.insert(ch, hp_jtem_buy_jx_individual(type, i))
    end
    return {
        n = G.UIT.R,
        config = { align = "cm", padding = 0.1, colour = G.C.UI.TRANSPARENT_DARK, r = 0.1 },
        nodes = ch
    }
end
G.UIDEF.hp_jtem_buy_jx = function (mode)
    local nds = {}
    if mode == "dollars" or (mode == "both") then
        table.insert(nds, hp_jtem_buy_jx_row( "dollars" ))
    end
    if (mode == "plincoin" or (mode == "both")) and G.GAME.hp_jtem_should_allow_buying_jx_from_plincoin then
        table.insert(nds, hp_jtem_buy_jx_row( "plincoin" ))
    end
    local ret = {
        n = G.UIT.C,
        config = { colour = G.C.UI.TRANSPARENT_DARK , minw = 6.5, minh = 3.5, r = 0.15, padding = 0.1, align = "tm" },
        nodes = {
            {
                n = G.UIT.R,
                config = {align = "cm", padding = 0.2},
                nodes = {
                    { n = G.UIT.O, config = { 
                        object = 
                            DynaText({ string = {localize('hotpot_exchange_title')}, font = SMODS.Fonts.hpot_plincoin, float = true, colours = {G.C.BLUE}, shadow = true}) 
                        }
                    },
                }
            },
            {
                n = G.UIT.R,
                nodes = nds
            },
            {
                n = G.UIT.R,
                config = {align = "cm", padding = 0.2},
                nodes = {
                    {
                        n = G.UIT.T,
                        config = { text = localize("hotpot_exchange_note"), scale = 0.4, colour = G.C.GREY }
                    }
                }
            },
            
        }
    }
    return create_UIBox_generic_options({ contents = {ret}})
end

--[[
    ease_dollars(-G.GAME.hp_jtem_d2j_rate.from)
    ease_spark_points(G.GAME.hp_jtem_d2j_rate.to)

    ease_plincoins(-G.GAME.hp_jtem_p2j_rate.from)
    ease_spark_points(G.GAME.hp_jtem_p2j_rate.to)
]]

G.FUNCS.hp_open_full_jx_top_up = function(e)
    G.SETTINGS.paused = true
    G.FUNCS.overlay_menu {
        definition = G.UIDEF.hp_jtem_buy_jx("both")
    }
end
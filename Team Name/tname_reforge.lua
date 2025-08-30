-- Reforge menu

--- Custom function to make buttons:tm:
---@param args {label:{}[],w:number,h:number,colour:table,text_scale:number,text_col:table,font:string,func:string,button:string,type:"R"|"C"}
---@return table node The button node
---`label = {{{"Word 1"},{"Word 2"}...},{"New line"}...}` - The button's label text. It is highly customizable, supporting raw text `strings`, `ref_table` + `ref_value` combinations, custom `font`, `colour` and `scale`.\
---`w = 2.7, h = 0.9` - Minimum **width** and **height** of the button.\
---`colour = G.C.RED` - Colour of the button.\
---`text_scale = 0.3` - Default text scale. Can be overwritten in each text component.\
---`text_col = G.C.WHITE` - Default text colour. Can be overwritten in each text component.\
---`font = nil` - Default font. Can be overwritten in each text component.\
---`type = C` - Defines how to align the buttons.\
---`func` - Function to run in `G.FUNCS[func]` every frame the button is present.\
---`button` - Function to run `G.FUNCS.[button]` when the button is pressed.
function UIBox_adv_button (args)
    args = args or {}
    args.label = args.label or { -- HORRID EXAMPLE ON HOW TO SET THESE UP !!!
        {
            {"ERROR"},{" NO TEXT"}
        }
    }
    args.w = args.w or 2.7
    args.h = args.h or 0.9
    args.colour = args.colour or G.C.RED
    args.text_scale = args.text_scale or 0.3
    args.text_col = args.text_col or G.C.WHITE
    args.font = args.font or nil
    if not args.type and (args.type ~= "R" or args.type ~= "C") then args.type = "R" end

    local texts = {}

    for _,v in ipairs(args.label) do
        local line = {n = G.UIT.R, config = {align = "cm", colour = G.C.CLEAR, minw = 0.2, minh = 0.2}, nodes = {}}
        for kk,vv in pairs(v) do
            local text = {n = G.UIT.T, config = {
                text = vv[1] or vv.string,
                ref_table = vv.ref_table,
                ref_value = vv.ref_value,
                colour = vv.colour or args.text_col or G.C.WHITE,
                scale = args.text_scale or vv.scale or 0.3,
                font = (vv.font and SMODS.Fonts[vv.font]) or (args.font and SMODS.Fonts[args.font])
            }}
            table.insert(line.nodes,text)
        end
        table.insert(texts,line)
    end

    return {n = G.UIT[args.type], config = {
        minw = args.w,
        minh = args.h,
        align = "cm",
        colour = args.colour,
        func = args.func, button =
        args.button,
        r = 0.1,
        hover = true},
        nodes = texts
    }
end


G.UIDEF.hotpot_tname_reforge_section = function ()
    G.reforge_area = CardArea(
        0, 0, 1, 1,
        {card_limit = 1, type = "shop", highlight_limit = 0}
    )
	return 
	{n = G.UIT.R, config = {minw = 3, minh = 5.5, colour = G.C.CLEAR}, nodes = {}},
	{n = G.UIT.R, config = {minw = 3, minh = 9, colour = G.C.CLEAR, align = "cm"}, nodes = {
		{n = G.UIT.R, config = {align = "cm", minw = 2, minh = 3}, nodes = {

			{n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
				{n = G.UIT.R, config = {align = "cm"}, nodes = {{n = G.UIT.T, config = {text = localize("k_reforge_big"), colour = G.C.GREY, scale = 0.7, align = "cm"}}}},
				{n = G.UIT.R, config = {minh = 0.2}},
				UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_credits")},{ref_table = G.GAME, ref_value = "cost_credits"}}},
                    text_scale = 0.5,
                    button = 'reforge_with_credits',
                    func = "can_reforge_with_creds",
                    colour = G.C.PURPLE
                },
                UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_dollars")},{ref_table = G.GAME, ref_value = "cost_dollars"}}},
                    text_scale = 0.5,
                    button = 'reforge_with_dollars',
                    func = "can_reforge_with_dollars",
                    colour = G.C.GOLD
                },
                UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_joker_exchange"), font = "hpot_plincoin"},{ref_table = G.GAME, ref_value = "cost_sparks"}}},
                    text_scale = 0.5,
                    button = 'reforge_with_sparks',
                    func = "can_reforge_with_joker_exchange",
                    colour = G.C.BLUE
                },
                UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_plincoins"), font = "hpot_plincoin"},{ref_table = G.GAME, ref_value = "cost_plincoins"}}},
                    text_scale = 0.5,
                    button = 'reforge_with_plincoins',
                    func = "can_reforge_with_plincoins",
                    colour = SMODS.Gradients["hpot_plincoin"]
                },
			}},

			{n = G.UIT.C, config = {minw = 0.1}},

			{n = G.UIT.C, config = {align = "cm", colour = G.C.GREY, r = 0.1, padding = 0.2}, nodes = {
                {n = G.UIT.C, config = {colour = G.C.BLACK, minw = 4, minh = 5, r = 0.1, align = "cm", padding = 0.1}, nodes = {
                    {n = G.UIT.R, config = {align = "tm"}, nodes = {{n = G.UIT.T, config = {text = localize("k_place_card_text"), colour = G.C.GREY, scale = 0.4, align = "tm"}}}},
                    {n = G.UIT.R, config = {align = "cm",minw = G.CARD_W, minh = G.CARD_H}, nodes = {{n = G.UIT.O, config = {object = G.reforge_area, align = "cm"}}}},
				}},
			}},
		}},
        {n = G.UIT.R, config = {minh = 0.2}},
        {n = G.UIT.R, config = {align = "cm"}, nodes = {
            UIBox_adv_button{
                label = {{{localize("k_place_button")}}},
                text_scale = 0.5,
                w = 3, h = 1,
                button = 'reforge_place',
                func = "place_return_reforge",
                colour = G.C.GREEN,
                type = "C"
            },
            {n = G.UIT.C, config = {align = "cm", padding = 0.1}},
            UIBox_adv_button{
                label = {{{localize("k_return_button")}}},
                text_scale = 0.5,
                w = 3, h = 1,
                button = 'reforge_return',
                func = "return_place_reforge",
                colour = G.C.RED,
                type = "C"
            },
        }}
	}},
	{n = G.UIT.R, config = {minw = 3, minh = 3, colour = G.C.CLEAR}, nodes = {}}
end

function HPTN.move_card(card, _area) -- Moving cards from one area to another easily
    local area = card.area
	if not card.getting_sliced then	
		area:remove_card(card)
		_area:emplace(card)
    end
end

function G.FUNCS.return_place_reforge(e)
if G.reforge_area and G.reforge_area.cards then
    if #G.reforge_area.cards <= 0 then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.RED
            e.config.button = 'reforge_return'
        end
    end
end

function G.FUNCS.place_return_reforge(e)
    if (G.jokers and G.jokers.highlighted and #G.jokers.highlighted <= 0) or (G.reforge_area and #G.reforge_area.cards > 0) then -- what the fuck 
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.GREEN
            e.config.button = 'reforge_place'
        end
    end

G.FUNCS.reforge_place = function ()
    if G.jokers and G.jokers.highlighted and #G.jokers.highlighted > 0 then
        local c = G.jokers.highlighted[1]
        HPTN.move_card(c, G.reforge_area)
        G.GAME.ref_placed = true
        ready_to_reforge() -- give the card the dependencies 
        update_reforge_cost() -- update the reforge cost incase the card has already been reforged
    end
end

G.FUNCS.reforge_return = function ()
    if G.reforge_area and G.reforge_area.cards then
        if #G.reforge_area.cards > 0 then
            final_ability_values() -- save the final table (not needed pobably)
            HPTN.move_card(G.reforge_area.cards[1], G.jokers)
            G.GAME.ref_placed = nil
            reset_reforge_cost() -- reset the cost to default
        end
    end
end

G.FUNCS.hotpot_tname_toggle_reforge = function () -- takn from deliveries
    if (G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)) then return end
    stop_use()
    local sign_sprite = G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object
    if not G.HP_TNAME_REFORGE_VISIBLE then
		ease_background_colour({new_colour = G.C.BLACK, special_colour = G.C.RED, tertiary_colour = darken(G.C.BLACK,0.4), contrast = 3})
        G.shop.alignment.offset.y = -35
        G.HP_TNAME_REFORGE_VISIBLE = true
		simple_add_event(function()
            sign_sprite.pinch.y = true
            delay(0.5)
            simple_add_event(function()
                sign_sprite.atlas = G.ANIMATION_ATLAS["hpot_tname_shop_sign"]
                sign_sprite.pinch.y = false
                return true
            end)
            return true
        end, { trigger = "after", delay = 0 })
        play_sound("hpot_sfx_whistleup", 1.3, 0.25)
    else
        if G.reforge_area and G.reforge_area.cards and #G.reforge_area.cards > 0 then
            local acard = G.reforge_area.cards[1]
            final_ability_values()
            HPTN.move_card(acard, G.jokers)
            G.GAME.ref_placed = nil
            reset_reforge_cost()
        end
        ease_background_colour_blind(G.STATES.SHOP)
        G.shop.alignment.offset.y = -5.3
        G.HP_TNAME_REFORGE_VISIBLE = false
        G.FUNCS.reforge_return()
		simple_add_event(function()
            sign_sprite.pinch.y = true
            delay(0.5)
            simple_add_event(function()
                sign_sprite.atlas = G.ANIMATION_ATLAS["shop_sign"]
                sign_sprite.pinch.y = false
                return true
            end)
            return true
        end, { trigger = "after", delay = 0 })
        play_sound("hpot_sfx_whistledown", 1.3, 0.25)
    end
end


-- self explanatory
function G.FUNCS.can_reforge_with_creds(e)
    if G.PROFILES[G.SETTINGS.profile].TNameCredits < G.GAME.cost_credits or not G.GAME.ref_placed then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.PURPLE
            e.config.button = 'reforge_with_credits'
        end
    end

function G.FUNCS.can_reforge_with_dollars(e)
    if not G.GAME.used_vouchers["v_hpot_ref_dollars"] or G.GAME.dollars < G.GAME.cost_dollars or not G.GAME.ref_placed then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
    else
            e.config.colour = G.C.GOLD
            e.config.button = 'reforge_with_dollars'
        end
    end

function G.FUNCS.can_reforge_with_joker_exchange(e)
    if not G.GAME.used_vouchers["v_hpot_ref_joker_exc"] or G.GAME.spark_points < G.GAME.cost_sparks or not G.GAME.ref_placed then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.BLUE
            e.config.button = 'reforge_with_sparks'
        end
    end
    
function G.FUNCS.can_reforge_with_plincoins(e)
    if not G.GAME.used_vouchers["v_hpot_ref_joker_exc"] or G.GAME.plincoins < G.GAME.cost_plincoins or not G.GAME.ref_placed then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = SMODS.Gradients["hpot_plincoin"]
            e.config.button = 'reforge_with_plincoins'
        end
    end
--

G.FUNCS.reforge_with_credits = function ()
    HPTN.ease_credits(-G.GAME.cost_credits)
    set_card_reforge()
    update_reforge_cost()
    reforge_card(G.reforge_area.cards[1])
    play_sound("hpot_tname_reforge")
end

G.FUNCS.reforge_with_dollars = function ()
    ease_dollars(-G.GAME.cost_dollars)
    set_card_reforge()
    update_reforge_cost()
    reforge_card(G.reforge_area.cards[1])
    play_sound("hpot_tname_reforge")
end

G.FUNCS.reforge_with_sparks = function ()
    ease_spark_points(-G.GAME.cost_sparks)
    set_card_reforge()
    update_reforge_cost()
    reforge_card(G.reforge_area.cards[1])
    play_sound("hpot_tname_reforge")
end

G.FUNCS.reforge_with_plincoins = function ()
    ease_plincoins(-G.GAME.cost_plincoins)
    set_card_reforge()
    update_reforge_cost()
    reforge_card(G.reforge_area.cards[1])
    play_sound("hpot_tname_reforge")
end
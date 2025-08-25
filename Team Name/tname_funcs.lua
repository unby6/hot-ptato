function sticker_check(area, sticker) -- make "sticker" a table check?
	local amount = 0
	for k, v in pairs(area) do
		if v and v.ability then
			if sticker then
				if v.ability[sticker] or v[sticker] then
					amount = amount + 1
				end
			else
				for l, b in pairs(SMODS.Stickers) do
					if v.ability[l] or v[l] then
						amount = amount + 1
					end
				end
			end
		else
			amount = 0
		end
	end
	return amount
end

function poll_sticker(guaranteed, card)
	local stickers = {}
	for k, v in pairs(SMODS.Stickers) do
		if card ~= nil then -- check if a card is specified
			if not card.ability[k] and not card[k] then -- check if the card has the stickers
				stickers[#stickers + 1] = k
			end
		else -- return all stickers if a card is not specified
			stickers[#stickers + 1] = v
		end
	end
	local chosen_one = pseudorandom_element(stickers)
	if not guaranteed then
		if not (pseudorandom("poll_sticker") < tonumber(chosen_one.rate)) then
			chosen_one = nil
		end
	end
	if chosen_one then
		return chosen_one.key
	end
end

function add_tables(tables) -- yet again, there is probably a better way to do this but im lazy to find how
	local ful_tab = {}
	for i = 1, #tables do
		for i2 = 1, #tables[i] do
			ful_tab[#ful_tab + 1] = tables[i][i2]
		end
	end
	return ful_tab
end



function HPTN.ease_credits(amount, instant)
    amount = amount or 0
  local function _mod(mod)  -- Taken from ease_plincoins()
        local dollar_UI = G.HUD:get_UIE_by_ID('credits_UI_text')
        mod = mod or 0
        local text = '+'
        local col = G.C.PURPLE
        if mod < 0 then
            text = '-'
            col = G.C.RED
        end

        G.PROFILES[G.SETTINGS.profile].TNameCredits = G.PROFILES[G.SETTINGS.profile].TNameCredits + amount
		G.GAME.credits_text = G.PROFILES[G.SETTINGS.profile].TNameCredits
    
        dollar_UI.config.object:update()
        if amount ~= 0 then
            G.HUD:recalculate()
            --Popup text next to the chips in UI showing number of chips gained/lost
            attention_text({
            text = text..tostring(math.abs(mod)),
            scale = 0.8, 
            hold = 0.7,
            cover = dollar_UI.parent,
            cover_colour = col,
            align = 'cm',
            })
            --Play a chip sound
            play_sound('coin1')
        end
    end

	if instant then
        _mod(amount)
    else
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            _mod(amount)
            return true
        end
        }))
    end

	G:save_progress()
end

function HPTN.set_credits(amount)
	G.PROFILES[G.SETTINGS.profile].TNameCredits =  amount
	G.GAME.credits_text = G.PROFILES[G.SETTINGS.profile].TNameCredits
end

function HPTN.check_if_enough_credits(cost)
	local credits = G.PROFILES[G.SETTINGS.profile].TNameCredits
	if (credits - cost) >= 0 then
		return true
	end
	return false
end


G.FUNCS.credits_UI_set = function(e)
  local new_chips_text = number_format(G.PROFILES[G.SETTINGS.profile].TNameCredits)
  if G.GAME.credits_text ~= new_chips_text then
    e.config.scale = math.min(0.8, scale_number(G.PROFILES[G.SETTINGS.profile].TNameCredits, 1.1))
    G.GAME.credits_text = new_chips_text
  end
end


-- Reforge menu

--- Custom function to make buttons:tm:
---@param args {label:{}[],w:number,h:number,colour:table,text_scale:number,text_col:table,font:string,func:string,button:string,type:"R"|"C"}
---@return table node The button node
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
    G.reforge_area = CardArea(0,0,1,1,{})
	return 
	{n = G.UIT.R, config = {minw = 3, minh = 5.5, colour = G.C.CLEAR}, nodes = {}},
	{n = G.UIT.R, config = {minw = 3, minh = 9, colour = G.C.CLEAR, align = "cm"}, nodes = {
		{n = G.UIT.R, config = {align = "cm", minw = 2, minh = 3}, nodes = {
			{n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
				{n = G.UIT.R, config = {align = "cm"}, nodes = {{n = G.UIT.T, config = {text = "REFORGE", colour = G.C.GREY, scale = 0.7, align = "cm"}}}},
				{n = G.UIT.R, config = {minh = 0.2}},
				UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_credits")},{ref_table = G.PROFILES[G.SETTINGS.profile], ref_value = "TNameCredits"}}},
                    text_scale = 0.5,
                    button = 'hotpot_tname_toggle_reforge',
                    colour = G.C.PURPLE
                },
                UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_dollars")},{ref_table = G.PROFILES[G.SETTINGS.profile], ref_value = "TNameCredits"}}},
                    text_scale = 0.5,
                    button = 'can_reforge_with_dollars',
                    colour = G.C.GOLD
                },
                UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_joker_exchange"), font = "hpot_plincoin"},{ref_table = G.PROFILES[G.SETTINGS.profile], ref_value = "TNameCredits"}}},
                    text_scale = 0.5,
                    button = 'can_reforge_with_joker_exchange',
                    colour = G.C.BLUE
                },
                UIBox_adv_button{
                    label = {{{localize("hotpot_reforge_plincoins"), font = "hpot_plincoin"},{ref_table = G.PROFILES[G.SETTINGS.profile], ref_value = "TNameCredits"}}},
                    text_scale = 0.5,
                    button = 'can_reforge_with_plincoins',
                    colour = SMODS.Gradients["hpot_plincoin"]
                },
			}},
			{n = G.UIT.C, config = {minw = 0.1}},
			{n = G.UIT.C, config = {align = "cm", colour = G.C.GREY, r = 0.1, padding = 0.2}, nodes = {
				{n = G.UIT.C, config = {colour = G.C.BLACK, minw = 4, minh = 5, r = 0.1, align = "tm", padding = 0.1}, nodes = {
					{n = G.UIT.T, config = {text = "REFORGE CARD", colour = G.C.GREY, scale = 0.4, align = "tm"}},
                    {n = G.UIT.O, config = {object = G.reforge_area}}
				}},
			}},
		}}
	}},
	{n = G.UIT.R, config = {minw = 3, minh = 3, colour = G.C.CLEAR}, nodes = {}}
end

G.FUNCS.hotpot_tname_toggle_reforge = function ()
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
        play_sound("hpot_sfx_whistleup", nil, 0.25)
    else
        ease_background_colour_blind(G.STATES.SHOP)
        G.shop.alignment.offset.y = -5.3
        G.HP_TNAME_REFORGE_VISIBLE = false
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
        play_sound("hpot_sfx_whistledown", nil, 0.25)
    end
end

function G.FUNCS.can_reforge_with_dollars(e)
    if not G.GAME.used_vouchers["v_hpot_ref_dollars"] then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.GOLD
            e.config.button = 'hotpot_tname_toggle_reforge'
        end
    end

function G.FUNCS.can_reforge_with_joker_exchange(e)
    if not G.GAME.used_vouchers["v_hpot_ref_joker_exc"] then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.BLUE
            e.config.button = 'hotpot_tname_toggle_reforge'
        end
    end
    
function G.FUNCS.can_reforge_with_plincoins(e)
    if not G.GAME.used_vouchers["v_hpot_ref_joker_exc"] then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = SMODS.Gradients["hpot_plincoin"]
            e.config.button = 'hotpot_tname_toggle_reforge'
        end
    end

function add_round_eval_credits(config)  --taken straight from plincoin.lua (yet again thank you to whoever added these)
    local config = config or {}
    local width = G.round_eval.T.w - 0.51
    local num_dollars = config.credits or 1
    local scale = 0.9
    
    if not G.round_eval.divider_added then
    G.E_MANAGER:add_event(Event({
        trigger = 'after',delay = 0.25,
        func = function() 
            local spacer = {n=G.UIT.R, config={align = "cm", minw = width}, nodes={
                {n=G.UIT.O, config={object = DynaText({string = {'......................................'}, colours = {G.C.WHITE},shadow = true, float = true, y_offset = -30, scale = 0.45, spacing = 13.5, font = G.LANGUAGES['en-us'].font, pop_in = 0})}}
            }}
            G.round_eval:add_child(spacer,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
            return true
        end
    }))
  end
    delay(0.6)
    G.round_eval.divider_added = true

    delay(0.2)

        G.E_MANAGER:add_event(Event({
            trigger = 'before',delay = 0.5,
            func = function()
                --Add the far left text and context first:
                local left_text = {}
                if config.name == 'credits' then
                  table.insert(left_text, {n=G.UIT.T, config={text = config.credits, font = config.font, scale = 0.8*scale, colour = G.C.PURPLE, shadow = true, juice = true}})
                  if G.GAME.modifiers.hands_to_credits then
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {" "..localize{type = 'variable', key = 'hotpot_credits_cashout2', vars = {(G.GAME.credits_cashout or 0), (G.GAME.credits_cashout2 or 0)}}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                  else
                    table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = {" "..localize{type = 'variable', key = 'hotpot_credits_cashout', vars = {G.GAME.credits_cashout or 0}}}, colours = {G.C.UI.TEXT_LIGHT}, shadow = true, pop_in = 0, scale = 0.4*scale, silent = true})}})
                  end
                elseif string.find(config.name, 'joker') then
                  table.insert(left_text, {n=G.UIT.O, config={object = DynaText({string = localize{type = 'name_text', set = config.card.config.center.set, key = config.card.config.center.key}, colours = {G.C.FILTER}, shadow = true, pop_in = 0, scale = 0.6*scale, silent = true})}})
                end
                    local full_row = {n=G.UIT.R, config={align = "cm", minw = 5}, nodes={
                    {n=G.UIT.C, config={padding = 0.05, minw = width*0.55, minh = 0.61, align = "cl"}, nodes=left_text},
                    {n=G.UIT.C, config={padding = 0.05,minw = width*0.45, align = "cr"}, nodes={{n=G.UIT.C, config={align = "cm", id = 'dollar_'..config.name},nodes={}}}}
                }}

                G.round_eval:add_child(full_row,G.round_eval:get_UIE_by_ID('bonus_round_eval'))
                play_sound('cancel', config.pitch or 1)
                play_sound('highlight1',( 1.5*config.pitch) or 1, 0.2)
                if config.card then config.card:juice_up(0.7, 0.46) end
                return true
            end
        }))
        local dollar_row = 0
        if num_dollars > 60 then
            G.E_MANAGER:add_event(Event({
                trigger = 'before',delay = 0.38,
                func = function()
                    G.round_eval:add_child(
                            {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={
                                {n=G.UIT.O, config={object = DynaText({string = "c",colours = {G.C.PURPLE}, shadow = true, pop_in = 0, scale = 0.65, float = true})}}
                            }},
                            G.round_eval:get_UIE_by_ID('dollar_'..config.name))

                    play_sound('coin3', 0.9+0.2*math.random(), 0.7)
                    play_sound('coin6', 1.3, 0.8)
                    return true
                end
            }))
        else
            for i = 1, num_dollars or 1 do
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',delay = 0.18 - ((num_dollars > 20 and 0.13) or (num_dollars > 9 and 0.1) or 0),
                    func = function()
                        if i%30 == 1 then 
                            G.round_eval:add_child(
                                {n=G.UIT.R, config={align = "cm", id = 'dollar_row_'..(dollar_row+1)..'_'..config.name}, nodes={}},
                                G.round_eval:get_UIE_by_ID('dollar_'..config.name))
                                dollar_row = dollar_row+1
                        end

                        local r = {n=G.UIT.T, config={text = "c", colour = G.C.PURPLE, scale = ((num_dollars > 20 and 0.28) or (num_dollars > 9 and 0.43) or 0.58), shadow = true, hover = true, can_collide = false, juice = true}}
                        play_sound('coin3', 0.9+0.2*math.random(), 0.7 - (num_dollars > 20 and 0.2 or 0))
                        
                        if config.name == 'blind1' then 
                            G.GAME.current_round.dollars_to_be_earned = G.GAME.current_round.dollars_to_be_earned:sub(2)
                        end

                        G.round_eval:add_child(r,G.round_eval:get_UIE_by_ID('dollar_row_'..(dollar_row)..'_'..config.name))
                        G.VIBRATION = G.VIBRATION + 0.4
                        return true
                    end
                }))
            end
        end

      -- might cause issues. Dollars cashout adds up everything and sends "bottom" cashout. Might need similar implementation if more plincoin cashouts are added - im leaving this in
      G.GAME.current_round.credits = G.GAME.current_round.credits + config.credits

end
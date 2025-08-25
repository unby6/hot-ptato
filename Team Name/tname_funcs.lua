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
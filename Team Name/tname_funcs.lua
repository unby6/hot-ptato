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
        local text = '+c.'
        local col = G.C.BLUE
        if mod < 0 then
            text = '-c.'
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
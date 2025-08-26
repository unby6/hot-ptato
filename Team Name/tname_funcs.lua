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

--- Polls a random sticker from the set of stickers according to a uniform distribution.
---
--- @param guaranteed boolean Controls whether or not you are guaranteed to get a sticker.
---
--- @param card table|nil The card to consider. If it's provided, the stickers that the card has (if it has any) are excluded from the sticker pool.
function poll_sticker(guaranteed, card)
	guaranteed = guaranteed or false

	local stickers = {}
	local ability = card and card.ability or nil
	
	for k, v in pairs(SMODS.Stickers) do
		-- Check if the current sticker is on the current card (if the current card exists)
		if card and (ability[k] or card[k]) then
			goto poll_sticker_skip
		end
		
		-- Append the sticker to the array
		stickers[#stickers + 1] = v
		
		::poll_sticker_skip::
	end
	
	if #stickers == 0 then return nil end
	
	-- Check if chance to get sticker is met
	local candidate = pseudorandom_element(stickers)
	if guaranteed or pseudorandom("poll_sticker_rate") < tonumber(candidate.rate) then
		return candidate.key
	end
	
	return nil
end

--- Polls a random modification from the set of modifications according to their weighted probabilities.
---
--- @param chance number A multiplier on the chance of receiving any modification. Defaults to a 20% chance (value = 1/5) to give a modification if not specified.
---
--- @param card table|nil The card to consider. If it's provided, the modification that the card has (if it does) is excluded from the modification pool.
---
--- @param morality table|nil A table specifying which categories of modifications are eligible. The fields `GOOD`, `BAD`, and `MISC` are all booleans. Defaults to all fields being true if not specified.
---
--- @param odds table|nil A table specifying relative odds for each morality category. The fields `GOOD`, `BAD`, and `MISC` are all numbers which are normalized across enabled categories to sum to 100% (value = 1).
---  Defaults to GOOD = 1/2, BAD = 1/2, MISC = 0 if not specified.
function poll_modification(chance, card, morality, odds)
	chance = chance or 1/5
	card = card or nil
	
	morality = morality or {} -- Target for which kind of modifications we're targetting specifically
	morality.GOOD = (morality.GOOD == nil) and true or morality.GOOD
	morality.BAD = (morality.BAD == nil) and true or morality.BAD
	morality.MISC = (morality.MISC == nil) and true or morality.MISC
	
	odds = odds or {}
	odds.GOOD = odds.GOOD or 1/2 -- Odds for a good modification
	odds.BAD = odds.BAD or 1/2 -- Odds for a bad modification
	odds.MISC = odds.MISC or 0 -- Odds for any modification that slips through the cracks

	-- Make sure the odds add up to 100% no matter what
	local sanity_sum = (morality.GOOD and odds.GOOD) + (morality.BAD and odds.BAD) + (morality.MISC and odds.MISC)
	if sanity_sum ~= 1 then
		if sanity_sum == 0 then -- If there are no odds
			odds.GOOD = 1/2
			odds.BAD = 1/2
			odds.MISC = (morality.GOOD or morality.BAD) and 0 or 1
		end 
		
		-- Normalize the odds
		sanity_sum = (morality.GOOD and odds.GOOD) + (morality.BAD and odds.BAD) + (morality.MISC and odds.MISC)
		
		odds.GOOD = odds.GOOD / sanity_sum
		odds.BAD = odds.BAD / sanity_sum
		odds.MISC = odds.MISC / sanity_sum
	end

	local good_modifications = {}
	local bad_modifications = {}
	local misc_modifications = {}
	
	local ability = card and card.ability or nil
	for k, v in pairs(HPTN.Modifications) do
		if card and ability[k] then
			goto poll_modification_skip
		end
	
		if v.morality == "GOOD" then
			good_modifications[#good_modifications + 1] = v
		elseif v.morality == "BAD" then
			bad_modifications[#bad_modifications + 1] = v
		else
			misc_modifications[#misc_modifications + 1] = v
		end
		
		::poll_modification_skip::
	end
	
	local random_value = pseudorandom("poll_modification")
	
	if morality.GOOD and #good_modifications > 0 then
		if random_value < odds.GOOD * chance then
			return pseudorandom_element(good_modifications)
		end
		random_value = random_value - odds.GOOD * chance
	end
	if morality.BAD and #bad_modifications > 0 then
		if random_value < odds.BAD * chance then
			return pseudorandom_element(bad_modifications)
		end
		random_value = random_value - odds.BAD * chance
	end
	if morality.MISC and #misc_modifications > 0 then
		if random_value < odds.MISC * chance then
			return pseudorandom_element(misc_modifications)
		end
	end

	return nil
end

--- Gets the key for the modification of a card, located in card.ability.
---
--- @param card table|nil The card to consider for modification inquiry.
function get_modification(card)
	if not card then return nil end
	
	local ability = card.ability
	for k, v in pairs(HPTN.Modifications) do
		if ability[k] then
			return k
		end
	end
	
	return nil
end

--- Reforges a card, replacing its current modification (if it has one) with its new one.
---
--- @param card table|nil The card to consider for reforging.
function reforge_card(card)
	if not card then return nil end

	local reforge_money_v2_voucher_acquired = G.GAME.used_vouchers["internship"] -- Reforging no longer increases costs
	local reforge_degree_v2_voucher_acquired = G.GAME.used_vouchers["masters"] -- Reforging can never result in a bad modifier
	
	local chance = 1 -- 100% chance to get a modification when you reforge
	-- card param is given by the parameter to this function
	local morality = reforge_degree_v2_voucher_acquired and { GOOD = true, BAD = false, MISC = false } or { GOOD = true, BAD = true, MISC = true }
	local odds = reforge_degree_v2_voucher_acquired and { GOOD = 1/2, BAD = 1/2, MISC = 0 } or { GOOD = 1, BAD = 0, MISC = 0 }
	
	local old_modification = get_modification(card)
	local new_modification = poll_modification(chance, card, morality, odds)
	
	if old_modification then
		HPTN.Modifications[old_modification]:apply(card,false)
	end
	if new_modification then
		HPTN.Modifications[new_modification.key]:apply(card,true)
		card.ability.reforge_count = (card.ability.reforge_count or 0) + 1
	end
end



--- Checks the amount of money it would cost to reforge a given card, in dollars.
---
--- @param card table|nil The card to consider for reforging.
function reforge_cost(card)
	if not card then return nil end
	
	local cost_initial = (card.ability.reforge_count or 0) + (card.ability.sell_cost or 0)
	
	local discount = reforge_discounts()
	local cost_final = cost_initial - discount

	return cost_final
end


-- not needed
--- @param card table|nil Card to give reforge values
function ready_to_reforge(card)
    card = card or G.reforge_area.cards[1]
    if not card.ready_for_reforging then
    
        card.ready_for_reforging = true

        card.ability.reforge_dollars = 0
        card.ability.reforge_credits = 0
        card.ability.reforge_sparks = 0
        card.ability.reforge_plincoins = 0
    end
end

--- @param card table|nil to update the card's values
function set_card_reforge(card)
    card = card or G.reforge_area.cards[1]
    card.ability.reforge_dollars = card.ability.reforge_dollars + reforge_cost(card)
    card.ability.reforge_credits = card.ability.reforge_credits + convert_currency(reforge_cost(card), "DOLLAR", "CREDIT")
    card.ability.reforge_sparks = card.ability.reforge_sparks + convert_currency(reforge_cost(card), "DOLLAR", "SPARKLE")
    card.ability.reforge_plincoins = card.ability.reforge_plincoins + convert_currency(reforge_cost(card), "DOLLAR", "PLINCOIN")
end

--- @param card table|nil Card to use to update the costs
function update_reforge_cost(card)
    card = card or G.reforge_area.cards[1]
    G.GAME.cost_dollars = G.GAME.cost_dollars + card.ability.reforge_dollars
    G.GAME.cost_credits =  G.GAME.cost_credits + card.ability.reforge_credits
    G.GAME.cost_sparks =  G.GAME.cost_sparks + card.ability.reforge_sparks
    G.GAME.cost_plincoins = G.GAME.cost_plincoins + card.ability.reforge_plincoins
end

-- reseting the reforge cost
function reset_reforge_cost()
    G.GAME.cost_dollars = G.GAME.cost_dollar_default 
    G.GAME.cost_credits =  G.GAME.cost_credit_default 
    G.GAME.cost_sparks =  G.GAME.cost_spark_default 
    G.GAME.cost_plincoins = G.GAME.cost_plincoin_default 
end

-- save final values

-- not needed (?)
--- @param card table|nil to save the card's values
function final_ability_values(card)
    card = card or G.reforge_area.cards[1]
    card.ability.reforge_dollars = G.GAME.cost_dollars - G.GAME.cost_dollar_default 
    card.ability.reforge_credits = G.GAME.cost_credits - G.GAME.cost_credit_default 
    card.ability.reforge_sparks = G.GAME.cost_sparks - G.GAME.cost_spark_default 
    card.ability.reforge_plincoins = G.GAME.cost_plincoins - G.GAME.cost_plincoin_default 
end

--- Totals up all of the flat-rate discounts available for reforging. Feel free to list more here when needed.
function reforge_discounts()
	local total = 0
	
	local reforge_money_v1_voucher_acquired = G.GAME.used_vouchers["costcutting"] -- Reduces cost of reforging by $2
	
	if reforge_money_v1_voucher_acquired then
		total = total + 2
	end
	
	return total
end

--- Converts currency from one type into another type.
---
--- @param amount number The amount of money in the original starting currency.
--- @param starting_currency "DOLLAR"|"CREDIT"|"SPARKLE"|"PLINCOIN" The currency to convert from. Valid options for currencies currently include: "DOLLAR", "CREDIT", "SPARKLE", "PLINCOIN".
--- @param ending_currency "DOLLAR"|"CREDIT"|"SPARKLE"|"PLINCOIN" The currency to convert to. Valid options for currencies currently include: "DOLLAR", "CREDIT", "SPARKLE", "PLINCOIN".
function convert_currency(amount, starting_currency, ending_currency)
	local money = amount

	-- First, convert everything into plincoin, the least valuable of all of the currencies.
	local dollar_to_plincoin  = 3
	local credit_to_plincoin  = 15
	local sparkle_to_plincoin = 12495
	
	if     starting_currency == "DOLLAR"  then money = money * dollar_to_plincoin
	elseif starting_currency == "CREDIT"  then money = money * credit_to_plincoin
	elseif starting_currency == "SPARKLE" then money = money * sparkle_to_plincoin
	elseif starting_currency ~= "PLINCOIN" then return nil end
	
	-- Next, convert from plincoin into the desired currency.
	local plincoin_to_dollar  = 1 / dollar_to_plincoin
	local plincoin_to_credit  = 1 / credit_to_plincoin
	local plincoin_to_sparkle = 1 / sparkle_to_plincoin
	
	if     ending_currency == "DOLLAR"  then money = money * plincoin_to_dollar
	elseif ending_currency == "CREDIT"  then money = money * plincoin_to_credit
	elseif ending_currency == "SPARKLE" then money = money * plincoin_to_sparkle
	elseif ending_currency ~= "PLINCOIN" then return nil end
	
	return math.ceil(money)
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
            if amount > 0 then
            play_sound("hpot_tname_gaincred")
            else
            play_sound("hpot_tname_losecred")
            end
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
				{n = G.UIT.R, config = {align = "cm"}, nodes = {{n = G.UIT.T, config = {text = "REFORGE", colour = G.C.GREY, scale = 0.7, align = "cm"}}}},
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
                    {n = G.UIT.R, config = {align = "tm"}, nodes = {{n = G.UIT.T, config = {text = "PLACE CARD TO REFORGE", colour = G.C.GREY, scale = 0.4, align = "tm"}}}},
                    {n = G.UIT.R, config = {align = "cm",minw = G.CARD_W, minh = G.CARD_H}, nodes = {{n = G.UIT.O, config = {object = G.reforge_area, align = "cm"}}}},
				}},
			}},
		}},
        {n = G.UIT.R, config = {minh = 0.2}},
        {n = G.UIT.R, config = {align = "cm"}, nodes = {
            UIBox_adv_button{
                label = {{{"Place"}}},
                text_scale = 0.5,
                w = 3, h = 1,
                button = 'reforge_place',
                func = "place_return_reforge",
                colour = G.C.GREEN,
                type = "C"
            },
            {n = G.UIT.C, config = {align = "cm", padding = 0.1}},
            UIBox_adv_button{
                label = {{{"Return"}}},
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

function HPTN.move_card(card, _area)
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
    if (G.jokers and G.jokers.highlighted and #G.jokers.highlighted <= 0) or (G.reforge_area and #G.reforge_area.cards > 0) then
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
        ready_to_reforge()
        update_reforge_cost()
    end
end

G.FUNCS.reforge_return = function ()
    if G.reforge_area and G.reforge_area.cards then
        if #G.reforge_area.cards > 0 then
            final_ability_values()
            HPTN.move_card(G.reforge_area.cards[1], G.jokers)
            G.GAME.ref_placed = nil
            reset_reforge_cost()
        end
    end
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

G.FUNCS.reforge_with_credits = function ()
    HPTN.ease_credits(-G.GAME.cost_credits)
    set_card_reforge()
    update_reforge_cost()
    reforge_card(G.reforge_area.cards[1])
end

G.FUNCS.reforge_with_dollars = function ()
    ease_dollars(-G.GAME.cost_dollars)
    set_card_reforge()
    update_reforge_cost()
    eforge_card(G.reforge_area.cards[1])
end

G.FUNCS.reforge_with_sparks = function ()
    ease_spark_points(-G.GAME.cost_sparks)
    set_card_reforge()
    update_reforge_cost()
    eforge_card(G.reforge_area.cards[1])
end

G.FUNCS.reforge_with_plincoins = function ()
    ease_plincoins(-G.GAME.cost_plincoins)
    set_card_reforge()
    update_reforge_cost()
    eforge_card(G.reforge_area.cards[1])
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


function HPTN.perc(mod, perc)
	local per = (mod / 100)* perc
	return per
end

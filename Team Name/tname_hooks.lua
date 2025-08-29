local remove_old = Card.remove
function Card:remove()
	if self.added_to_deck or (self.area and (self.area == G.hand or self.area == G.deck)) then --guys idfk what im doing please help me im begging please aaaaaaaaaaaaaaaaaaaaaa
		SMODS.calculate_context({
			hpot_destroy = true,
			hpot_destroyed = self,
		})
	end
	return remove_old(self)
end

local use_old = Card.use_consumeable
function Card:use_consumeable(area, copier)
	self.hpot_cons_used = true
	return use_old(self, area, copier)
end

local joker_calc_old = Card.calculate_joker
function Card:calculate_joker(context)
	if self and not self.prevent_trigger then
		return joker_calc_old(self, context)
	end
end

local igo = Game.init_game_object
Game.init_game_object = function(self)
	local ret = igo(self)
	ret.overclock_timer = 3
	ret.credits_text = G.PROFILES[G.SETTINGS.profile].TNameCredits
	ret.credits_cashout = 2
	ret.credits_cashout2 = 2
	ret.current_round.credits = 0

	ret.cost_credits = 150
	ret.cost_dollars = 30
	ret.cost_sparks = 125000
	ret.cost_plincoins = 10

	ret.cost_credit_default = 150
	ret.cost_dollar_default = 30
	ret.cost_spark_default = 125000
	ret.cost_plincoin_default = 10

	--ret.sticker_timer = 0

	ret.current_team_name_member = 1

	ret.creditable_rate = 0.06

	return ret
end

local click_old = Card.click
function Card:click()
	local ret = click_old(self)
	local can_spin = nil
	if G.your_collection then
		for i = 1, #G.your_collection do
			if self and self.area and (self.area == G.your_collection[i]) then
				can_spin = true
			end
		end
	end
	if self and self.ability.hpot_spinning and (self.highlighted == true or can_spin) then
		play_sound("hpot_sfx_tname_flip")
		self:flip()
	end
	return ret
end

local ref = G.FUNCS.can_buy
function G.FUNCS.can_buy(e)
	if e.config.ref_table.config.center.credits then
		if
			(not HPTN.check_if_enough_credits(e.config.ref_table.config.center.credits))
			and e.config.ref_table.config.center.credits
		then
			e.config.colour = G.C.UI.BACKGROUND_INACTIVE
			e.config.button = nil
		else
			e.config.colour = G.C.ORANGE
			e.config.button = "buy_from_shop"
		end
	else
		return ref(e)
	end
end

local can_open_old = G.FUNCS.can_open
function G.FUNCS.can_open(e)
	local card = e.config.ref_table.config.center
	if card.credits then
		if (not HPTN.check_if_enough_credits(card.credits)) and card.credits then
			e.config.colour = G.C.UI.BACKGROUND_INACTIVE
			e.config.button = nil
		else
			e.config.colour = G.C.GREEN
			e.config.button = "use_card"
		end
	else
		return can_open_old(e)
	end
end

SMODS.Joker({
	key = "the_arrow",
	atlas = "tname_wheels",
	cost = 10,
	unlocked = true,
	discovered = false,
	blueprint_compat = true,
	no_collection = true,
	pos = {
		x = 0,
		y = 0,
	},
	 
	
})


-- was from JoyousSpring (originally)
local cardarea_align_cards_ref = CardArea.align_cards
function CardArea:align_cards()
	cardarea_align_cards_ref(self)
	if G.GAME.should_rotate then
		if not G.GAME.wheel_reset then
			G.GAME.wheel_reset = true
		end
		if not G.GAME.vval then
			G.GAME.vval = math.random(1, 63)
			G.GAME.winning_vval = (G.GAME.vval / 10)
		end
		if self == G.wheel_area5 then
			for k, card in ipairs(self.cards) do
			if G.GAME.keep_rotation then
				card.T.r = G.GAME.keep_rotation
			end
				if not G.GAME.wheel_card then
					G.GAME.wheel_card = card
				end
				if G.GAME.rotating then

					G.E_MANAGER:add_event(Event({
						trigger = "immediate",
						delay = 1,
						func = function()

							for i = 1, G.GAME.vval+0.1 do

								card.T.r = card.T.r + 0.1

								if math.ceil(card.T.r*10) == G.GAME.vval then
									G.GAME.keep_rotation = card.T.r
									if in_between(0.1, 0.89, G.GAME.keep_rotation) then
										wheel_reward("reward_1")
									elseif in_between(0.89, 2.3, G.GAME.keep_rotation) then
										wheel_reward("reward_2")
									elseif in_between(2.3, 2.8, G.GAME.keep_rotation) then
										wheel_reward("reward_3")
									elseif in_between(2.8, 3.4, G.GAME.keep_rotation) then
										wheel_reward("reward_4")
									elseif in_between(3.4, 3.9, G.GAME.keep_rotation) then
										wheel_reward("reward_5")
									elseif in_between(3.9, 5.3, G.GAME.keep_rotation) then
										wheel_reward("reward_6")
									elseif in_between(5.3, 5.8, G.GAME.keep_rotation) then
										wheel_reward("reward_7")
									elseif in_between(5.8, 6.3, G.GAME.keep_rotation) then
										wheel_reward("reward_8")
									end
										
									G.GAME.rotating = nil
								end
							end
							return true
						end,
					}))
				end
			end
		end
	end
end


-- remove after ( for testing )
function set_wheel(no_arrow)
	if not no_arrow then
		SMODS.add_card{key = "j_hpot_the_arrow", area = G.wheel_area5}
	end

		local wheel_areas2 = {
		G.wheel_area,
		G.wheel_area2,
		G.wheel_area3,
		G.wheel_area4,
		G.wheel_area6,
		G.wheel_area7,
		G.wheel_area8,
		G.wheel_area9,
	}

	for k, v in pairs(wheel_areas2) do
		if #v.cards == 0 then
			generate_wheel_rewards(v)
		end
	end
end

function in_between(num1, num2, numB)
	if numB >= num1 and numB < num2 then
		return true
	end
end

function reset_wheel() 
	G.GAME.should_rotate = nil
	G.GAME.wheel_card = nil
	G.GAME.rotating = nil
	G.GAME.vval = nil
	G.GAME.keep_rotation = nil
end

function change_wheel()
	if G.wheel_area.cards[1] then
		SMODS.destroy_cards(G.wheel_area.cards[1])
	end
	SMODS.add_card{key = "j_joker", area = G.wheel_area, stickers = {}}
end


function spin_wheel()
	G.GAME.should_rotate = true
	G.GAME.rotating = true

	local event
	event = Event {
    blockable = false,
    blocking = false,
    trigger = "after",
    delay = 2,
    timer = "UPTIME",
    func = function()
        reset_wheel()
		return true
    end
	}
	G.E_MANAGER:add_event(event)
end

function wheel_reward(reward)
	if reward == "reward_1" then
		grant_wheel_reward(G.wheel_area, 1)
	elseif reward == "reward_2" then
		grant_wheel_reward(G.wheel_area2, 1)
	elseif reward == "reward_3" then
		grant_wheel_reward(G.wheel_area3, 1)
	elseif reward == "reward_4" then
		grant_wheel_reward(G.wheel_area4, 1)
	elseif reward == "reward_5" then
		grant_wheel_reward(G.wheel_area6, 1)
	elseif reward == "reward_6" then
		grant_wheel_reward(G.wheel_area7, 1)
	elseif reward == "reward_7" then
		grant_wheel_reward(G.wheel_area8, 1)
	elseif reward == "reward_8" then
		grant_wheel_reward(G.wheel_area9, 1)
	end
end

-- transformed the plinko one
function generate_wheel_rewards(_area)
	-- Logic for extra reward with that rarity is kinda ass
	-- didn't have time to think of something better
	if next(find_joker("Tipping Point")) then
		G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Rare + 1
		G.GAME.plinko_rewards.Common = PlinkoLogic.rewards.per_rarity.Common - 1
	else
		G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Rare
		G.GAME.plinko_rewards.Common = PlinkoLogic.rewards.per_rarity.Common
	end

	local rarities = {}
	for rarity, amount in pairs(G.GAME.plinko_rewards) do
		rarities[#rarities + 1] = rarity
	end
	local rarity = pseudorandom_element(rarities)
	local card = SMODS.create_card({
		set = "bottlecap_" .. rarity,
		rarity = rarity,
	})
	if rarity == "Bad" then
		card:set_edition("e_negative")
	else
		card:set_edition()
	end
	card.ability.extra.chosen = rarity
	_area:emplace(card)
end


function grant_wheel_reward(_area, reward_num)
  assert(type(reward_num) == "number", "won_reward must be called with a number")

  local start = G.TIMERS.REAL
  local first_time = true

  draw_card(_area, G.play, 1, 'up', true, _area.cards[reward_num], nil, nil)

  G.E_MANAGER:add_event(Event{delay = 0.5, blocking = false, func = function ()
    play_sound('hpot_tada')
    return true
  end})

  G.E_MANAGER:add_event(Event({
    delay = 5,
    func = function()
      if first_time then
        first_time = false
        
        remove_wheel_rewards()

        G.CONTROLLER:snap_to {node = _area.cards[1]}
      end

      if G.TIMERS.REAL - start < 3 then
        return false
      end

      local card = G.play.cards[1]
      if card then
        card:use_consumeable()
        SMODS.calculate_context({using_consumeable = true, consumeable = card, area = _area})
        card:start_dissolve({G.C.BLACK, G.C.WHITE, G.C.RED, G.C.GREY, G.C.JOKER_GREY}, true, 4)
        play_sound('hpot_bottlecap')
      end

     	set_wheel(true)

      G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
      return true
    end
  }))
end


function remove_wheel_rewards()
	local wheel_areas2 = {
		G.wheel_area,
		G.wheel_area2,
		G.wheel_area3,
		G.wheel_area4,
		G.wheel_area6,
		G.wheel_area7,
		G.wheel_area8,
		G.wheel_area9,
	}

	for k, v in pairs(wheel_areas2) do
		if #v.cards > 0 then
			v.cards[1]:start_dissolve({G.C.BLACK, G.C.WHITE, G.C.RED, G.C.GREY, G.C.JOKER_GREY}, true)
		end
	end
  end


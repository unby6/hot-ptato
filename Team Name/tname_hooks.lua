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

local use_old = Card.use_consumeable  -- for the fragile sticker so it doesnt get destroyed while using a consumable
function Card:use_consumeable(area, copier)
	self.hpot_cons_used = true
	return use_old(self, area, copier)
end

local joker_calc_old = Card.calculate_joker -- preventing joker triggers
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

local click_old = Card.click -- clicked cards with "spinning" spins
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

local ref = G.FUNCS.can_buy -- credits buyable thingy hook
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

local can_open_old = G.FUNCS.can_open -- same for boosters
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


local start_run_old = Game.start_run
function Game:start_run(args)
	start_run_old(self, args)
	if G.jokers and G.jokers.config then
		G.jokers.config.highlighted_limit = G.jokers.config.highlighted_limit + 2 -- set the joker highlight limit to 3 cause its needed by some hanafudas
	end
end

local profile_old = G.UIDEF.profile_option -- for the dynamically updating profile credits amount
function G.UIDEF.profile_option(_profile)
	local ret = profile_old(_profile)
	HPTN.Profile = _profile
	return ret
end
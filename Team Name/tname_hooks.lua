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

local igo = Game.init_game_object
Game.init_game_object = function(self)
	local ret = igo(self)
	ret.overclock_timer = 3
	ret.credits_text = G.PROFILES[G.SETTINGS.profile].TNameCredits
	ret.credits_cashout = 2
	ret.credits_cashout2 = 2
	ret.current_round.credits = 0
	ret.cost_credits = 150
	ret.cost_dollars = 5
	ret.cost_sparks = 10000
	ret.cost_plincoins = 2
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
	    if (not HPTN.check_if_enough_credits(e.config.ref_table.config.center.credits)) and (e.config.ref_table.config.center.credits) then
            e.config.colour = G.C.UI.BACKGROUND_INACTIVE
            e.config.button = nil
        else
            e.config.colour = G.C.ORANGE
            e.config.button = 'buy_from_shop'
        end
    else
        return ref(e)
    end
end

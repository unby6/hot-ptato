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
	return ret
end

local click_old = Card.click
function Card:click()
	local ret = click_old(self)
	if self and self.ability.hpot_spinning and self.highlighted == true then
		self:flip()
	end
	return ret
end

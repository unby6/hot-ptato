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

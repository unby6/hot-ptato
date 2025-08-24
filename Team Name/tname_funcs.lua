function sticker_check(area)
	local amount = 0
	for k, v in pairs(area) do
		if v and v.ability then
			for l, b in pairs(SMODS.Stickers) do
				if v.ability[l] or v[l] then
					amount = amount + 1
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
		if card ~= nil then
			if not card.ability[k] and not card[k] then
				stickers[#stickers + 1] = k
			end
		else
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

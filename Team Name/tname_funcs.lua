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

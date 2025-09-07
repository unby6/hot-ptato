SMODS.Atlas({key = "hc_capatlas", path = "Horsechicot/bottlecaps.png", px = 34, py = 34, atlas_table = "ASSET_ATLAS"}):register()

SMODS.Consumable { --Plincoin
in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
    name = 'Cryptocurrency',
    key = 'cap_crypto',
    set = 'bottlecap',
    atlas = 'hc_capatlas',
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            ['Common'] = 0.5,
            ['Uncommon'] = 1,
            ['Rare'] = 1.5,
            ['Bad'] = -0.5,
            chosen = 'Common'
        }
    },
    Horsechicot.credit(nil, "lord.ruby"),
    display_size = { h = 34, w = 34},
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['bottlecap'] = true,
        ['bottlecap_Common'] = true,
        ['bottlecap_Uncommon'] = true,
        ['bottlecap_Rare'] = true,
        ['bottlecap_Bad'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra[card.ability.extra.chosen]}}
    end,

    set_badges = function(self, card, badges)
        local color = G.C.BLUE
        if card.ability.extra.chosen == 'Uncommon' then
            color = G.C.GREEN
        elseif card.ability.extra.chosen == 'Rare' then
            color = G.C.RED
        elseif card.ability.extra.chosen == 'Bad' then
            color = G.C.BLACK
        end
 		badges[#badges+1] = create_badge(card.ability.extra.chosen, color, G.C.WHITE, 1 )
 	end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ease_cryptocurrency(card.ability.extra[card.ability.extra.chosen])
    end
}

SMODS.Consumable {
in_pool = function(self, args)
		return true, { allow_duplicates = true }
	end,
    name = 'Chaos',
    key = 'cap_chaos',
    set = 'bottlecap',
    atlas = 'hc_capatlas',
    pos = { x = 1, y = 0 },
    display_size = { h = 34, w = 34},
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['bottlecap'] = true,
        ['bottlecap_Common'] = true,
        ['bottlecap_Uncommon'] = true,
        ['bottlecap_Rare'] = true,
        ['bottlecap_Bad'] = true
    },
    config = {
        extra = {
            ['Common'] = 1,
            ['Uncommon'] = 1,
            ['Rare'] = 1,
            ['Bad'] = 1,
            chosen = 'Common'
        }
    },
    Horsechicot.credit(nil, "lord.ruby"),
    set_badges = function(self, card, badges)
        local color = G.C.BLUE
        if card.ability.extra.chosen == 'Uncommon' then
            color = G.C.GREEN
        elseif card.ability.extra.chosen == 'Rare' then
            color = G.C.RED
        elseif card.ability.extra.chosen == 'Bad' then
            color = G.C.BLACK
        end
 		badges[#badges+1] = create_badge(card.ability.extra.chosen, color, G.C.WHITE, 1 )
 	end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        use_random_bottlecap(self, card)
    end,
    no_chaos = true
}

function use_random_bottlecap(self, card)
    local caps = {}
    for i, v in pairs(G.P_CENTER_POOLS.bottlecap) do
        if not v.no_chaos then
            caps[#caps+1] = v
        end
    end
    local cap = pseudorandom_element(caps, pseudoseed("hc_chaos"))
    local dummy_cap = {
        ability = copy_table(cap.config)
    }
    for i, v in pairs(Card) do
        if type(v) == "function" then
            dummy_cap[i] = function(_, ...)
                return v(card, ...)
            end
        end
    end
    dummy_cap.ability.chosen = card.ability.chosen
    cap:use(dummy_cap)
end
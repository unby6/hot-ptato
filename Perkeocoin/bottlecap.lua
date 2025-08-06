SMODS.Atlas({key = "capatlas", path = "bottlecaps.png", px = 34, py = 34, atlas_table = "ASSET_ATLAS"}):register()

SMODS.ConsumableType {
    key = "bottlecap",
    primary_colour = HEX("EEEEEE"),
    secondary_colour = HEX("E223EB"),
    collection_row = {5, 5},
    shop_rate = 0,
    default = "c_hpot_cap_money",
}

SMODS.ObjectType {
    key = 'bottlecap_Common',
    default = "c_hpot_cap_money"
}
SMODS.ObjectType {
    key = 'bottlecap_Uncommon',
    default = "c_hpot_cap_money"
}
SMODS.ObjectType {
    key = 'bottlecap_Rare',
    default = "c_hpot_cap_money"
}
SMODS.ObjectType {
    key = 'bottlecap_Bad',
    default = "c_hpot_cap_money"
}

SMODS.Consumable { --Money
    name = 'Money',
    key = 'cap_money',
    set = 'bottlecap',
    atlas = 'capatlas',
    pos = { x = 3, y = 0 },
    config = {
        extra = {
            ['Common'] = 5,
            ['Uncommon'] = 10,
            ['Rare'] = 20,
            ['Bad'] = -5,
            chosen = 'Common'
        }
    },
    hotpot_credits = {
        art = {'dottykitty'},
        idea = {''},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },
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

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(card.ability.extra[card.ability.extra.chosen])
    end
}

SMODS.Consumable { --Plincoin
    name = 'Plincoin',
    key = 'cap_plincoin',
    set = 'bottlecap',
    atlas = 'capatlas',
    pos = { x = 5, y = 1 },
    config = {
        extra = {
            ['Common'] = 1,
            ['Uncommon'] = 2,
            ['Rare'] = 3,
            ['Bad'] = -1,
            chosen = 'Common'
        }
    },
    hotpot_credits = {
        art = {'dottykitty'},
        idea = {''},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },
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

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ease_plincoins(card.ability.extra[card.ability.extra.chosen])
    end
}

SMODS.Consumable { --Edition
    name = 'Edition',
    key = 'cap_edition',
    set = 'bottlecap',
    atlas = 'capatlas',
    pos = { x = 2, y = 1 },
    config = {
        extra = {
            ['Common'] = {'e_foil', "Foil"},
            ['Uncommon'] = {'e_holo', "Holographic"},
            ['Rare'] = {'e_polychrome', "Polychrome"},
            chosen = 'Common'
        }
    },
        hotpot_credits = {
        art = {'dottykitty'},
        idea = {''},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },
    display_size = { h = 34, w = 34},
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['bottlecap'] = true,
        ['bottlecap_Common'] = true,
        ['bottlecap_Uncommon'] = true,
        ['bottlecap_Rare'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra[card.ability.extra.chosen][2]}}
    end,

    can_use = function(self, card)
        if G.jokers and G.jokers.cards then
            for k, v in ipairs(G.jokers.cards) do
                if not v.ability.edition then return true end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        local valid = {}
        for k, v in ipairs(G.jokers.cards) do
            if not v.ability.edition then 
                valid[#valid+1] = v
             end
        end
        pseudorandom_element(valid, pseudoseed("cap_edition")):set_edition(card.ability.extra[card.ability.extra.chosen][1])
    end
}

SMODS.Consumable { --Perkeo
    name = 'Perkeo',
    key = 'cap_perkeo',
    set = 'bottlecap',
    atlas = 'capatlas',
    pos = { x = 2, y = 2 },
    config = {
        extra = {
            ['Uncommon'] = 1,
            chosen = 'Uncommon'
        }
    },
    hotpot_credits = {
        art = {'dottykitty'},
        idea = {''},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },
    display_size = { h = 34, w = 34},
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['bottlecap'] = true,
        ['bottlecap_Uncommon'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    can_use = function(self, card)
        if G.consumeables and #G.consumeables.cards > 0 and not (#G.consumeables.cards == 1 and G.consumeables.cards[1] == card) then
            return true
        end
        return false
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            func = function() 
                local _card = copy_card(pseudorandom_element(G.consumeables.cards, pseudoseed('perkeo_cap')), nil)
                _card:set_edition({negative = true}, true)
                _card:add_to_deck()
                G.consumeables:emplace(_card) 
                return true
            end}))
        card_eval_status_text(card, 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
    end
}
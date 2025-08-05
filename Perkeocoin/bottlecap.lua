SMODS.Atlas({key = "capatlas", path = "bottlecaps.png", px = 34, py = 34, atlas_table = "ASSET_ATLAS"}):register()

SMODS.ConsumableType {
    key = "bottlecap",
    primary_colour = HEX("EEEEEE"),
    secondary_colour = HEX("E223EB"),
    collection_row = {5, 5},
    shop_rate = 0,
    default = "c_hpot_money",
}

SMODS.Consumable { --Money
    name = 'Money',
    key = 'money',
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
    display_size = { h = 34, w = 34},
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['bottlecap'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra[card.ability.extra.chosen]}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
    end
}
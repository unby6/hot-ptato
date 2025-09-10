local horsemen = {
    "ruby",
    "lily",
    "nxkoo",
    "cg",
    "pangaea",
    "baccon"
}

SMODS.Atlas{key = "hc_apocalypse", path = "Horsechicot/hc_apocalypse.png", px = 71, py = 95}

SMODS.Joker {
    key = "apocalypse",
    cost = 10,
    rarity = 3,
    config = {
        horseman = ""
    },
    atlas = "hc_apocalypse",
    pos = { x = 0, y = 0 },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    loc_vars = function(self, q, card)
        if card.ability.horseman == "" then return end
        return {
            key = "j_hpot_apocalypse_"..card.ability.horseman
        }
    end,
    calculate = function(self, card, context)

    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.first then
            randomize_horseman(card)
            card.ability.first = true
        end
    end
}

local pos_map = {
    ruby = {x = 1, y = 0},
    lily = {x = 2, y = 0},
    nxkoo = {x = 3, y = 0},
    cg = {x = 0, y = 1},
    pangaea = {x = 1, y = 1},
    baccon = {x = 2, y = 1}
}
local function randomize_horseman(card)
    card.ability.horseman = pseudorandom_element(horsemen, pseudoseed("hpot_apocalypse"))
    card.children.center:set_sprite_pos(pos_map[card.ability.horseman])
end
SMODS.Atlas({ key = "SillypostingJokers", path = "Sillyposting/Jokers.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS" }):register()

SMODS.Joker {
    key = "wizard_tower",
    blueprint_compat = false,
    rarity = 3,
    cost = 10,
    atlas = "SillypostingJokers",
    pos = { x = 0, y = 0 },
    config = { extra = { bonus_highlight = 1 } },
    loc_vars = function (self, info_queue, card)
        info_queue[#info_queue+1] = { set = "Other", key = "highlight_mod_warning" }
        return { vars = { card.ability.extra.bonus_highlight } }
    end,
    add_to_deck = function (self, card, from_debuff)
        change_max_highlight(card.ability.extra.bonus_highlight)
    end,
    remove_from_deck = function (self, card, from_debuff)
        change_max_highlight(-card.ability.extra.bonus_highlight)
    end,
    hotpot_credits = {
        art = {"Eris (TEMPORARY)"},
        code = {"Eris"},
        team = {"Sillyposting"}
    }
}
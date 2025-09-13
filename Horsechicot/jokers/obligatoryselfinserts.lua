SMODS.Atlas {
    key = "selfinserts",
    path = "Horsechicot/selfinserts.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "selfinserting",
    rarity = 3,
    cost = 7,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    atlas = "selfinserts",
    pos = { x = 0, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.obligatoryxmultbecauseholyshithowmanyselfinsertsinthismodtheressomanyselfinsertsthatitalmostbeatspwxbyitself, card.ability.extra.selfinserts * card.ability.extra.obligatoryxmultbecauseholyshithowmanyselfinsertsinthismodtheressomanyselfinsertsthatitalmostbeatspwxbyitself } }
    end,
    config = {
        extra = {
            obligatoryxmultbecauseholyshithowmanyselfinsertsinthismodtheressomanyselfinsertsthatitalmostbeatspwxbyitself = 1.5,
            selfinserts = 15
        }
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.obligatoryxmultbecauseholyshithowmanyselfinsertsinthismodtheressomanyselfinsertsthatitalmostbeatspwxbyitself, card.ability.extra.selfinserts * card.ability.extra.obligatoryxmultbecauseholyshithowmanyselfinsertsinthismodtheressomanyselfinsertsthatitalmostbeatspwxbyitself }
        end
    end,
        hotpot_credits = {
        art = {"???"},
        code = {"Nxkoo"},
        team = {"Horsechicot"}
    },
}
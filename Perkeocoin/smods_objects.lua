
-- Jokers
-- Bottlecaps
-- Bottlecap Booster

SMODS.Atlas({key = "perkycardatlas", path = "perkycardatlas.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

SMODS.Joker{ --19 plincoin fortnite card who wants it
    name = "19 Plincoin Fortnite Card Who Wants It",
    key = "fortnite",
    config = {
        extra = {
            fortnite = 19,
            bosses = 3
        }
    },
    loc_txt = {
        ['name'] = '19 Plincoin Fortnite Card Who Wants It',
        ['text'] = {
            [1] = 'you have #1# coins',
            [2] = 'i have #2# coins',
            [3] = 'lets trade!'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    cost = 6,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    loc_vars = function(self, info_queue, card)
        return {vars = {G.GAME.plincoins, card.ability.extra.fortnite}}
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if G.GAME.blind.boss then
                card.ability.extra.bosses = card.ability.extra.bosses - 1
                if card.ability.extra.bosses <= 0 then
                    G.GAME.plincoins = G.GAME.plincoins + card.ability.extra.fortnite
                    card.ability.extra.fortnite = 0
                    return {
                        message = "Fortnite",
                        colour = G.C.PURPLE
                    }
                end
            return {
                message = "Fortnite"..card.ability.extra.bosses,
                colour = G.C.PURPLE
            }
        end
    end
end
}
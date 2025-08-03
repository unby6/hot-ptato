
-- Jokers
-- Bottlecaps
-- Bottlecap Booster

SMODS.Atlas({key = "perkycardatlas", path = "perkycardatlas.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

SMODS.Gradient {
    key = 'plincoin',
    colours = {G.C.MONEY, G.C.GREEN},
    cycle = 1
}
SMODS.Gradient {
    key = 'advert',
    colours = {G.C.FILTER, G.C.RED},
    cycle = 1
}

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
            [1] = 'Earn {C:attention}#1#{} {C:hpot_plincoin}Plincoins{} after',
            [2] = '{C:attention}#2#{} bosses defeated',
            [3] = '{C:red,E:2}self destructs'
        }
    },
    pos = {
        x = 7,
        y = 0
    },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.fortnite, card.ability.extra.bosses}}
    end,

    calculate = function(self, card, context)

        if context.end_of_round and not context.blueprint and not context.repetition and not context.individual then
            if G.GAME.blind.boss then
                card.ability.extra.bosses = card.ability.extra.bosses - 1
                if card.ability.extra.bosses <= 0 then
                    ease_plincoins(card.ability.extra.fortnite)
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            play_sound('tarot1')
                            card:start_dissolve()
                            return true
                        end
                    })) 
                    return {
                        message = "Fortnite",
                        colour = G.C.GREEN
                    }
                end
            return {
                message = localize{type='variable',key='a_remaining',vars={card.ability.extra.bosses}},
                colour = G.C.GREEN
            }
        end
    end
end
}

SMODS.Joker{ --Plink
    name = "Plink",
    key = "plink",
    config = {
        extra = {
            mult = 2
        }
    },
    loc_txt = {
        ['name'] = 'Plink',
        ['text'] = {
            [1] = "{C:red}+#1#{} Mult per {C:hpot_plincoin}Plinko{}",
            [2] = "played this run",
            [3] = "{C:inactive}(Currently {C:red}+#2#{C:inactive})"
        }
    },
    pos = {
        x = 8,
        y = 0
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, G.GAME.balls_dropped}}
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers and context.joker_main then
            if G.GAME.balls_dropped > 0 then
                return{
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult * G.GAME.balls_dropped}},
                    mult_mod = card.ability.extra.mult * G.GAME.balls_dropped
                }
            end
        end
    end

}

SMODS.Joker{ --PlincoinXmult
    name = "PlincoinXmult",
    key = "plincoinxmult",
    config = {
        extra = {
            Xmult = 0.25
        }
    },
    loc_txt = {
        ['name'] = 'PlincoinXmult',
        ['text'] = {
            [1] = "{C:white,X:red}X#1#{} Mult for every",
            [2] = "{C:hpot_plincoin}Plincoin{} you have",
            [3] = "{C:inactive}(Currently {C:white,X:red}X#2#{C:inactive} Mult)"
        }
    },
    pos = {
        x = 5,
        y = 0
    },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult, 1 + (G.GAME.plincoins * card.ability.extra.Xmult)}}
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers and context.joker_main then
            if G.GAME.plincoins > 0 then
                return{
                    message = localize{type='variable',key='a_xmult',vars={1 + (G.GAME.plincoins * card.ability.extra.Xmult)}},
                    Xmult_mod = 1 + (G.GAME.plincoins * card.ability.extra.Xmult)
                }
            end
        end
    end

}

SMODS.Joker{ --Tribcoin
    name = "Tribcoin",
    key = "tribcoin",
    config = {
        extra = {
            Xmult = 3
        }
    },
    loc_txt = {
        ['name'] = 'Tribcoin',
        ['text'] = {
            [1] = '{C:white,X:red}X#1#{} Mult',
            [2] = '{C:hpot_plincoin}Plincoins{} can\'t',
            [3] = 'be gained'
        }
    },
    pos = {
        x = 6,
        y = 0
    },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.Xmult}}
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers and context.joker_main then
            return{
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.Xmult}},
                Xmult_mod = card.ability.extra.Xmult
            }
        end
    end

}

SMODS.Joker{ --Adspace
    name = "Adspace",
    key = "adspace",
    config = {
        extra = {
            chips = 30
        }
    },
    loc_txt = {
        ['name'] = 'Adspace',
        ['text'] = {
            [1] = '{C:blue}+#1#{} Chips for',
            [2] = '{C:hpot_advert}Ad{} on screen',
            [3] = '{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)'
        }
    },
    pos = {
        x = 0,
        y = 1
    },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.chips, #G.GAME.hotpot_ads * card.ability.extra.chips}}
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers and context.joker_main then
            if #G.GAME.hotpot_ads > 0 then
                return{
                    message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips * #G.GAME.hotpot_ads}},
                    chip_mod = card.ability.extra.chips * #G.GAME.hotpot_ads
                }
            end
        end
    end

}

-- SMODS.Joker{ --free plincoins  yayy for testing
--     name = "free",
--     key = "free",
--     config = {
--         extra = {
--             Xmult = 3
--         }
--     },
--     loc_txt = {
--         ['name'] = 'free',
--         ['text'] = {
--             [1] = "bluh bluh"
--         }
--     },
--     pos = {
--         x = 9,
--         y = 0
--     },
--     cost = 6,
--     rarity = 1,
--     blueprint_compat = true,
--     eternal_compat = true,
--     perishable_compat = false,
--     unlocked = true,
--     discovered = true,
--     atlas = 'perkycardatlas',

--     loc_vars = function(self, info_queue, card)
--         return {vars = {card.ability.extra.mult, G.GAME.balls_dropped}}
--     end,

--     calculate = function(self, card, context)

--         if context.cardarea == G.jokers and context.joker_main then
--             ease_plincoins(1)
--         end
--     end

-- }

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


SMODS.ConsumableType { --Czech
    key = "Czech",
    primary_colour = HEX("EEEEEE"),
    secondary_colour = HEX("D2B48C"),
    loc_txt =  	{
 		name = 'Czech', -- used on card type badges
 		collection = 'Czech Cards', -- label for the button to access the collection
 	},
    collection_row = {6, 6},
    shop_rate = 0,
    default = "c_hpot_charity",
}

SMODS.Consumable { --cash exchange
    name = 'Cash Exchange',
    key = 'cashexchange',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Cash Exchange',
        ['text'] = {
            [1] = "Lose {C:money}$#1#{},",
            [2] = "gain {C:hpot_plincoin}#2#{} Plincoins"
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            dollars = 8,
            plincoins = 2
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.plincoins}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ease_dollars(-card.ability.extra.dollars)
        ease_plincoins(card.ability.extra.plincoins)
    end
}

SMODS.Consumable { --Charity
    name = 'Charity',
    key = 'charity',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Charity',
        ['text'] = {
            [1] = "Gain {C:hpot_plincoin}#1#{} Plincoin",
            [2] = 'completely free!!!'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            plincoins = 1
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        ease_plincoins(card.ability.extra.plincoins)
    end
}

local function sac_czech()
    if #G.jokers.cards > 0 then
        local thunk = G.jokers.cards[1].config.center.rarity
        if thunk == 1 then
            return 2
        elseif thunk == 2 then
            return 3
        elseif thunk == 3 then
            return 5
        elseif thunk == 4 then
            return 10
        else
            return 5
        end
    end
    return 0
end
SMODS.Consumable { --Sacrifice
    name = 'Sacrifice',
    key = 'sacrifice',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Sacrifice',
        ['text'] = {
            [1] = "Destroy leftmost {C:attention}Joker{},",
            [2] = 'Gain {C:hpot_plincoin}Plincoins{} based on',
            [3] = 'that Joker\'s {C:attention}rarity',
            [4] = '{C:inactive}(Currently {C:hpot_plincoin}#1#{C:inactive} Plincoins)'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {sac_czech()}}
    end,

    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            if not SMODS.is_eternal(G.jokers.cards[1], card) then
                return true
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        ease_plincoins(sac_czech())
        G.jokers.cards[1].getting_sliced = true
        G.E_MANAGER:add_event(Event({func = function()
            card:juice_up(0.8, 0.8)
            G.jokers.cards[1]:start_dissolve({G.C.RED}, nil, 1.6)
        return true end }))
    end
}

SMODS.Consumable { --Wheel of Plinko
    name = 'Wheel of Plinko',
    key = 'wheelofplinko',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Wheel of Plinko',
        ['text'] = {
            [1] = 'Lose #1# Plincoins,',
            [2] = '#3# in #4# chance to',
            [3] = 'gain #2# Plincoins'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            plincoinsdown = 2,
            plincoinsup = 5,
            num = 1,
            den = 2
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'wheelofplinko')
        return {vars = {card.ability.extra.plincoinsdown, card.ability.extra.plincoinsup, new_numerator, new_denominator}}
    end,

    can_use = function(self, card)
        return G.GAME.plincoins >= card.ability.extra.plincoinsdown
    end,

    use = function(self, card, area, copier)
        ease_plincoins(-card.ability.extra.plincoinsdown)
        if SMODS.pseudorandom_probability(card, 'czechwheel', card.ability.extra.num, card.ability.extra.den, 'wheelofplinko') then
            ease_plincoins(card.ability.extra.plincoinsup)
        else
            G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.4, func = function()
            attention_text({
                text = localize('k_nope_ex'),
                scale = 1.3, 
                hold = 1.4,
                major = card,
                backdrop_colour = G.C.SECONDARY_SET.Tarot,
                align = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and 'tm' or 'cm',
                offset = {x = 0, y = (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and -0.2 or 0},
                silent = true
                })
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                card:juice_up(0.3, 0.5)
        return true end }))
        end
    end
}

SMODS.Consumable { --Collateral 
    name = 'Collateral',
    key = 'collateral',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Collateral',
        ['text'] = {
            [1] = "A random {C:attention}Joker",
            [2] = 'becomes {C:attention}Perishable{},',
            [3] = 'gain {C:hpot_plincoin}#1#{} Plincoins'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            plincoins = 4
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins}}
    end,

    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            for k, v in ipairs(G.jokers.cards) do
                if not v.ability.perishable and v.config.center.perishable_compat and not v.ability.eternal then
                    return true
                end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        local thunk = {}
        for k, v in ipairs(G.jokers.cards) do
            if not v.ability.perishable and v.config.center.perishable_compat and not v.ability.eternal then
                thunk[#thunk+1] = v
            end
        end
        local then_perish = pseudorandom_element(thunk, pseudoseed('perish'))
        then_perish:set_perishable(true)
        then_perish:juice_up(0.5,0.5)
        ease_plincoins(card.ability.extra.plincoins)
    end
}

SMODS.Consumable { --CoD Account 
    name = 'CoD Account',
    key = 'codaccount',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'CoD Account',
        ['text'] = {
            [1] = "A random {C:attention}Joker",
            [2] = 'becomes {C:attention}Eternal{},',
            [3] = 'gain {C:hpot_plincoin}#1#{} Plincoins'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            plincoins = 4
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins}}
    end,

    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            for k, v in ipairs(G.jokers.cards) do
                if not v.ability.eternal and v.config.center.eternal_compat and not v.ability.perishable then
                    return true
                end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        local thunk = {}
        for k, v in ipairs(G.jokers.cards) do
            if not v.ability.eternal and v.config.center.eternal_compat and not v.ability.perishable then
                thunk[#thunk+1] = v
            end
        end
        local deposit = pseudorandom_element(thunk, pseudoseed('deposit'))
        deposit:set_eternal(true)
        deposit:juice_up(0.5,0.5)
        ease_plincoins(card.ability.extra.plincoins)
    end
}

SMODS.Consumable { --Subscription
    name = 'Subscription',
    key = 'subscription ',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Subscription',
        ['text'] = {
            [1] = "A random {C:attention}Joker",
            [2] = 'becomes {C:attention}Rental{},',
            [3] = 'gain {C:hpot_plincoin}#1#{} Plincoins'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            plincoins = 4
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins}}
    end,

    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            for k, v in ipairs(G.jokers.cards) do
                if not v.ability.rental then
                    return true
                end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        local thunk = {}
        for k, v in ipairs(G.jokers.cards) do
            if not v.ability.rental then
                thunk[#thunk+1] = v
            end
        end
        local rent = pseudorandom_element(thunk, pseudoseed('rent'))
        rent:set_rental(true)
        rent:juice_up(0.5,0.5)
        ease_plincoins(card.ability.extra.plincoins)
    end
}

SMODS.Consumable { --Handful
    name = 'Handful',
    key = 'handful',
    set = 'Czech',
    loc_txt = {
        ['name'] = 'Handful',
        ['text'] = {
            [1] = "Gain {C:hpot_plincoin}#1#{} Plincoins,",
            [2] = '{C:red}-#2#{} hand size'
        }
    },
    atlas = 'perkycardatlas',
    pos = {
        x = 2,
        y = 1
    },
    config = {
        extra = {
            plincoins = 10,
            h_size = 1
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins, card.ability.extra.h_size}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        G.hand:change_size(-card.ability.extra.h_size)
        ease_plincoins(card.ability.extra.plincoins)
    end
}
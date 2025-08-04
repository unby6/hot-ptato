
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

SMODS.Joker{ --19 plincoin fortnite card
    name = "19 Plincoin Fortnite Card",
    key = "fortnite",
    config = {
        extra = {
            fortnite = 19,
            bosses = 3
        }
    },
    pos = {x = 7, y = 0},
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {''}, --i forgot
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

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
    pos = { x = 8, y = 0 },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {''}, --i forgot
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

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
    pos = { x = 5, y = 0 },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = false,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {''}, --i forgot
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

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
    pos = { x = 6, y = 0 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {''}, --i forgot
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

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
    pos = { x = 0, y = 1 },
    cost = 5,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {''}, --i forgot
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

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

SMODS.Joker{ -- Kitchen Gun
    key = 'kitchen_gun',
    config = { extra = { odds = 4, xmult = 1, xmult_mod = 0.1 }},
    cost = 7,
    rarity = 2,
    atlas = 'perkycardatlas', pos = {x=1,y=1},
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,

    hotpot_credits = {
        art = {'Kitty'},
        idea = {'Kitty'},
        code = {'Opal'},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        local n, d = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'hpot_kitchen_gun')
        return{vars = {n, d, card.ability.extra.xmult_mod, card.ability.extra.xmult}}
    end,
    calculate = function(self, card, context)
        if context.ending_shop and context.cardarea == G.jokers then
            local adsRemoved = 0
            for k, v in ipairs(G.GAME.hotpot_ads) do
                if SMODS.pseudorandom_probability(card, 'hpot_kg_kill_ad', 1, card.ability.extra.odds) then
                    G.E_MANAGER:add_event(Event({
                        delay = 0.3, func = function()
                            play_sound('tarot1')
                            v:juice_up(0.3,0.5)
                            remove_ad(v.config.id)
                        return true end
                    }))
                    adsRemoved = adsRemoved+1
                end
            end
            card.ability.extra.xmult = card.ability.extra.xmult + (adsRemoved*card.ability.extra.xmult_mod)
            return{
                message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                colour = G.C.RED
            }
        end
        if context.joker_main and context.cardarea == G.jokers and card.ability.extra.xmult > 1 then
            return{
                    message = localize{type='variable',key='a_xmult',vars={card.ability.extra.xmult}},
                    xmult_mod = card.ability.extra.xmult
                }
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
    collection_row = {6, 6},
    shop_rate = 0,
    default = "c_hpot_charity",
}

SMODS.Consumable { --Cash Exchange
    name = 'Cash Exchange',
    key = 'cashexchange',
    set = 'Czech',
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
    if G.jokers and G.jokers.cards and #G.jokers.cards > 0 then
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
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
    key = 'wheel_of_plinko',
    set = 'Czech',
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'wheel_of_plinko')
        return {vars = {card.ability.extra.plincoinsdown, card.ability.extra.plincoinsup, new_numerator, new_denominator}}
    end,

    can_use = function(self, card)
        return G.GAME.plincoins >= card.ability.extra.plincoinsdown
    end,

    use = function(self, card, area, copier)
        ease_plincoins(-card.ability.extra.plincoinsdown)
        if SMODS.pseudorandom_probability(card, 'czech_wheel_of_plinko', card.ability.extra.num, card.ability.extra.den, 'wheel_of_plinko') then
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
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
    key = 'cod_account',
    set = 'Czech',
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
    key = 'subscription',
    set = 'Czech',
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
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

SMODS.Consumable { --Czech Republic
    name = 'Czech Republic',
    key = 'czech_republic',
    set = 'Czech',
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
    config = { extra = { cards = 2 }},
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.cards}}
    end,

    can_use = function(self, card)
        if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
            return true
        end
        return false
    end,

    use = function(self, card, area, copier)
        for i = 1, math.min(card.ability.extra.cards, (G.consumeables.config.card_limit - #G.consumeables.cards)) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after', delay = 0.4, func = function()
                    play_sound('timpani')
                    local new_czech = create_card('Czech', G.consumeables, nil, nil, nil, nil, nil, 'czech_republic')
                    new_czech:add_to_deck()
                    G.consumeables:emplace(new_czech)
                    card:juice_up(0.3, 0.5)
                return true end}))
        end
    end
}
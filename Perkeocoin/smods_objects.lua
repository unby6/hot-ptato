
-- Jokers
-- Bottlecaps
-- Bottlecap Booster

SMODS.Atlas({key = "perkycardatlas", path = "perkycardatlas.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()
SMODS.Atlas({key = "perkeocoinjokers", path = "PerkeocoinJokers.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()
SMODS.Atlas({key = "PerkeocoinBoosters", path = "perkeocoin_boosters.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()
SMODS.Atlas({key = "chequeatlas", path = "checks.png", px = 71, py = 95, atlas_table = "ASSET_ATLAS"}):register()

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
    pos = {x = 0, y = 0},
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkeocoinjokers',

    hotpot_credits = {
        art = {'Kitty'},
        idea = {'Proto'}, --i forgot
        --dw, i rember :3c
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
    pos = { x = 3, y = 0 },
    cost = 7,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkeocoinjokers',

    hotpot_credits = {
        art = {'Omegaflowey18'}, --update
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
    atlas = 'perkeocoinjokers', pos = {x=1,y=0},
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
                            G.FUNCS.remove_ad({config = {adnum = v.config.id}})
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
                    Xmult = card.ability.extra.xmult
                }
        end
    end
}

SMODS.Joker{ --TV Dinner
    name = "TV Dinner",
    key = "tv_dinner",
    config = {
        extra = {
            mult = 20,
            mult_mod = 4
        }
    },
    pos = { x = 5, y = 0 },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = false,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkeocoinjokers',

    hotpot_credits = {
        art = {'Omegaflowey18'},
        idea = {''},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.mult, card.ability.extra.mult_mod}}
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.jokers and context.joker_main then
            if card.ability.extra.mult > 0 then
                return{
                    message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                    mult_mod = card.ability.extra.mult
                }
            end

        elseif context.close_ad and not context.blueprint then
            card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.mult_mod
            if card.ability.extra.mult <= 0 then
                G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card.T.r = -0.2
                    card:juice_up(0.3, 0.4)
                    card.states.drag.is = true
                    card.children.center.pinch.x = true
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.3, blockable = false,
                    func = function()
                        G.jokers:remove_card(self)
                        card:remove()
                        card = nil
                        return true; end})) 
                    return true
                end
                }))
                return {
                    message = localize('k_eaten_ex'),
                    colour = G.C.FILTER
                }
            end
            return {
                message = localize{type='variable',key='a_mult_minus',vars={card.ability.extra.mult_mod}},
                colour = G.C.MULT
            }
        end
    end

}

SMODS.Joker{ --Free To Use
    name = "Free To Use",
    key = "free_to_use",
    config = {
        extra = {
            reps = 1,
            num = 1,
            den = 3
        }
    },
    pos = { x = 4, y = 1 },
    cost = 6,
    rarity = 1,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {'CampfireCollective'},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        local new_numerator, new_denominator = SMODS.get_probability_vars(card, card.ability.extra.num, card.ability.extra.den, 'wheel_of_plinko')
        return {vars = {card.ability.extra.reps, new_numerator, new_denominator}}
    end,

    calculate = function(self, card, context)

        if context.cardarea == G.play and context.repetition then
            if SMODS.pseudorandom_probability(card, 'perky_free!', card.ability.extra.num, card.ability.extra.den, 'free_to_use') then
                create_ads(card.ability.extra.reps)
                return {
                    message = localize('k_again_ex'),
                    repetitions = 1,
                    card = card
                }
            end
        end
    end

}

SMODS.Joker{ --Direct Deposit
    name = "Direct Deposit",
    key = "direct_deposit",
    config = {
        extra = {
            dollars = 5,
            plincoins = 1,
            so_far = 0
        }
    },
    pos = { x = 8, y = 0 },
    cost = 7,
    rarity = 2,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {'CampfireCollective'},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars, card.ability.extra.plincoins, card.ability.extra.so_far}}
    end,

    calculate = function(self, card, context)
        if context.pk_cashout_row and not context.blueprint then
            local new_config = context.pk_cashout_row
            if new_config.name == 'bottom' and new_config.dollars > 0 then
                card.ability.extra.so_far = card.ability.extra.so_far + new_config.dollars
                new_config.dollars = 0
                if card.ability.extra.so_far >= card.ability.extra.dollars then
                    ease_plincoins(math.floor(card.ability.extra.so_far / card.ability.extra.dollars))
                    card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "Plink X"..tostring(math.floor(card.ability.extra.so_far / card.ability.extra.dollars)).."!", colour = G.C.MONEY})
                    card.ability.extra.so_far = card.ability.extra.so_far % card.ability.extra.dollars
                else
                    card_eval_status_text(card, 'jokers', nil, nil, nil, {message = tostring(card.ability.extra.so_far).."/"..tostring(card.ability.extra.dollars), colour = G.C.FILTER})
                end
            end
            return{
                new_config = new_config
            }
        end
    end

}

SMODS.Joker{ --Bank Teller
    name = "Bank Teller",
    key = "bank_teller",
    config = {
        extra = {
            compare = 5,
            cards = 1
        }
    },
    pos = { x = 1, y = 1 },
    cost = 5,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {'CampfireCollective'},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.compare-1, card.ability.extra.cards, localize('k_czech')..(card.ability.extra.cards > 1 and "s" or "")}}
    end,

    calculate = function(self, card, context)
        if context.pk_cashout_row_but_just_looking and not context.blueprint then
            if context.pk_cashout_row_but_just_looking.name == 'bottom' and context.pk_cashout_row_but_just_looking.dollars < 5 then
                if G.consumeables and #G.consumeables.cards < G.consumeables.config.card_limit then
                    local amount = math.min(card.ability.extra.cards, (G.consumeables.config.card_limit - #G.consumeables.cards))
                    for i = 1, amount do
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after', delay = 0.4, func = function()
                                play_sound('timpani')
                                local new_czech = create_card('Czech', G.consumeables, nil, nil, nil, nil, nil, 'czech_republic')
                                new_czech:add_to_deck()
                                G.consumeables:emplace(new_czech)
                                card:juice_up(0.3, 0.5)
                            return true end}))
                    end
                    card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "+"..amount.." "..localize('k_czech')..(amount > 1 and "s" or ""), colour = HEX("D2B48C")})
                end
            end
        end
    end

}

SMODS.Joker{ --Balatro **PREMIUM**
    name = "Balatro **PREMIUM**",
    key = "balatro_premium",
    config = {
        extra = {
            dollars = 5,
        }
    },
    pos = { x = 4, y = 0 },
    cost = 6,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkeocoinjokers',

    hotpot_credits = {
        art = {'Omegaflowey18'},
        idea = {''},
        code = {'CampfireCollective'},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars}}
    end,

    add_to_deck = function(self, card, from_debuff)
        for k, v in ipairs(G.GAME.hotpot_ads) do
            G.E_MANAGER:add_event(Event({
                delay = 0.3, func = function()
                    play_sound('tarot1')
                    v:juice_up(0.3,0.5)
                    G.FUNCS.remove_ad(v.config.id)
                return true end
            }))
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.blind.boss and not context.repetition and not context.individual and not context.bluleprint then
            ease_dollars(-card.ability.extra.dollars)
            return {
                message = "-$"..card.ability.extra.dollars,
                colour = G.C.MONEY
            }

        elseif context.close_ad and not context.blueprint then
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "Ad Removed!", colour = G.C.FILTER})
        end
   
    end

}

SMODS.Joker{ --Skimming
    name = "Skimming",
    key = "skimming",
    config = {
        extra = {
            dollars = 0,
            dollars_mod = 1
        }
    },
    pos = { x = 0, y = 1 },
    cost = 4,
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
        return {vars = {card.ability.extra.dollars, card.ability.extra.dollars_mod}}
    end,

    calc_dollar_bonus = function(self, card)
        local thunk = card.ability.extra.dollars
        if G.GAME.blind.boss then
            card.ability.extra.dollars = 0
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = localize('k_reset'), colour = G.C.FILTER})
        end
        if thunk > 0 then
            return thunk
        end
    end,

    calculate = function(self, card, context)
        if context.close_ad and not context.blueprint then
            card.ability.extra.dollars = card.ability.extra.dollars + card.ability.extra.dollars_mod
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "$"..card.ability.extra.dollars, colour = G.C.MONEY})
        end
    end

}

SMODS.Joker{ --Recycling
    name = "Recycling",
    key = "recycling",
    config = {
        extra = {
            dollars = 5
        }
    },
    pos = { x = 0, y = 1 },
    cost = 6,
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
        return {vars = {card.ability.extra.dollars}}
    end,

    calculate = function(self, card, context)
        if context.using_consumeable then
            if context.consumeable.ability.set == 'bottlecap' then
                ease_dollars(card.ability.extra.dollars)
                card:juice_up(0.5,0.5)
            end
        end
    end

}

SMODS.Joker{ --Don't Touch That Dial!
    name = "Don\'t Touch That Dial!",
    key = "dont_touch_that_dial",
    config = {
        extra = {
            dial = 1
        }
    },
    pos = { x = 0, y = 1 },
    cost = 6,
    rarity = 3,
    blueprint_compat = false,
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
        return {vars = {card.ability.extra.dial}}
    end,

    calculate = function(self, card, context)
        if context.end_of_round and G.GAME.current_round.discards_left > 0 and not (context.blueprint or context.individual or context.repetition) then
            ease_plincoins(G.GAME.current_round.discards_left)
            create_ads(G.GAME.current_round.discards_left)
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "Stay Tuned!", colour = G.C.MONEY})
        end
    end

}

SMODS.Joker{ --Tipping Point
    name = "Tipping Point",
    key = "tipping_point",
    config = {
        extra = {
        }
    },
    pos = { x = 0, y = 1 },
    cost = 4,
    rarity = 1,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'perkycardatlas',

    hotpot_credits = {
        art = {''}, --update
        idea = {''}, --i forgot
        code = {''},
        team = {'Perkeocoin'}
    },

    loc_vars = function(self, info_queue, card)
        return {vars = {}}
    end,

    calculate = function(self, card, context)
    end

}

local function calculate_tipping_point()
    if next(find_joker('Tipping Point')) then
        G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Rare + 1
        G.GAME.plinko_rewards.Common = PlinkoLogic.rewards.per_rarity.Common - 1
        PlinkoGame.f.toggle_moving_pegs(true)
    else
        G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Rare
        G.GAME.plinko_rewards.Common = PlinkoLogic.rewards.per_rarity.Common
        PlinkoGame.f.toggle_moving_pegs(false)
    end
end


local game_update = Game.update
function Game:update(dt)
    game_update(self, dt)

    if not G.jokers then
        return
    end
    calculate_tipping_point()
end


-- Czechs

SMODS.ConsumableType { --Czech
    key = "Czech",
    primary_colour = HEX("EEEEEE"),
    secondary_colour = HEX("D2B48C"),
    collection_row = {6, 6},
    shop_rate = 1,
    default = "c_hpot_charity",
}

SMODS.Consumable { --Cash Exchange
    name = 'Cash Exchange',
    key = 'cashexchange',
    set = 'Czech',
    atlas = 'chequeatlas',
    pos = { x = 0, y = 0 },
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
    atlas = 'chequeatlas',
    pos = { x = 1, y = 0 },
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

SMODS.Consumable { --Charity
    name = 'Charity',
    key = 'charity',
    set = 'Czech',
    atlas = 'chequeatlas',
    pos = { x = 3, y = 0 },
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

SMODS.Consumable { --Collateral 
    name = 'Collateral',
    key = 'collateral',
    set = 'Czech',
    atlas = 'chequeatlas',
    pos = { x = 0, y = 1 },
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
    atlas = 'chequeatlas',
    pos = { x = 1, y = 1 },
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
    atlas = 'chequeatlas',
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
    atlas = 'chequeatlas',
    pos = { x = 0, y = 2 },
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

local function mostplayedhand()
    local _handname, _played, _order = 'High Card', -1, 1000
    for k, v in pairs(G.GAME.hands) do
        if v.visible and ((v.played > _played) or ((v.played == _played) and (v.order < _order))) then
            _played = v.played
            _order = v.order
            _handname = k
        end
    end
    return _handname
end
SMODS.Consumable { --Meteor
    name = 'Meteor',
    key = 'meteor',
    set = 'Czech',
    atlas = 'chequeatlas',
    pos = { x = 1, y = 2 },
    config = {
        extra = {
            plincoins = 3,
            levels = 1
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins, card.ability.extra.levels, mostplayedhand()}}
    end,

    can_use = function(self, card)
        local thunk = mostplayedhand()
        return G.GAME.hands[thunk].level > 0
    end,

    use = function(self, card, area, copier)
        local thunk = mostplayedhand()
        update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(thunk, 'poker_hands'),chips = G.GAME.hands[thunk].chips, mult = G.GAME.hands[thunk].mult, level=G.GAME.hands[thunk].level})
        level_up_hand(card, thunk, nil, -card.ability.extra.levels)
        update_hand_text({sound = 'button', volume = 0.7, pitch = 1.1, delay = 0}, {mult = 0, chips = 0, handname = '', level = ''})
        ease_plincoins(card.ability.extra.plincoins)
    end
}

SMODS.Consumable { --Yard Sale
    name = 'Yard Sale',
    key = 'yard_sale',
    set = 'Czech',
    atlas = 'perkycardatlas',
    pos = { x = 2, y = 1 },
    config = {
        extra = {
            plincoins = 3,
            cards = 4
        }
    },
    unlocked = true,
    discovered = true,
    cost = 3,
    pools = {
        ['Czech'] = true
    },
    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.plincoins, card.ability.extra.cards}}
    end,

    can_use = function(self, card)
        return true
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function() 
                    local cards = {}
                    for i=1, card.ability.extra.cards do
                        cards[i] = true
                        local _suit, _rank = nil, nil
                            _rank = pseudorandom_element(SMODS.Ranks, pseudoseed('yardsale'))
                            _suit = pseudorandom_element(SMODS.Suits, pseudoseed('yardsale'))
                        _suit = _suit or 'S'; _rank = _rank or 'A'
                        
                        create_playing_card({front = G.P_CARDS[_suit.card_key..'_'.._rank.card_key], center = G.P_CENTERS.c_base}, G.deck, nil, i ~= 1, {HEX("D2B48C")})
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                    end
                    playing_card_joker_effects(cards)
                    return true end }))
        ease_plincoins(card.ability.extra.plincoins)
    end
}

SMODS.Consumable { --Mystery Box
    name = 'Mystery Box',
    key = 'mystery_box',
    set = 'Czech',
    atlas = 'chequeatlas',
    pos = { x = 3, y = 2 },
    config = {
        extra = {
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
        return {vars = {card.ability.extra.plincoins}}
    end,

    can_use = function(self, card)
        if #G.jokers.cards > 0 then
            for k, v in ipairs(G.jokers.cards) do
                if v.facing == 'front' then
                    return true
                end
            end
        end
        return false
    end,

    use = function(self, card, area, copier)
        local flippers = {}
        for k, v in ipairs(G.jokers.cards) do
            if v.facing == 'front' then
                flippers[#flippers+1] = v
            end
        end
        local flipped = pseudorandom_element(flippers, pseudoseed('yardsale'))
        flipped:flip()
        flipped.forever_flipped = true
        ease_plincoins(card.ability.extra.plincoins)
    end
}


G.STATES.CZECH_PACK = 5734985

-- Czech Boosters
SMODS.Booster {
    name = 'Czech Pack',
    key = 'czech_normal',
    atlas = 'PerkeocoinBoosters', pos = {x=0,y=0},
    config = { choose = 1, extra = 3 },
    discovered = true,
    cost = 4,
    weight = 0.1,
    kind = 'hpot_czech',
    group_key = 'k_hpot_czech_pack',

    loc_vars = function(self, info_queue, card)
        return{vars={card.ability.choose, card.ability.extra}}
    end,
    create_card = function(self, card, i)
        local newCard = create_card('Czech', G.pack_cards, nil, nil, true, true, nil, 'czech_pack')
        return newCard
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.CZECH_PACK)
    end,
}

SMODS.Booster {
    name = 'Jumbo Czech Pack',
    key = 'czech_jumbo',
    atlas = 'PerkeocoinBoosters', pos = {x=0,y=0},
    config = { choose = 1, extra = 5 },
    discovered = true,
    cost = 5,
    weight = 0.1,
    kind = 'hpot_czech',
    group_key = 'k_hpot_czech_pack',

    loc_vars = function(self, info_queue, card)
        return{vars={card.ability.choose, card.ability.extra}}
    end,
    create_card = function(self, card, i)
        local newCard = create_card('Czech', G.pack_cards, nil, nil, true, true, nil, 'czech_pack')
        return newCard
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.CZECH_PACK)
    end,
}

SMODS.Booster {
    name = 'Mega Czech Pack',
    key = 'czech_mega',
    atlas = 'PerkeocoinBoosters', pos = {x=0,y=0},
    config = { choose = 2, extra = 5 },
    discovered = true,
    cost = 7,
    weight = 0.03,
    kind = 'hpot_czech',
    group_key = 'k_hpot_czech_pack',

    loc_vars = function(self, info_queue, card)
        return{vars={card.ability.choose, card.ability.extra}}
    end,
    create_card = function(self, card, i)
        local newCard = create_card('Czech', G.pack_cards, nil, nil, true, true, nil, 'czech_pack')
        return newCard
    end,
    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.CZECH_PACK)
    end,
}
SMODS.Joker {
    key = 'minimum_prize_guarantee',
    rarity = 1,
    cost = 5,
    atlas = "pdr_joker",
    pos = { x = 5, y = 1 },
    hotpot_credits = {
        idea = { 'SDM_0' },
        art = { 'Tacashumi' },
        code = { 'SDM_0' },
        team = { 'Pissdrawer' }
    },
    calculate = function(self, card, context)
        if context.using_consumeable and context.area == G.plinko_rewards and context.consumeable.edition and context.consumeable.edition.negative then
            if G.GAME.current_round and G.GAME.current_round.plinko_preroll_cost and G.GAME.current_round.plinko_preroll_cost ~= 0 then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = (function()
                            SMODS.add_card {
                                set = 'Czech',
                                key_append = 'j_hpot_minimum_prize_guarantee'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end)
                    }))
                    return {
                        message = localize('k_plus_czech'),
                        colour = G.C.SECONDARY_SET.Czech,
                    }
                end
            end
        end
        return nil, true
    end,
}

SMODS.Joker {
    key = 'pwiz',
    loc_txt = { name = 'Piss Wizard', text = { '{C:money}Piss{} escaped the drawer :/' } },
    rarity = 1,
    cost = 5,
    atlas = "pdr_joker",
    pos = { x = 0, y = 0 },
    hotpot_credits = {
        idea = { 'fey <3' },
        art = { 'SDM_0' },
        code = { 'fey <3' },
        team = { 'Pissdrawer' }
    },
    add_to_deck = function(self, card)
        for i, v in pairs(G.C) do
            if (type(G.C[i][1]) == 'number') or SMODS.Gradient[i] then G.C[i] = HEX('DCBA1E') end
        end
    end,
    no_collection = true,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker {
    key = 'kindergarten',
    rarity = 3,
    cost = 7,
    atlas = "pdr_joker",
    pos = { x = 0, y = 1 },
    config = { extra = { xmult = 1.75 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    hotpot_credits = {
        idea = { 'SDM_0' },
        art = { 'deadbeet' },
        code = { 'SDM_0' },
        team = { 'Pissdrawer' }
    },
    calculate = function(self, card, context)
        if context.other_joker and context.other_joker.ability.is_nursery_smalled then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    in_pool = function()
        if G.jokers and G.jokers.cards then
            for _, v in ipairs(G.jokers.cards) do
                if v.ability.is_nursery_smalled then
                    return true
                end
            end
        end
        return false
    end
}

--#region BULLSHIT FOR SOCIAL CREDIT
HotPotato.allcalcs = HotPotato.allcalcs or {
    "main_eval",
    "beat_boss",
    "hook",
    "before",
    "after",
    "main_scoring",
    "individual",
    "repetition",
    "edition",
    "pre_joker",
    "post_joker",
    "joker_main",
    "final_scoring_step",
    "remove_playing_cards",
    "debuffed_hand",
    "end_of_round",
    "pre_discard",
    "discard",
    "open_booster",
    "skipping_booster",
    "buying_card",
    "selling_card",
    "reroll_shop",
    "ending_shop",
    "first_hand_drawn",
    "hand_drawn",
    "using_consumeable",
    "skip_blind",
    "playing_card_added",
    "card_added",
    "check_enhancement",
    "post_trigger",
    "modify_scoring_hand",
    "ending_booster",
    "starting_shop",
    "blind_disabled",
    "blind_defeated",
    "press_play",
    "ignore_debuff",
    "debuff_hand",
    "check",
    "stay_flipped",
    "modify_hand",
    "drawing_cards",
    "pseudorandom_result",
    "result",
    "initial_scoring_step",
    "joker_type_destroyed",
    "check_eternal",
    "trigger",
    "change_rank",
    "change_suit",
    "rank_increase",
    "round_eval",
    "money_altered",
}
local maozedong = win_game
function win_game()
    local ret = maozedong()
    if SMODS.find_card('j_hpot_social_credit') then
        HPTN.set_credits(0)
    end
    return ret
end

SMODS.Sound {
    key = 'gong',
    path = 'sfx_asiangong.ogg'
}

--#endregion

SMODS.Joker {
    key = 'social_credit',
    atlas = "pdr_joker",
    pos = {
        x = 2,
        y = 0
    },
    config = {
        china = 'piss',
        trig = false,
        extra = {
            credit_gain = 0.1,
            social_credit = 0,
            social_credit_max = 1,
        }
    },
    hotpot_credits = {
        idea = { 'deadbeet' },
        art = { 'deadbeet' },
        code = { 'deadbeet' },
        team = { 'Pissdrawer' }
    },
    unlocked = true,
    discovered = false,
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = true,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.credit_gain,
                card.ability.extra.social_credit,
                card.ability.extra.social_credit_max
            }
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.china = (HotPotato and HotPotato.allcalcs[math.floor(pseudorandom('china', 1, #HotPotato.allcalcs))]) or
            'piss'
        card:add_sticker('perishable', true)
    end,
    calculate = function(self, card, context)
        local hpt = card.ability.extra
        if context[card.ability.china] and card.ability.trig == false and not context.blueprint then
            card.ability.trig = true
            card.ability.china = (HotPotato and HotPotato.allcalcs[math.floor(pseudorandom('china', 1, #HotPotato.allcalcs))])
            hpt.social_credit_max = pseudorandom('social_credit', -1000000, 1000000)
            hpt.social_credit = hpt.social_credit + hpt.social_credit_max
            if hpt.social_credit < 0 then
                return {
                    message = localize("k_hotpot_badsocial"),
                    colour = G.C.RED,
                    sound = 'hpot_gong'
                }
            else
                return {
                    message = localize("k_hotpot_goodsocial"),
                    sound = 'hpot_gong'
                }
            end
        end
        if context.end_of_round then
            HPTN.ease_credits(hpt.credit_gain * math.floor(hpt.social_credit / 100))
        end
        if context.selling_self and not context.blueprint then
            return {
                message = 'bad puppy...',
                HPTN.set_credits(0)
            }
        end
        if context.post_trigger and context.other_card == card and card.ability.trig == true then
            if hpt.social_credit < 0 then
                card.children.center:set_sprite_pos({ x = 3, y = 0 })
            else
                card.children.center:set_sprite_pos({ x = 2, y = 0 })
            end
            card.ability.trig = false
        end
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

SMODS.Joker {
    key = 'togore',
    loc_txt = { name = 'Togore', text = {
        'When hand is {C:attention}played{},',
        '{C:attention}non-played{} cards held in',
        'hand gain {C:attention}+#1#{} permanent {C:chips}Chips'
    } },
    hotpot_credits = {
        idea = { 'Tacashumi' },
        art = { 'Tacashumi' },
        code = { 'fey <3' },
        team = { 'Pissdrawer' }
    },
    config = { extra = { chips = 10 } },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.chips
            }
        }
    end,
    rarity = 1, cost = 3,
    atlas = 'pdr_joker',
    pos = { x = 5, y = 0 },
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand then
            context.other_card.ability.perma_bonus = context.other_card.ability.perma_bonus + card.ability.extra.chips
            return {
                message = '+' .. card.ability.extra.chips .. ' Chips', colour = G.C.CHIPS
            }
        end
    end
}

SMODS.Joker {
    key = 'goblin_tinkerer',
    rarity = 2,
    cost = 6,
    atlas = "pdr_joker",
    pos = { x = 4, y = 0 },
    config = { extra = 2 },
    loc_vars = function(self, info_queue, card)
        return { vars = { math.floor(100 / card.ability.extra) } }
    end,
    hotpot_credits = {
        idea = { 'SDM_0' },
        art = { 'SDM_0' },
        code = { 'SDM_0' },
        team = { 'Pissdrawer' }
    },
    add_to_deck = function(self, card, from_debuff)
        G.GAME.goblin_acquired = true
    end,
    remove_from_deck = function(self, card, from_debuff)
        G.GAME.goblin_acquired = nil
    end,
    calculate = function(self, card, context)
        if context.reforging and not context.free then
            if context.currency == "DOLLAR" then
                ease_dollars(math.floor((G.GAME.cost_dollars - context.card.ability.reforge_dollars) / card.ability
                    .extra))
            elseif context.currency == "CREDIT" then
                HPTN.ease_credits(math.floor((G.GAME.cost_credits - context.card.ability.reforge_credits) /
                    card.ability.extra))
            elseif context.currency == "SPARKLE" then
                ease_spark_points(math.floor((G.GAME.cost_sparks - context.card.ability.reforge_sparks) /
                    card.ability.extra))
            elseif context.currency == "PLINCOIN" then
                ease_plincoins(math.floor((G.GAME.cost_plincoins - context.card.ability.reforge_plincoins) /
                    card.ability.extra))
            elseif context.currency == "CRYPTOCURRENCY" then
                ease_cryptocurrency(math.floor((G.GAME.cost_cryptocurrency - context.card.ability.reforge_cryptocurrency) /
                    card.ability.extra))
            end
            card:juice_up()
        end
    end,
}

SMODS.Joker {
    key = "birthdayboy",
    loc_txt = {
        name = "Birthday Boy",
        text = { { "Happy Birthday, N'!" }, { 'Where would Jujutsu', 'Jokers be without you...' } }
    },
    hotpot_credits = {
        idea = { "deadbeet" },
        art = { "deadbeet" },
        code = { "deadbeet" },
        team = { "Pissdrawer" }
    },
    atlas = "pdr_joker",
    pos = { x = 6, y = 0 },
    soul_pos = { x = 7, y = 0 },
    unlocked = true,
    discovered = true,
    rarity = 4,
    no_collection = true,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Rarity {
    key = "child",
    loc_txt = { name = "Child" },
    badge_colour = G.C.HPOT_PINK,
}

SMODS.Joker {
    key = 'child',
    rarity = 'hpot_child',
    hotpot_credits = {
        idea = { "fey <3" },
        code = { "fey <3" },
        team = { "Pissdrawer" }
    },
    loc_txt = { name = '#1#', text = { '{s:0.000001} ' } },
    no_collection = true,
    loc_vars = function(self, info_queue, card)
        local main_end = {}
        if card.ability.quantum[1] and card.ability.quantum[2] then
            main_end = {
                {
                    n = G.UIT.R,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = G.C.GREEN, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = localize{type = 'name', set = 'Joker', key = card.ability.quantum[1].config.center.key, vars = {}}[1].nodes[1].nodes[1].config.object.config.string[1],
                                colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                },
                {
                    n = G.UIT.R,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = card, align = "m", colour = G.C.GREEN, r = 0.05, padding = 0.06 },
                            nodes = {
                                { n = G.UIT.T, config = { text = card.ability.quantum[2].ability.name, colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
        return {
            vars = { card.ability.name or 'Baby Alex' },
            main_end = main_end
        }
    end,
    calculate = function(self, card, context)
        if card.ability.quantum[1] and card.ability.quantum[2] then
            --local ret, trig = card.ability.quantum[1]:calculate_joker(context)
            local ret, trig = card.calculate_joker(card.ability.quantum[1], context)
            --local ret2, trig2 = card.ability.quantum[2]:calculate_joker(context)
            local ret2, trig2 = card.calculate_joker(card.ability.quantum[2], context)
            if ret and ret2 then
                for i, v in pairs(ret) do
                    if ret2[i] and type(v) == 'number' then ret[i] = v + ret2[i] end
                end
            end
            if ret then ret.card = card end
            if ret2 then ret2.card = card end
            return ret or ret2, trig or trig2
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.quantum[1] or card.ability.quantum[2] then
            local ret1 = card.calculate_dollar_bonus(card.ability.quantum[1])
            local ret2 = card.calculate_dollar_bonus(card.ability.quantum[2])
            if ret1 and ret2 and type(ret1) == 'number' and type(ret2) == 'number' then
                ret1 = ret1 + ret2
            end
            return ret1 or ret2
        end
    end,
    add_to_deck = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if card.ability.quantum and card.ability.quantum[1] and card.ability.quantum[2] then
                    card.add_to_deck(card.ability.quantum[1])
                    card.add_to_deck(card.ability.quantum[2])
                    return true
                end
            end
        }))
    end,
    remove_from_deck = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if card.ability.quantum and card.ability.quantum[1] and card.ability.quantum[2] then
                    card.remove_from_deck(card.ability.quantum[1])
                    card.remove_from_deck(card.ability.quantum[2])
                    return true
                end
            end
        }))
    end,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker {
    key = "vremade_joker",
    hotpot_credits = {
        idea = { "N'" },
        art = { "LocalThunk" },
        code = { "N'" },
        team = { "Pissdrawer" }
    },
    rarity = 1,
    blueprint_compat = true,
    cost = 2,
    config = { extra = { mult = 4 }, },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult
            }
        end
    end
}

SMODS.Joker {
    key = "smods",
    hotpot_credits = {
        idea = { "Eremel" },
        art = { "SDM_0" },
        code = { "SDM_0" },
        team = { "Pissdrawer" }
    },
    config = { extra = { queue_rounds = 0, order_quips = { 1, 2, 3, 4, 5, 6 } } },
    atlas = "pdr_joker",
    pos = { x = 1, y = 1 },
    soul_pos = { x = 2, y = 1 },
    rarity = 4,
    cost = 0,
    in_pool = function(self, args)
        return false
    end
}

SMODS.Joker {
    key = "red_deck_joker",
    hotpot_credits = {
        idea = { "Tacashumi" },
        art = { "SDM_0" },
        code = { "SDM_0" },
        team = { "Pissdrawer" }
    },
    config = { extra = { discards = 1, cards_req = 20 } },
    loc_vars = function(self, info_queue, card)
        local discards = card.ability.extra.discards *
            (math.floor((G.playing_cards and #G.playing_cards or 1) / card.ability.extra.cards_req))
        return { vars = { card.ability.extra.discards, card.ability.extra.cards_req, discards } }
    end,
    atlas = "pdr_joker",
    pos = { x = 4, y = 1 },
    rarity = 2,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local discards = card.ability.extra.discards *
                        (math.floor(#G.playing_cards / card.ability.extra.cards_req))
                    if discards > 0 then
                        ease_discard(discards, nil, true)
                    end
                    return true
                end
            }))
            return nil, true
        end
    end
}

SMODS.Joker {
    key = "blue_deck_joker",
    hotpot_credits = {
        idea = { "Tacashumi" },
        art = { "SDM_0" },
        code = { "SDM_0" },
        team = { "Pissdrawer" }
    },
    config = { extra = { hands = 1, cards_req = 20 } },
    loc_vars = function(self, info_queue, card)
        local hands = card.ability.extra.hands *
            (math.floor((G.playing_cards and #G.playing_cards or 1) / card.ability.extra.cards_req))
        return { vars = { card.ability.extra.hands, card.ability.extra.cards_req, hands } }
    end,
    atlas = "pdr_joker",
    pos = { x = 6, y = 1 },
    rarity = 2,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local hands = card.ability.extra.hands *
                        (math.floor(#G.playing_cards / card.ability.extra.cards_req))
                    if hands > 0 then
                        ease_hands_played(hands)
                    end
                    return true
                end
            }))
            return nil, true
        end
    end
}

SMODS.Joker {
    key = "yellow_deck_joker",
    hotpot_credits = {
        idea = { "Tacashumi" },
        art = { "SDM_0" },
        code = { "SDM_0" },
        team = { "Pissdrawer" }
    },
    config = { extra = { dollars = 3, cards_req = 20 } },
    loc_vars = function(self, info_queue, card)
        local dollars = card.ability.extra.dollars *
            (math.floor((G.playing_cards and #G.playing_cards or 1) / card.ability.extra.cards_req))
        return { vars = { card.ability.extra.dollars, card.ability.extra.cards_req, dollars } }
    end,
    atlas = "pdr_joker",
    pos = { x = 7, y = 1 },
    rarity = 2,
    calculate = function(self, card, context)
        if context.setting_blind then
            G.E_MANAGER:add_event(Event({
                func = function()
                    local dollars = card.ability.extra.dollars *
                        (math.floor(#G.playing_cards / card.ability.extra.cards_req))
                    if dollars > 0 then
                        ease_dollars(dollars)
                    end
                    return true
                end
            }))
            return nil, true
        end
    end
}

SMODS.Joker {
    key = "polymorph",
    loc_txt = {
        name = "Polymorphine",
        text = {
            "On {C:attention}selecting a blind{}, all",
            'Jokers to the {C:attention}left{} of this',
            'card become the {C:attention}next',
            'Joker relative to the',
            '{C:attention}collection order'
        }
    },
    hotpot_credits = {
        idea = { "Tacashumi" },
        art = { "Tacashumi" },
        code = { "fey <3" },
        team = { "Pissdrawer" }
    },
    atlas = "pdr_polymorphine",
    rarity = 3,
    cost = 8,
    calculate = function(self, card, context)
        if context.setting_blind then
            local pos = 1
            for i, v in ipairs(card.area.cards) do
                if v == card then
                    pos = i
                end
            end
            if pos ~= 1 then
                for i = 1, pos - 1 do
                    local order = card.area.cards[i].config.center.order
                    if order > #G.P_CENTER_POOLS.Joker then order = 1 end
                    if card.area.cards[i].config.center.set == 'Joker' then card.area.cards[i]:set_ability(G.P_CENTER_POOLS.Joker[order + 1]) end
                end
            end
        end
    end
}

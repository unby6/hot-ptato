SMODS.Joker {
    key = 'minimum_prize_guarantee',
    rarity = 1,
    cost = 5,
    atlas = "pdr_joker",
    pos = { x = 0, y = 0 },
    hotpot_credits = {
        art = { 'SDM_0' },
        code = { 'SDM_0' },
        idea = { 'SDM_0' },
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
        art = { 'SDM_0' },
        code = { 'fey <3' },
        idea = { 'fey <3' },
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
    pos = { x = 0, y = 0 },
    config = { extra = { xmult = 1.75 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult } }
    end,
    hotpot_credits = {
        art = { 'SDM_0' },
        code = { 'SDM_0' },
        idea = { 'SDM_0' },
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
    "setting_blind",
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
    "from_roll",
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

--#endregion

SMODS.Joker {
    key = 'social_credit',
    atlas = "pdr_joker",
    pos = { x = 0, y = 0 },
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
        art = { 'deadbeet' },
        code = { 'deadbeet' },
        idea = { 'deadbeet' },
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
                    message = 'oh my god bruh',
                    colour = G.C.RED
                }
            else
                return {
                    message = 'yo phone linging'
                }
            end

            card.ability.trig = false
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
    end,
    in_pool = function(self, args)
        return true, { allow_duplicates = true }
    end
}

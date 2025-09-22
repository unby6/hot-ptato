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
    key = 'social_credit',
    atlas = "pdr_joker",
    pos = { x = 0, y = 0 },
    config = {
        extra = {
            credit_gain = 0.1,
            social_credit = 0,
            social_credit_max = 1,

        }
    },
    unlocked = true,
    discovered = false,
    rarity = 1,
    cost = 5,
    blueprint_compat = false,
    eternal_compat = false,
    perishable_compat = false,
    hotpot_credits = {
        art = { 'deadbeet' },
        code = { 'deadbeet' },
        idea = { 'deadbeet' },
        team = { 'Pissdrawer' }
    },
    calculate = function(self, card, context)
        local hpt = card.ability.extra
        if context.end_of_round then
            HTPN.ease_credits(hpt.credits * math.floor(hpt.social_credit / 100))
        end
    end,
    loc_vars = function(self, info_queue, card)
        local hpt = card.ability.extra
        return {
            hpt.credit_gain,
            hpt.social_credit,
            hpt.social_credit_max
        }
    end,
    add_to_deck = function(self, card, from_debuff)
        card.ability.china = (Pissdrawer and Pissdrawer.allcalcs[
            math.floor(pseudorandom('china', 1, #Pissdrawer.allcalcs))]) or
            ':3'
    end
}

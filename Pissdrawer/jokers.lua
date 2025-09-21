SMODS.Joker {
    key = 'hardcore_mode',
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
        if context.using_consumeable and context.area == G.plinko_rewards and not (context.consumeable.edition and context.consumeable.edition.negative) then
            if G.GAME.current_round and G.GAME.current_round.plinko_preroll_cost and G.GAME.current_round.plinko_preroll_cost ~= 0 then
                ease_plincoins(G.GAME.current_round.plinko_preroll_cost)
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
    key = 'rivals',
    rarity = 3,
    cost = 8,
    loc_txt = { name = 'Marvel Rivals', text = {
        { '{s:0.00001,C:white}lmao' }, { '{C:attention}Cycle{} through {C:attention}random{}', ' effects on selecting', 'a blind' }
    } },
    config = { extra = {
        rivals = {
            'lunasnow',
            'mantis',
            'loki',
            'rigby',
            'cnd',
            'ultron',
            'jeff',
            'invis'
        },
        char = 'cnd'
    } },
    loc_vars = function(self, info_queue, card)
        local main_end = {}

        if card.ability.extra.char == 'cnd' then
            main_end = {
                {
                    n = G.UIT.C,
                    config = { padding = 0.03 },
                    nodes = {
                        {
                            n = G.UIT.R,
                            config = { align = 'cm' },
                            nodes = {
                                { n = G.UIT.T, config = { text = "It's co-op time!", scale = 0.28, colour = G.C.PURPLE } } }
                        },
                        {
                            n = G.UIT.R,
                            config = { align = 'cm', padding = 0.03 },
                            nodes = {
                                { n = G.UIT.T, config = { text = 'Create ', scale = 0.32, colour = G.C.UI.TEXT_DARK } },
                                { n = G.UIT.T, config = { text = '1 Consumeable', scale = 0.32, colour = G.C.FILTER } }
                            }
                        },
                        {
                            n = G.UIT.R,
                            config = { align = 'cm' },
                            nodes = {
                                { n = G.UIT.T, config = { text = 'on playing a hand', scale = 0.32, colour = G.C.UI.TEXT_DARK } },
                            }
                        },
                    }
                }
            }
        end

        return { main_end = main_end }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint then
            card.ability.extra.char = pseudorandom_element(card.ability.extra.rivals, pseudoseed('rivals'))
        end
        if context.joker_main then
            if card.ability.extra.char == 'cnd' then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        SMODS.add_card{consumable = true}
                        return true
                    end
                }))
            end
        end
    end
}

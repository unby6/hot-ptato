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
    loc_txt = {name = 'Piss Wizard', text = {'{C:money}Piss{} escaped the drawer :/'}},
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
    add_to_deck = function(self,card)
        for i,v in pairs(G.C) do
            if (type(G.C[i][1]) == 'number') or SMODS.Gradient[i] then G.C[i] = HEX('DCBA1E') end
        end
    end,
    no_collection = true,
    in_pool = function(self, args)
        return false
    end
}

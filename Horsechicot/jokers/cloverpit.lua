SMODS.Joker{
    key = "cloverpit",
    atlas = "hc_jokers",
    pos = { x = 5, y = 4 },
    rarity = 2,
    cost = 10,
    config = {
        extra = {
            odds = 6
        }
    },
    calculate = function(self, card, context)
        if context.after then
            if SMODS.pseudorandom_probability(card, 'hpot_cloverpit', 1, card.ability.extra.odds) then
                if G.GAME.dollars_ante and G.GAME.dollars_ante > 0 then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            ease_dollars(-(G.GAME.dollars_ante or 0))
                            G.GAME.dollars_ante = 0
                            return true
                        end
                    })
                end
            else
                if G.GAME.hands[context.scoring_name].mult > 0 then
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            ease_dollars(G.GAME.hands[context.scoring_name].mult)
                            return true
                        end
                    })
                end
            end
        end
    end,
    loc_vars = function (self, info_queue, card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "hpot_cloverpit")
        return { vars = { numerator, denominator } }
    end,
    hotpot_credits = {
        art = {"pangaea47"},
        code = {"lord.ruby"},
        idea = {"pangaea47"},
        team = {"Horsechicot"}
    }
}

local ease_ref = ease_dollars
function ease_dollars(mod, ...)
    ease_ref(mod, ...)
    if mod > 0 then
        G.GAME.dollars_ante = (G.GAME.dollars_ante or 0) + mod
    end
end
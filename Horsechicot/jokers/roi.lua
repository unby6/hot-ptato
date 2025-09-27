local old = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e)
    local card = e.config.ref_table
    local event
    local ret = old(e)
    if ret and Object.is(card, Card) then
        if card.area == G.market_jokers and not G.GAME.bm_bought_this_round then
            for i, v in pairs(SMODS.find_card("j_hpot_roi")) do
                G.GAME.bm_bought_this_round = true
                event = Event {
                    func = function()
                        ease_cryptocurrency(card.market_cost); return true
                    end
                }
            end
        end
    end
    if event then
        G.E_MANAGER:add_event(event)
    end
    return ret
end

SMODS.Joker {
    key = "roi",
    atlas = "hc_jokers",
    pos = { x = 3, y = 1 },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    hotpot_credits = Horsechicot.credit("cg223", "Pangaea", "lord.ruby"),
}
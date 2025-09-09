---@diagnostic disable: undefined-field
SMODS.Joker {
    hotpot_credits = {
        art = {},
        idea = { 'lord.ruby' },
        code = { 'cg223' },
        team = { 'Horsechicot' }
    },
    key = "brainfuck",
    rarity = 3,
    atlas = "hc_jokers",
    pos = { x = 4, y = 1 },
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local cards = context.scoring_hand
            local last = -math.huge
            local should_trigger = true
            ---@diagnostic disable-next-line: param-type-mismatch
            for _, card in ipairs(cards) do
                local id = card:get_id() --
                if id < last then
                    should_trigger = false
                    break
                else
                    last = id
                end
            end
            if should_trigger then
                return {
                    message = "Added!",
                    func = function()
                        G.E_MANAGER:add_event(Event {
                            func = function()
                                SMODS.add_card { key = "j_luchador" }
                                return true
                            end
                        })
                        delay(0.3)
                    end
                }
            end
        end
    end
}



SMODS.Atlas{key = "hcbananaad", path = "Ads/BananaAd.png", px=169, py=55}

function Horsechicot.num_jokers()
    if Horsechicot.joker_count_cache then
        return Horsechicot.joker_count_cache
    end
    Horsechicot.joker_count_cache = 0
    for i, v in pairs(G.P_CENTERS) do
        if string.sub(i, 1, 2) == "j_" and not v.no_collection then
            Horsechicot.joker_count_cache = Horsechicot.joker_count_cache + 1
        end
    end
    return Horsechicot.joker_count_cache
end

SMODS.Atlas {
    key = "cg223",
    path = "Horsechicot/cg223.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = "cg223",
    rarity = 4,
    atlas = "cg223",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        card.ability.extra.chips = card.ability.extra.extra * Horsechicot.num_jokers()
        return { vars = { card.ability.extra.extra, card.ability.extra.chips } }
    end,
    config = {
        extra = {
            chips = 0,
            extra = 1,
        }
    },
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            card.ability.extra.chips = card.ability.extra.extra * Horsechicot.num_jokers()
            return { chips = card.ability.extra.chips }
        end
    end,
    hotpot_credits = Horsechicot.credit("cg223", "my shitass ex")
}


local old = G.FUNCS.buy_from_shop
function G.FUNCS.buy_from_shop(e)
    local card = e.config.ref_table
    local event
    if Object.is(card, Card) then
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
    local ret = old(e)
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
    hotpot_credits = Horsechicot.credit("cg223", nil, "lord.ruby"),
}

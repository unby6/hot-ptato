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
    pos = {x = 4, y = 1},
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

SMODS.Joker {
    hotpot_credits = Horsechicot.credit('cg223', 'pangaea47', 'lord.ruby'),
    key = "lockin",
    rarity = 2,
    config = { was_clicked = false, start_time = 0, leniency = 0.2, can_save = false },
    calculate = function(self, card, context)
        if context.game_over and card.ability.can_save then return { saved = true, message = "Saved!" } end
    end,
    atlas = "hc_jokers",
    pos = {x = 6, y = 0}
}

local old = end_round
function end_round()
    local card = SMODS.find_card("j_hpot_lockin")[1]
    if card then
        card.ability.can_save = false
        card.ability.was_clicked = false
        card.ability.start_time = love.timer.getTime()
        SMODS.calculate_effect({ message = "Click me!" }, card)
        local time_given = (G.GAME.chips / G.GAME.blind.chips) * card.ability.leniency * G.SETTINGS.GAMESPEED
        local last_juice_time = love.timer.getTime()
        G.E_MANAGER:add_event(Event({
            func = function()
                if (love.timer.getTime() - time_given) > card.ability.start_time or card.ability.was_clicked then
                    return true
                else
                    if love.timer.getTime() - 0.3 > last_juice_time then
                        last_juice_time = love.timer.getTime()
                        card:juice_up(0.1, 0.08)
                    end
                end
            end
        }))
        G.E_MANAGER:add_event(Event {
            func = function()
                if card.ability.was_clicked then
                    card.ability.can_save = true
                else
                    card.ability.can_save = false
                end
                return true
            end
        })
    end
    G.GAME.current_round.market_reroll_cost = 0.25
    if G.GAME.modifiers.windows and G.GAME.current_round.current_hand.scores then
        for i, v in pairs(G.GAME.current_round.current_hand.scores) do
            G.GAME.current_round.current_hand.scores[i] = 0
        end
    end
    if G.GAME.spawning_blocked then
        if G.GAME.spawning_reset == "ante" and G.GAME.blind_on_deck == "Boss" then
            G.GAME.spawning_blocked = {}
        end
        if G.GAME.spawning_reset == "round" then
            G.GAME.spawning_blocked = {}
        end
    end
    return old()
end

local old = Card.click
function Card:click()
    old(self)
    if self.config.center.key == "j_hpot_lockin" then
        self.ability.was_clicked = true
    end
end

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
                    func = function() ease_cryptocurrency(card.market_cost); return true end
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
    pos = {x = 3, y = 1},
    hotpot_credits = Horsechicot.credit("cg223", nil, "lord.ruby"),
}
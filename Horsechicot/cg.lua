---@diagnostic disable: undefined-field
SMODS.Joker {
    hotpot_credits = {
        art = {},
        code = { 'cg223' },
        team = { 'Horsechicot' }
    },
    key = "brainfuck",
    rarity = 3,
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
    hotpot_credits = Horsechicot.credit('cg223'),
    key = "lockin",
    config = { was_clicked = false, start_time = 0, leniency = 0.2, can_save = false },
    calculate = function(self, card, context)
        if context.game_over and card.ability.can_save then return { saved = true, message = "Saved!" } end
    end
}

local old = end_round
function end_round()
    local card = SMODS.find_card("j_hpot_lockin")[1]
    if card then
        card.ability.can_save = false
        card.ability.was_clicked = false
        card.ability.start_time = love.timer.getTime()
        SMODS.calculate_effect({ message = "Click me!" }, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                if (love.timer.getTime() - ((G.GAME.chips / G.GAME.blind.chips) * card.ability.leniency * G.SETTINGS.GAMESPEED)) > card.ability.start_time then
                    return true
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
    return old()
end

local old = Card.click
function Card:click()
    old(self)
    if self.config.center.key == "j_hpot_lockin" then
        self.ability.was_clicked = true
    end
end

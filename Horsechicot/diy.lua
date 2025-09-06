SMODS.Joker {
    key = "diy",
    rarity = 3,
    cost = 10,
    add_to_deck = function(self, card)
        if not G.GAME.hotpot_diy then
            G.GAME.DIY_OPEN = true
            G.FUNCS.overlay_menu({ definition = create_UIBox_diy() })
        end
    end,
    calculate = function(self, card, context)
        if HotPotato.diy_trigger(self, card, context) then
            return HotPotato.diy_effect(self, card, context)
        end
    end,
    loc_vars = function(self, q, card)
        if G.GAME.hotpot_diy then
            return {
                key = "j_hpot_diy_full",
                vars = {
                    localize(HotPotato.trigger_options[G.GAME.hotpot_diy.trigger]),
                    localize(HotPotato.effect_options[G.GAME.hotpot_diy.effect])
                }
            }
        end
    end
}


--TODO: Localize
HotPotato.trigger_options = {
    "hpot_diy_hand_played",
}
HotPotato.effect_options = {
    "hpot_diy_earn_dollars",
    "hpot_diy_earn_plincoins",
    "hpot_diy_earn_credits",
    "hpot_diy_earn_sparks",
    "hpot_diy_random_consumable"
}

function HotPotato.diy_trigger(self, card, context)
    if G.GAME.hotpot_diy and G.GAME.hotpot_diy.trigger == 1 then return context.joker_main end
end

function HotPotato.diy_effect(self, card, context)
    if not G.GAME.hotpot_diy then return end
    if G.GAME.hotpot_diy.effect == 1 then
        ease_dollars(2)
    elseif G.GAME.hotpot_diy.effect == 2 then
        ease_plincoins(0.1)
    elseif G.GAME.hotpot_diy.effect == 3 then
        HPTN.ease_credits(0.01)
    elseif G.GAME.hotpot_diy.effect == 4 then
        ease_spark_points(1000)
    elseif G.GAME.hotpot_diy.effect == 5 then
        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
        return {
            message = localize { type = 'variable', key = 'a_cards', vars = { 1 } },
            func = function()
                if G.GAME.consumeable_buffer + #G.consumeables.cards < G.consumeables.config.card_limit then
                    G.E_MANAGER:add_event(Event{
                        trigger = "after",
                        func = function()
                            SMODS.add_card{area=G.consumeables, set="Consumable"}
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    })
                end
            end
        }
    end
end

--[[

Triggers:
When Hand is Played         DONE
When [POKER HAND] is discarded
When [POKER HAND] is played

Effects:
Gain $2         DONE
Gain 0.1 Plincoin         DONE
Gain 0.01 Credits         DONE
Gain 1000 Joker Exchange         DONE
Create a random consumable (Must have room)
]]--

function create_UIBox_diy()
    --todo: localize
    local t = create_UIBox_generic_options({
        no_back = true,
        contents = {	
            create_option_cycle({
                options = HotPotato.trigger_options,
                w = 7.5,
                cycle_shoulders = true,
                opt_callback = "diy_option_trigger",
                current_option = 1,
                colour = G.C.RED,
                no_pips = true,
                focus_args = { snap_to = true, nav = "wide" },
            }),
            create_option_cycle({
                options = HotPotato.effect_options,
                w = 7.5,
                cycle_shoulders = true,
                opt_callback = "diy_option_effect",
                current_option = 1,
                colour = G.C.RED,
                no_pips = true,
                focus_args = { snap_to = true, nav = "wide" },
            }),
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    UIBox_button({
                        button = "diy_apply",
                        label = { localize("k_apply") },
                        minw = 4.5,
                        focus_args = { snap_to = true },
                    }),
                },
            },
        },
    })
    return t
end

function G.FUNCS.diy_apply()
    G.FUNCS:exit_overlay_menu()
    G.GAME.DIY_OPEN = false
    G.GAME.hotpot_diy = G.GAME.hotpot_diy or {}
    G.GAME.hotpot_diy.effect = G.GAME.hotpot_diy.effect or 1
    G.GAME.hotpot_diy.trigger = G.GAME.hotpot_diy.trigger or 1
end

G.FUNCS.diy_option_effect = function(args)	
    G.GAME.hotpot_diy = G.GAME.hotpot_diy or {}
    G.GAME.hotpot_diy.effect = args.cycle_config.current_option
end

G.FUNCS.diy_option_trigger = function(args)
    G.GAME.hotpot_diy = G.GAME.hotpot_diy or {}
    G.GAME.hotpot_diy.trigger = args.cycle_config.current_option
end

local keypressed_ref = love.keypressed
function love.keypressed(key, ...)
    if key ~= "escape" or not G.GAME.DIY_OPEN then
        return keypressed_ref(key, ...)
    end
end

local keyreleased_ref = love.keyreleased
function love.keyreleased(key, ...)
    if key ~= "escape" or not G.GAME.DIY_OPEN then
        return keyreleased_ref(key, ...)
    end
end
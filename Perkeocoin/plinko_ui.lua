
-- watch lua Mods/Hot-Potato/Perkeocoin/plinko_ui.lua
  
 
G.STATES.PLINKO = 2934856393

local total_rewards = 7
local plinko_cost = 69

local cached_hand_state

local reward_scale = 0.56

function G.UIDEF.plinko()
  G.GAME.current_round.plinko_reroll_cost = plinko_cost

    G.plinko_rewards = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+9,
      -- Use width for both cuz they're square
      total_rewards*reward_scale*G.CARD_W,
      reward_scale*G.CARD_W,
      {card_limit = total_rewards, type = 'shop', highlight_limit = 0})

    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.R,config={id = 'shop_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = false, button = 'hide_plinko', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              -------------------
                              {n=G.UIT.T, config={text = "Back to", scale = 0.4, colour = G.C.WHITE, shadow = true}}
                              -------------------
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              -------------------
                              {n=G.UIT.T, config={text = "shop", scale = 0.4, colour = G.C.WHITE, shadow = true}}
                              -------------------
                            }}   
                          }},              
                        }},
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.6, r=0.15,colour = G.C.MONEY, button = 'start_plinko', func = 'can_plinko', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              -------------------
                              {n=G.UIT.T, config={text = "Play", scale = 0.7, colour = G.C.WHITE, shadow = true}},
                              -------------------
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              -------------------
                              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'plinko_reroll_cost', prefix = '$'}}, maxw = 1.35, colours = {G.C.WHITE}, font = SMODS.Fonts.hpot_plincoin, shadow = true,spacing = 2, bump = false, scale = 0.75}), }},
                              -------------------
                            }}
                          }}
                        }},
                      }},
                      }},
                    }},
                    {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                      {n=G.UIT.R, config={align = "cm", colour = G.C.BLACK, minw = 7., minh = 5.8}, nodes={
                        -- TODO : this will be the area for the plinko minigame
                      }},
                      {n=G.UIT.R, config={align = "cm",}, nodes={
                        {n=G.UIT.O, config={object = G.plinko_rewards}}
                      }},
                    }},
                    --{n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},

                }
              },
              
              }, false)
        }}
    return t
end


G.FUNCS.can_plinko = function(e)
  ----------------------------------------------------------------------------
  --- TODO
  ----------------------------------------------------------------------------
  --- if plinko state isn't idle = false 
  --- if not enough plinkoins = false
  if ((G.GAME.dollars-G.GAME.bankrupt_at) - G.GAME.current_round.reroll_cost < 0) and G.GAME.current_round.reroll_cost ~= 0 then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else
      e.config.colour = G.C.MONEY
      e.config.button = 'start_plinko'
  end
end


G.FUNCS.start_plinko = function(e)
----------------------------------------------------------------------------
--- TODO
----------------------------------------------------------------------------
  stop_use()
  G.CONTROLLER.locks.start_plinko = true
  -- TODO REMVOE LATER THIS IS TEMPORARY ! ! ! !! !
  if Plinko.o.ball then
    Plinko.f.init_dummy_ball()
  else
    Plinko.f.drop_ball()
  end

  --[[
  if G.CONTROLLER:save_cardarea_focus('shop_jokers') then G.CONTROLLER.interrupt.focus = true end
  if G.GAME.current_round.reroll_cost > 0 then 
    inc_career_stat('c_shop_dollars_spent', G.GAME.current_round.reroll_cost)
    inc_career_stat('c_shop_rerolls', 1)
    ease_dollars(-G.GAME.current_round.reroll_cost)
  end
  G.E_MANAGER:add_event(Event({
    trigger = 'immediate',
    func = function()
      local final_free = G.GAME.current_round.free_rerolls > 0
      G.GAME.current_round.free_rerolls = math.max(G.GAME.current_round.free_rerolls - 1, 0)
      G.GAME.round_scores.times_rerolled.amt = G.GAME.round_scores.times_rerolled.amt + 1
      calculate_reroll_cost(final_free)
      for i = #G.shop_jokers.cards,1, -1 do
        local c = G.shop_jokers:remove_card(G.shop_jokers.cards[i])
        c:remove()
        c = nil
      end
      --save_run()
      play_sound('coin2')
      play_sound('other1')
      
      for i = 1, G.GAME.shop.joker_max - #G.shop_jokers.cards do
        local new_shop_card = create_card_for_shop(G.shop_jokers)
        G.shop_jokers:emplace(new_shop_card)
        new_shop_card:juice_up()
      end
      return true
    end
  }))
    ]]
  G.E_MANAGER:add_event(Event({
    trigger = 'after',
    delay = 0.2,
    func = function()
    G.E_MANAGER:add_event(Event({
      func = function()
        G.CONTROLLER.interrupt.focus = false
        G.CONTROLLER.locks.start_plinko = false
        -- dont need to recall shop when we start plinko
        -- G.CONTROLLER:recall_cardarea_focus('shop_jokers')
        ---------------------------------------------------------------
        -- TODO : maybe this should be moved to when reward is given?
        ---------------------------------------------------------------
        for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({start_plinko = true})
        end
        return true
      end
    }))
    return true
  end
  }))
  G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end


function update_plinko(dt)
    Plinko.f.update_plinko_world(dt)
    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.PLINKO)
        local plinko_exists = not not G.plinko
        G.plinko = G.plinko or UIBox{
            definition = G.UIDEF.plinko(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }

        print("update plinko with no G STATE_COMPLETE")

        G.E_MANAGER:add_event(Event({
            func = function()
              print "zooming maybe"
                G.plinko.alignment.offset.y = -5.3
                G.plinko.alignment.offset.x = 0
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    blockable = false,
                    func = function()
                        if math.abs(G.plinko.T.y - G.plinko.VT.y) < 3 then
                            G.ROOM.jiggle = G.ROOM.jiggle + 3
                            play_sound('cardFan2')
                            local nosave_plinko = nil
                            if not plinko_exists then
                            
                                if G.load_plinko_rewards then 
                                    nosave_plinko = true
                                    G.plinko_rewards:load(G.load_plinko_rewards)
                                    --for k, v in ipairs(G.plinko_rewards.cards) do
                                    --    if v.ability.consumeable then v:start_materialize() end
                                    --end
                                    G.load_plinko_rewards = nil
                                else
                                  ----------------------------------------------
                                  ----------------- TODO : GENERATE NEW REWARDS
                                  ----------------------------------------------
                                  for _ = 1, total_rewards - #G.plinko_rewards.cards do
                                    local card = SMODS.create_card {
                                      key = 'j_square'
                                    }
                                    G.plinko_rewards:emplace(card)
                                    end
                                end

                                for _, card in pairs(G.plinko_rewards.cards) do
                                      card:hard_set_T(nil, nil, G.CARD_W * reward_scale, G.CARD_W * reward_scale);
                                end
                            end
                            -- Back to shop button
                            G.CONTROLLER:snap_to({node = G.plinko:get_UIE_by_ID('shop_button')})

                            -- not loaded from save?
                            if not nosave_plinko then G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end})) end
                            return true
                        end
                    end}))
                return true
            end
        }))

        G.STATE_COMPLETE = true
    end

end

function won_reward(reward_num)
  assert(type(reward_num) == "number", "won_reward must be called with a number")
  
  print("damn, you won "..tostring(reward_num))
  G.E_MANAGER:add_event(Event({
    func = function()
      Plinko.f.init_dummy_ball()

      return true
    end
  }))
end

-- Let's go gambling
G.FUNCS.show_plinko = function(e)
  stop_use()

  hide_shop()
 
  G.STATE = G.STATES.PLINKO
  G.STATE_COMPLETE = false

  cached_hand_state = G.hand.states.visible
  G.hand.states.visible = false

  print "show plinko"

end

-- Clicked back to shop
G.FUNCS.hide_plinko = function(e)
  stop_use()

  print "hide plinko"
  
  G.hand.states.visible = cached_hand_state
  G.STATE = G.STATES.SHOP
  G.STATE_COMPLETE = false
  ease_background_colour_blind(G.STATE)
  show_shop()

  G.plinko.alignment.offset.y = G.ROOM.T.y + 29

    -- TODO
  --[[G.CONTROLLER.locks.toggle_shop = true
  if G.shop then 
    for i = 1, #G.jokers.cards do
      G.jokers.cards[i]:calculate_joker({ending_shop = true})
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
        G.shop.alignment.offset.y = G.ROOM.T.y + 29
        G.SHOP_SIGN.alignment.offset.y = -15
        return true
      end
    })) 
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.5,
      func = function()
        G.shop:remove()
        G.shop = nil
        G.SHOP_SIGN:remove()
        G.SHOP_SIGN = nil
        G.STATE_COMPLETE = false
        G.STATE = G.STATES.BLIND_SELECT
        G.CONTROLLER.locks.toggle_shop = nil
        return true
      end
    }))
  end]]
end



-- SUPER TEMPORARY WAY TO ADD PLINKO BUTTON

function G.UIDEF.shop()
    G.shop_jokers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      G.GAME.shop.joker_max*1.02*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = G.GAME.shop.joker_max, type = 'shop', highlight_limit = 1})


    G.shop_vouchers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.1*G.CARD_W,
      1.05*G.CARD_H, 
      {card_limit = 1, type = 'shop', highlight_limit = 1})

    G.shop_booster = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      2.4*G.CARD_W,
      1.15*G.CARD_H, 
      {card_limit = 2, type = 'shop', highlight_limit = 1, card_w = 1.27*G.CARD_W})

    local shop_sign = AnimatedSprite(0,0, 4.4, 2.2, G.ANIMATION_ATLAS['shop_sign'])
    shop_sign:define_draw_steps({
      {shader = 'dissolve', shadow_height = 0.05},
      {shader = 'dissolve'}
    })
    G.SHOP_SIGN = UIBox{
      definition = 
        {n=G.UIT.ROOT, config = {colour = G.C.DYN_UI.MAIN, emboss = 0.05, align = 'cm', r = 0.1, padding = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", padding = 0.1, minw = 4.72, minh = 3.1, colour = G.C.DYN_UI.DARK, r = 0.1}, nodes={
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = shop_sign}}
            }},
            {n=G.UIT.R, config={align = "cm"}, nodes={
              {n=G.UIT.O, config={object = DynaText({string = {localize('ph_improve_run')}, colours = {lighten(G.C.GOLD, 0.3)},shadow = true, rotate = true, float = true, bump = true, scale = 0.5, spacing = 1, pop_in = 1.5, maxw = 4.3})}}
            }},
          }},
        }},
      config = {
        align="cm",
        offset = {x=0,y=-15},
        major = G.HUD:get_UIE_by_ID('row_blind'),
        bond = 'Weak'
      }
    }
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function()
          G.SHOP_SIGN.alignment.offset.y = 0
          return true
      end)
    }))
    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.C, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      --
                      --  ONLY SOME OF THIS CODE GOT UPDATED :
                      -- minh from 1.5 and 1.6 to 1.03 and 1.04
                      -- added gambling
                      --
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.R,config={id = 'next_round_button', align = "cm", minw = 2.8, minh = 1.03, r=0.15,colour = G.C.RED, one_press = true, button = 'toggle_shop', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'y', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_1'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('b_next_round_2'), scale = 0.4, colour = G.C.WHITE, shadow = true}}
                            }}   
                          }},              
                        }},
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.04, r=0.15,colour = G.C.GREEN, button = 'reroll_shop', func = 'can_reroll', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              {n=G.UIT.T, config={text = localize('$'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                            }}
                          }}
                        }},
                        -- NEW
                        {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.03, r=0.15,colour = G.C.MONEY, button = 'show_plinko', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              ------------------- todo localize
                              {n=G.UIT.T, config={text = "Let's go", scale = 0.4, colour = G.C.WHITE, shadow = true}},
                              -------------------
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              -------------------
                              {n=G.UIT.T, config={text = "gambling", scale = 0.7, colour = G.C.WHITE, shadow = true}},
                              -------------------
                            }}
                          }}
                        }},
                      --
                      -- END
                      --
                      --
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                          {n=G.UIT.O, config={object = G.shop_jokers}},
                      }},
                    }},
                    {n=G.UIT.R, config={align = "cm", minh = 0.2}, nodes={}},
                    {n=G.UIT.R, config={align = "cm", padding = 0.1}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.BLACK, maxh = G.shop_vouchers.T.h+0.4}, nodes={
                          {n=G.UIT.T, config={text = localize{type = 'variable', key = 'ante_x_voucher', vars = {G.GAME.round_resets.ante}}, scale = 0.45, colour = G.C.L_BLACK, vert = true}},
                          {n=G.UIT.O, config={object = G.shop_vouchers}},
                        }},
                      }},
                      {n=G.UIT.C, config={align = "cm", padding = 0.15, r=0.2, colour = G.C.L_BLACK, emboss = 0.05}, nodes={
                        {n=G.UIT.O, config={object = G.shop_booster}},
                      }},
                    }}
                }
              },
              
              }, false)
        }}
    return t
end





-- watch lua Mods/Hot-Potato/Perkeocoin/plinko_ui.lua

---------------
-- Lovely UI mess
---------------


PlinkoUI = {
  s = {
    reward_scale_x = 0.56,
    reward_scale_y = 0.56 * G.CARD_W/G.CARD_H, -- square
  },
  f = { },
  sprites = {
    perkeorb = 'undefined',
    peg = 'undefined',
  }
}

SMODS.Atlas {
  key = "perkeorb",
  path = "perkeocoin_perkeorb.png",
  px = 40,
  py = 40,
}

SMODS.Atlas {
  key = "peg",
  path = "perkeocoin_peg.png",
  px = 10,
  py = 10,
}

function PlinkoUI.f.init_sprites()

  local orb_size = 40

  local a_orb = SMODS.Atlases.hpot_perkeorb
  PlinkoUI.sprites.perkeorb = Sprite {0, 0, orb_size, orb_size, a_orb}

  local peg_size = orb_size * (PlinkoGame.s.peg_radius / PlinkoGame.s.ball_radius)

  local a_peg = SMODS.Atlases.hpot_peg
  PlinkoUI.sprites.peg = Sprite {0, 0, peg_size, peg_size, a_peg}
end


function PlinkoUI.f.adjust_rewards()
  for _, card in pairs(G.plinko_rewards.cards) do
        card:hard_set_T(nil, nil, G.CARD_W * PlinkoUI.s.reward_scale_x, G.CARD_H * PlinkoUI.s.reward_scale_y);
  end
end

function PlinkoUI.f.clear_plinko_rewards()
  for k, v in pairs(G.plinko_rewards.cards) do
    v:shatter()
  end
end

function PlinkoUI.f.update_plinko_rewards(shuffle)
  if not G.plinko_rewards then
    return
  end
  PlinkoUI.f.clear_plinko_rewards()
  
  G.E_MANAGER:add_event(Event({
    delay = 0.4,
    func = (function()
      PlinkoLogic.f.generate_rewards()

        if shuffle then
          G.plinko_rewards:shuffle('plink')
        end
        PlinkoUI.f.adjust_rewards()
        return true
    end)
  }))
end

function G.UIDEF.plinko()
    G.plinko_rewards = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+9,
      PlinkoLogic.rewards.total*PlinkoUI.s.reward_scale_x*G.CARD_W,
      PlinkoUI.s.reward_scale_y*G.CARD_H,
      {card_limit = PlinkoLogic.rewards.total, type = 'shop', highlight_limit = 0})

    local t = {n=G.UIT.ROOT, config = {align = 'cl', colour = G.C.CLEAR}, nodes={
            UIBox_dyn_container({
                {n=G.UIT.R, config={align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN}, nodes={
                    {n=G.UIT.C, config={align = "tm"}, nodes={
                    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
                      {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
                        {n=G.UIT.R,config={id = 'shop_button', align = "cm", minw = 2.8, minh = 1.5, r=0.15,colour = G.C.RED, one_press = false, button = 'hide_plinko', func = 'can_hide_plinko', hover = true,shadow = true}, nodes = {
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
                              {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME.current_round, ref_value = 'plinko_roll_cost', prefix = '$'}}, maxw = 1.35, colours = {G.C.WHITE}, font = SMODS.Fonts.hpot_plincoin, shadow = true,spacing = 2, bump = false, scale = 0.75}), }},
                              -------------------
                            }}
                          }}
                        }},
                      }},
                      }},
                    }},
                    {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
                      {n=G.UIT.R, config={align = "cm", colour = G.C.BLACK, minw = 7., minh = 5.8}, nodes={

                        -- Area for the plinko minigame

                      }},
                      {n=G.UIT.R, config={align = "cm",}, nodes={
                        {n=G.UIT.O, config={object = G.plinko_rewards}}
                      }},
                    }},

                }
              },
              
              }, false)
        }}
    return t
end


G.FUNCS.can_plinko = function(e)
  if PlinkoLogic.STATE ~= PlinkoLogic.STATES.IDLE or not PlinkoLogic.f.can_roll() then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else
      e.config.colour = G.C.MONEY
      e.config.button = 'start_plinko'
  end
end

-- Shop button logic - inactive when game isn't idle
G.FUNCS.can_hide_plinko = function(e)
  if PlinkoLogic.STATE ~= PlinkoLogic.STATES.IDLE then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else
      e.config.colour = G.C.RED
      e.config.button = 'hide_plinko'
  end
end



G.FUNCS.start_plinko = function(e)
  stop_use()
  G.CONTROLLER.locks.start_plinko = true

  PlinkoLogic.STATE = PlinkoLogic.STATES.IN_PROGRESS

  PlinkoLogic.f.handle_roll()

  G.GAME.balls_dropped = G.GAME.balls_dropped + 1
  
  PlinkoGame.f.drop_ball()

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
    PlinkoGame.f.update_plinko_world(dt)
    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.PLINKO)
        local plinko_exists = not not G.plinko
        G.plinko = G.plinko or UIBox{
            definition = G.UIDEF.plinko(),
            config = {align='tmi', offset = {x=0,y=G.ROOM.T.y+11},major = G.hand, bond = 'Weak'}
        }

        G.E_MANAGER:add_event(Event({
            func = function()
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
                                    PlinkoUI.f.adjust_rewards()
                                else
                                  PlinkoUI.f.update_plinko_rewards()
                                end

                            end
                            -- Back to shop button
                            G.CONTROLLER:snap_to({node = G.plinko:get_UIE_by_ID('shop_button')})

                            return true
                        end
                    end}))
                return true
            end
        }))

        G.STATE_COMPLETE = true
    end

end

local cached_hand_state

-- Let's go gambling
G.FUNCS.show_plinko = function(e)
  stop_use()

  hide_shop()
 
  G.STATE = G.STATES.PLINKO
  G.STATE_COMPLETE = false
  PlinkoLogic.STATE = PlinkoLogic.STATES.IDLE

  cached_hand_state = G.hand.states.visible
  G.hand.states.visible = false

end

-- Clicked back to shop
G.FUNCS.hide_plinko = function(e)
  stop_use()
  
  G.hand.states.visible = cached_hand_state
  G.STATE = G.STATES.SHOP
  G.STATE_COMPLETE = false
  ease_background_colour_blind(G.STATE)
  show_shop()

  G.plinko.alignment.offset.y = G.ROOM.T.y + 29

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




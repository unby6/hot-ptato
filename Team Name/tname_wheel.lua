-- hello other teams. im so bad at coding (revo) so this just sucks but i wanted to keep it anyway
-- feel free to play arround with it and try to make it better (please)
-- i cant code :pensive:

-- PLEASE DO MORE WITH WHEEL I BEG

-- mostly copied from plinko btw


-- dont mind the G.GAME ones please i was to lazy to change them to use Wheel{}
Wheel = {
  STATE = {
    SPUN = nil,          -- is spinning
    IDLE = true          -- is idle
  },
  should_spin = true,    -- should it spin?
  Price = 15,            -- price
  Price_default = 15,    -- reset price
  ResetCheck = 0,        -- used for something below check there
  a = 0,                 -- same thing as ResetCheck
  KeepVval = 0,          -- save G.GAME.vval here cause it caused some issues
  Increase = 15,         -- to incrase with
  cost_up = 2,           -- when to up the cost (round)
  ante_left = 1,         -- when to reset the cost (ante)
  default_ante_left = 1, --resets
  default_cost_up = 2,   --resets
  ARROWS = {             -- the arrows yippe

  }
}


G.FUNCS.show_wheel = function(e) -- taken from plinko files
  stop_use()

  hide_shop()

  G.STATE = G.STATES.WHEEL
  G.STATE_COMPLETE = false
end

--copy pasted plinko
function G.UIDEF.wheel()
  -- pain
  G.wheel_area = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area2 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area3 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area4 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area5 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "shop", highlight_limit = 0 }
  )
  G.wheel_area6 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area7 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area8 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )
  G.wheel_area9 = CardArea(
    0, 0, 1, 1,
    { card_limit = 1, type = "consumeable", highlight_limit = 0 }
  )

  local use_ante = Wheel.ante_left > 0
  local play_dollars = not not G.GAME.plinko_dollars_cost

  local t = {
    n = G.UIT.ROOT,
    config = { align = 'cl', colour = G.C.CLEAR },
    nodes = {
      UIBox_dyn_container({
        {
          n = G.UIT.R,
          config = { align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN },
          nodes = {
            {
              n = G.UIT.C,
              config = { align = "tm" },
              nodes = {
                {
                  n = G.UIT.R,
                  config = { align = "cm", padding = 0.05 },
                  nodes = {
                    {
                      n = G.UIT.C,
                      config = { align = "cm", padding = 0.1 },
                      nodes = {
                        {
                          n = G.UIT.R,
                          config = { id = 'shop_button', align = "cm", minw = 2.8, minh = 1.5, r = 0.15, colour = G.C.RED, one_press = false, button = 'hide_wheel', func = 'can_hide_wheel', hover = true, shadow = true },
                          nodes = {
                            {
                              n = G.UIT.R,
                              config = { align = "cm", padding = 0.07, focus_args = { button = 'y', orientation = 'cr' }, func = 'set_button_pip' },
                              nodes = {
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.3 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.T, config = { text = localize("hotpot_plinko_to_shop1"), scale = 0.4, colour = G.C.WHITE, shadow = true } }
                                    -------------------
                                  }
                                },
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.3 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.T, config = { text = localize("hotpot_plinko_to_shop2"), scale = 0.4, colour = G.C.WHITE, shadow = true } }
                                    -------------------
                                  }
                                }
                              }
                            },
                          }
                        },

                        {
                          n = G.UIT.R,
                          config = { id = "wheel_credits", align = "cm", minw = 2.8, minh = play_dollars and 1.3 or 1.6, r = 0.15, padding = 0.07, colour = G.C.PURPLE, button = 'wheel_spin', func = 'can_wheel_spin', hover = true, shadow = true },
                          nodes = {
                            {
                              n = G.UIT.C,
                              config = { align = "cm", focus_args = { button = 'x', orientation = 'cr' }, func = 'set_button_pip' },
                              nodes = {
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.3 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.T, config = { text = localize("wheel_spin_button1"), scale = 0.7, colour = G.C.WHITE, shadow = true } },
                                    -------------------
                                  }
                                },
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.3, minw = 1 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.T, config = { text = "c.", scale = 0.7, colour = G.C.WHITE, shadow = true } },
                                    { n = G.UIT.T, config = { ref_table = Wheel, ref_value = 'Price', scale = 0.75, colour = G.C.WHITE, shadow = true } },
                                    -------------------
                                  }
                                } or nil
                              }
                            }
                          }
                        },

                        --[[   play_dollars and {n=G.UIT.R, config={id= "plinko_dollars", align = "cm", minw = 2.8, minh = 1.3, r=0.15, padding = 0.07, colour = G.C.GREEN, button = 'start_plinko_dollars', func = 'can_plinko_dollars', hover = true,shadow = true}, nodes = {
                          {n=G.UIT.C, config={align = "cm", }, nodes={
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                              -------------------
                              {n=G.UIT.T, config={text ="Spin", scale = 0.7, colour = G.C.WHITE, shadow = true}},
                              -------------------
                            }},
                            {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                              -------------------
                              {n=G.UIT.T, config={text = localize('$'), scale = 0.7, colour = G.C.WHITE, shadow = true}},
                              {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'plinko_roll_cost_dollars', scale = 0.75, colour = G.C.WHITE, shadow = true}},
                              -------------------
                            }} or nil
                          }}
                        }} or nil,]]


                        --
                        -- PLINKO INFO
                        --

                        {
                          n = G.UIT.R,
                          config = { align = "cm", id = "wheel_info", minw = 2.8, r = 0.15, minh = 1.3 },
                          nodes = {
                            {
                              n = G.UIT.C,
                              config = { align = "cm", },
                              nodes = {
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.9 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.T, config = { text = localize("hotpot_plinko_cost1"), scale = 0.75, colour = G.C.WHITE, shadow = true } },
                                    -------------------
                                  }
                                },
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.9, minw = 1 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.O, config = { object = DynaText({ string = { { ref_table = Wheel, ref_value = 'cost_up', suffix = " " .. localize("hotpot_plinko_cost2") } }, maxw = 1.35, colours = { G.C.WHITE }, font = SMODS.Fonts.hpot_plincoin, shadow = true, spacing = 2, bump = false, scale = 0.75 }), } },
                                    -------------------
                                  }
                                }
                              }
                            },
                          }
                        } or nil,
                        {
                          n = G.UIT.R,
                          config = { align = "cm", id = "wheel_reset", minw = 2.8, r = 0.15, minh = 1.3 },
                          nodes = {
                            {
                              n = G.UIT.C,
                              config = { align = "cm", },
                              nodes = {
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.9 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.T, config = { text = localize("hotpot_plinko_reset1"), scale = 0.75, colour = G.C.WHITE, shadow = true } },
                                    -------------------
                                  }
                                },
                                {
                                  n = G.UIT.R,
                                  config = { align = "cm", maxw = 1.9, minw = 1 },
                                  nodes = {
                                    -------------------
                                    { n = G.UIT.O, config = { object = DynaText({ string = { { ref_table = Wheel, ref_value = use_ante and 'ante_left' or 'rounds_left', suffix = use_ante and localize('hotpot_plinko_reset2_ante') or localize('hotpot_plinko_reset2_round') } }, maxw = 1.35, colours = { G.C.WHITE }, font = SMODS.Fonts.hpot_plincoin, shadow = true, spacing = 2, bump = false, scale = 0.75 }), } },
                                    -------------------
                                  }
                                }
                              }
                            },
                          }
                        } or nil,
                      }
                    },
                  }
                },
              }
            },

            {
              n = G.UIT.C,
              config = { align = "cm", padding = 0.2, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2 },
              nodes = {
                {
                  n = G.UIT.R,
                  config = { id = "wheeling_area", align = "cm", colour = G.C.BLACK, },
                  nodes = {

                    {
                      n = G.UIT.C,
                      config = { id = "wheeling_area", align = "cm", colour = G.C.BLACK, padding = 0., minw = 2.3, minh = 1.9 },
                      nodes = {
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area, align = "cl" } } } },
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area4, align = "cl" } } } },
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area7, align = "cl" } } } },

                      }
                    },
                    {
                      n = G.UIT.C,
                      config = { id = "wheeling_area", align = "cm", colour = G.C.BLACK, padding = 0., minw = 2.3, minh = 1.9 },
                      nodes = {
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area2, align = "cl" } } } },
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area5, align = "cl" } } } },
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area8, align = "cl" } } } },

                      }
                    },
                    {
                      n = G.UIT.C,
                      config = { id = "wheeling_area", align = "cm", colour = G.C.BLACK, padding = 0., minw = 2.3, minh = 1.9 },
                      nodes = {
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area3, align = "cl" } } } },
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area6, align = "cl" } } } },
                        { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H }, nodes = { { n = G.UIT.O, config = { object = G.wheel_area9, align = "cl" } } } },

                      }
                    },


                  }
                },
              }
            },

          }
        },

      }, false)
    }
  }
  return t
end

function update_wheel(dt) -- talen from plinko so idk
  if not G.STATE_COMPLETE then
    stop_use()
    ease_background_colour_blind(G.STATES.WHEEL)
    local plinko_exists = not not G.wheel
    G.wheel = G.wheel or UIBox {
      definition = G.UIDEF.wheel(),
      config = { align = 'tmi', offset = { x = 0, y = G.ROOM.T.y + 11 }, major = G.hand, bond = 'Weak' }
    }

    G.E_MANAGER:add_event(Event({
      func = function()
        G.wheel.alignment.offset.y = -5.3
        G.wheel.alignment.offset.x = 0
        G.E_MANAGER:add_event(Event({
          trigger = 'after',
          delay = 0.2,
          blockable = false,
          func = function()
            if math.abs(G.wheel.T.y - G.wheel.VT.y) < 3 then
              G.ROOM.jiggle = G.ROOM.jiggle + 3
              play_sound('cardFan2')
              local nosave_plinko = nil
              -- Back to shop button
              G.CONTROLLER:snap_to({ node = G.wheel:get_UIE_by_ID('shop_button') })
              set_wheel()

              return true
            end
          end
        }))
        return true
      end
    }))

    G.STATE_COMPLETE = true
  end
end

SMODS.Arrow = SMODS.Joker:extend({ -- the arrow thingy
  rarity = 1,
  unlocked = true,
  discovered = true,
  pos = { x = 0, y = 0 },
  config = {},
  set = "Arrow",
  class_prefix = "j",
  required_params = {
    "key",
  },
  in_pool = function(self, args)
    return args and args.source == "hpot_arrows"
  end,
  no_doe = true,
  inject = function(self)
    SMODS.Center.inject(self) -- ~i placed this in the wrong spot~  not anymore

    Wheel.ARROWS[#Wheel.ARROWS + 1] = self
  end
})



for i = 1, 10 do
  SMODS.Arrow({
    key = "the_arrow_" .. i,
    atlas = "tname_wheels",
    unlocked = true,
    discovered = false,
    blueprint_compat = true,
    no_collection = true,
    pos = {
      x = (i - 1),
      y = 0,
    },
  })
end

-- was from JoyousSpring (originally)
local cardarea_align_cards_ref = CardArea.align_cards -- <- i dont understand how i made this work either
-- made this actually work but im bad at math so it's kinda janky so TODO -N'
function CardArea:align_cards()
  cardarea_align_cards_ref(self)
  if G.GAME.should_rotate then
    if self == G.wheel_area5 then
      for k, card in ipairs(self.cards) do
        if G.GAME.keep_rotation then
          card.T.r = G.GAME.keep_rotation
        end
        if not G.GAME.wheel_card then
          G.GAME.wheel_card = card
        end
        if G.GAME.rotating then
          Wheel.t = Wheel.t or 6
          if not G.GAME.vval then G.GAME.vval = Wheel.KeepVval end
          Wheel.b = Wheel.b or 0
          card.T.r = card.T.r + 0.1 - math.min((Wheel.b / Wheel.t) * 0.1, 0.09)
          if card.T.r >= ((Wheel.b + 1) * math.pi * 2) then
            Wheel.b = Wheel.b + 1
          end
          G.GAME.keep_rotation = card.T.r
          if Wheel.b >= Wheel.t and math.ceil((card.T.r - (Wheel.b) * math.pi * 2) * 10) == G.GAME.vval then
            G.GAME.keep_rotation = card.T.r - (Wheel.b) * math.pi * 2
            if not G.GAME.fake_rotate then
              if in_between(0.1, 0.89, G.GAME.keep_rotation) then
                wheel_reward("reward_1")
              elseif in_between(0.89, 2.3, G.GAME.keep_rotation) then
                wheel_reward("reward_2")
              elseif in_between(2.3, 2.8, G.GAME.keep_rotation) then
                wheel_reward("reward_3")
              elseif in_between(2.8, 3.4, G.GAME.keep_rotation) then
                wheel_reward("reward_4")
              elseif in_between(3.4, 3.9, G.GAME.keep_rotation) then
                wheel_reward("reward_5")
              elseif in_between(3.9, 5.3, G.GAME.keep_rotation) then
                wheel_reward("reward_6")
              elseif in_between(5.3, 5.8, G.GAME.keep_rotation) then
                wheel_reward("reward_7")
              elseif in_between(5.8, 6.3, G.GAME.keep_rotation) then
                wheel_reward("reward_8")
              end
              G.GAME.rotating = nil
              G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.7,
                func = function()
                  reset_wheel()
                  return true
                end
              }))
            end
            G.GAME.keep_rotation = card.T.r
          end
        end
      end
    end
  end
end

-- remove after ( for testing ) ( i did not remove and its not indeed being used by the main code)
function set_wheel(no_arrow, vval_only)
  if not G.GAME.vval then
    G.GAME.vval = math.random(1, 63)
    G.GAME.winning_vval = (G.GAME.vval / 10)
    Wheel.KeepVval = G.GAME.vval
  end
  G.GAME.should_rotate = true
  if not vval_only then
    if not no_arrow and (G.wheel_area5 and #G.wheel_area5.cards == 0) then
      local k = pseudorandom_element(Wheel.ARROWS, "hpot_arrows", { source = "hpot_arrows" }).key
      local card = SMODS.add_card({ key = k, area = G.wheel_area5 })
      card.no_ui = true
    end

    local wheel_areas2 = {
      G.wheel_area,
      G.wheel_area2,
      G.wheel_area3,
      G.wheel_area4,
      G.wheel_area6,
      G.wheel_area7,
      G.wheel_area8,
      G.wheel_area9,
    }

    for k, v in pairs(wheel_areas2) do
      if #v.cards == 0 then
        generate_wheel_rewards(v)
      end
    end

    if not G.GAME.wheel_reset then
      G.GAME.wheel_reset = true
    end
  end
end

function in_between(num1, num2, numB) -- simple function
  if numB >= num1 and numB < num2 then
    return true
  end
end

function reset_wheel() -- reset EVERYTHING :D
  G.GAME.should_rotate = nil
  G.GAME.wheel_card = nil
  G.GAME.rotating = nil
  G.GAME.vval = nil
  G.GAME.keep_rotation = nil
  G.GAME.fake_rotate = nil
  Wheel.b = nil

  Wheel.STATE.IDLE = true
  Wheel.STATE.SPUN = nil
end

--[[function change_wheel() was used for testing originally
	if G.wheel_area.cards[1] then
		SMODS.destroy_cards(G.wheel_area.cards[1])
	end
	SMODS.add_card{key = "j_joker", area = G.wheel_area, stickers = {}}
end]]


function spin_wheel(fake) -- spinning the wheel
  play_sound("card1")

  set_wheel(true, true)

  Wheel.STATE.IDLE = nil -- set states
  Wheel.STATE.SPUN = true

  if fake then
    G.GAME.fake_rotate = true
  else
    G.GAME.fake_rotate = nil
  end

  G.GAME.rotating = true -- start the rotation

  -- local event
  -- event = Event {
  --   blockable = false,
  --   blocking = false,
  --   trigger = "after",
  --   delay = 3,
  --   timer = "UPTIME",
  --   func = function()
  --     reset_wheel()
  --     return true
  --   end
  -- }
  -- G.E_MANAGER:add_event(event)
end

function wheel_reward(reward) -- grant reward acording to the position
  if reward == "reward_1" then
    grant_wheel_reward(G.wheel_area3, 1)
  elseif reward == "reward_2" then
    grant_wheel_reward(G.wheel_area6, 1)
  elseif reward == "reward_3" then
    grant_wheel_reward(G.wheel_area9, 1)
  elseif reward == "reward_4" then
    grant_wheel_reward(G.wheel_area8, 1)
  elseif reward == "reward_5" then
    grant_wheel_reward(G.wheel_area7, 1)
  elseif reward == "reward_6" then
    grant_wheel_reward(G.wheel_area4, 1)
  elseif reward == "reward_7" then
    grant_wheel_reward(G.wheel_area2, 1)
  elseif reward == "reward_8" then
    grant_wheel_reward(G.wheel_area, 1)
  end
end

-- transformed the plinko one
function generate_wheel_rewards(_area)
  -- Logic for extra reward with that rarity is kinda ass
  -- didn't have time to think of something better
  if next(find_joker("Tipping Point")) then
    G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Rare + 1
    G.GAME.plinko_rewards.Common = PlinkoLogic.rewards.per_rarity.Common - 1
  else
    G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Rare
    G.GAME.plinko_rewards.Rare = PlinkoLogic.rewards.per_rarity.Uncommon
    G.GAME.plinko_rewards.Common = PlinkoLogic.rewards.per_rarity.Common
    G.GAME.plinko_rewards.Bad = PlinkoLogic.rewards.per_rarity.Bad
  end

  local rarities = {}
  for rarity, amount in pairs(G.GAME.plinko_rewards) do
    rarities[#rarities + 1] = rarity
  end
  local rarity = pseudorandom_element(rarities, "hpot_arrows_rewards")
  local card = SMODS.create_card({
    set = "bottlecap_" .. rarity,
    rarity = rarity,
  })
  if rarity == "Bad" then
    card:set_edition("e_negative")
  else
    card:set_edition()
  end
  card.states.click.can = false
  card.ability.extra.chosen = rarity
  _area:emplace(card)
end

-- granting the wheel (from plinko as well)
function grant_wheel_reward(_area, reward_num)
  assert(type(reward_num) == "number", "won_reward must be called with a number")

  local start = G.TIMERS.REAL
  local first_time = true

  draw_card(_area, G.play, 1, 'up', true, _area.cards[reward_num], nil, nil)

  G.E_MANAGER:add_event(Event { delay = 0.5, blocking = false, func = function()
    play_sound('hpot_tada')
    return true
  end })

  G.E_MANAGER:add_event(Event({
    delay = 5,
    func = function()
      if first_time then
        first_time = false

        remove_wheel_rewards()

        G.CONTROLLER:snap_to { node = _area.cards[1] }
      end

      if G.TIMERS.REAL - start < 3 then
        return false
      end

      local card = G.play.cards[1]
      if card then
        card:use_consumeable()
        SMODS.calculate_context({ using_consumeable = true, consumeable = card, area = _area })
        card:start_dissolve({ G.C.BLACK, G.C.WHITE, G.C.RED, G.C.GREY, G.C.JOKER_GREY }, true, 4)
        play_sound('hpot_bottlecap')
      end

      set_wheel(true)

      return true
    end
  }))
end

-- removing existing rewards
function remove_wheel_rewards()
  local wheel_areas2 = {
    G.wheel_area,
    G.wheel_area2,
    G.wheel_area3,
    G.wheel_area4,
    G.wheel_area6,
    G.wheel_area7,
    G.wheel_area8,
    G.wheel_area9,
  }

  for k, v in pairs(wheel_areas2) do
    if #v.cards > 0 then
      v.cards[1]:start_dissolve({ G.C.BLACK, G.C.WHITE, G.C.RED, G.C.GREY, G.C.JOKER_GREY }, true)
    end
  end
end

-- simple button functions
G.FUNCS.can_hide_wheel = function(e)
  if Wheel.STATE.SPUN then
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
    e.config.button = nil
  else
    e.config.colour = G.C.RED
    e.config.button = 'hide_wheel'
  end
end

G.FUNCS.can_wheel_spin = function(e)
  if Wheel.STATE.IDLE and HPTN.check_if_enough_credits(Wheel.Price) then
    e.config.colour = G.C.PURPLE
    e.config.button = 'wheel_spin'
  else
    e.config.colour = G.C.UI.BACKGROUND_INACTIVE
    e.config.button = nil
  end
end

G.FUNCS.wheel_spin = function(e)
  HPTN.ease_credits(-Wheel.Price)

  if Wheel.cost_up == 1 then
    Wheel.Price = Wheel.Price + Wheel.Increase
    Wheel.cost_up = Wheel.default_cost_up
  else
    Wheel.cost_up = Wheel.cost_up - 1
  end

  spin_for_real_this_time(3)
end

function spin_for_real_this_time(t)
  if not t then
    t = 3
  end
  Wheel.b = t

  set_wheel()             -- set the wheel correctly
  spin_wheel()            -- spin it
  Wheel.should_spin = nil -- its spining so it shouldnt spin
  Wheel.a = 0             -- set to 0 to restart
  -- else
  --   spin_wheel(true)        -- fake one (doesnt grant rewards)
  --   Wheel.a = Wheel.a + 1   -- add 1 for the next spin
  -- end

  -- local event
  -- event = Event({
  --   blockable = false,
  --   blocking = false,
  --   trigger = "after",
  --   delay = 3, -- adjust this to change the speed of the arrow but 2 seems ideal
  --   timer = "UPTIME",
  --   func = function()
  --     if Wheel.should_spin then
  --       spin_for_real_this_time(3) -- rerun itself
  --     else
  --       aftermath()                --aftermath lol
  --     end
  --     return true
  --   end,
  -- })
  -- G.E_MANAGER:add_event(event)
end

function aftermath()
  Wheel.should_spin = true -- make it able to spin
end

function wheel_reset_cost()
  Wheel.Price = Wheel.Price_default -- reset te wheel cost
end

function wheel_ante_up(mod) -- check if ante went up
  Wheel.ante_left = math.max(0, Wheel.ante_left - mod)

  if Wheel.ante_left <= 0 then
    wheel_reset_cost()
  end

  Wheel.ante_left = Wheel.default_ante_left
end

local ea = ease_ante
function ease_ante(mod)
  ea(mod)
  wheel_ante_up(mod)
end

-- Clicked back to shop
G.FUNCS.hide_wheel = function(e)
  SMODS.destroy_cards(G.wheel_area5.cards) -- destroy arrow

  stop_use()

  G.STATE = G.STATES.SHOP
  G.STATE_COMPLETE = false
  ease_background_colour_blind(G.STATE)
  show_shop()

  G.wheel.alignment.offset.y = G.ROOM.T.y + 29

  G.E_MANAGER:add_event(Event({
    func = function()
      if G.shop then G.CONTROLLER:snap_to({ node = G.shop:get_UIE_by_ID('next_round_button') }) end
      return true
    end
  }))
end

--idk
local ca_dref = CardArea.draw
function CardArea:draw(...)
  if self == G.hand and (G.STATE == G.STATES.WHEEL) then
    return
  end
  return ca_dref(self, ...)
end

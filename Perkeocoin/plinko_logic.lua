
---------------
-- Rewards, Rolls, etc.
---------------


G.STATES.PLINKO = 2934856393


PlinkoLogic = {
    -- Settings
    s = {
      default_roll_cost = 1,
      rolls_to_up_cost = 3,
      plincoins_per_round = 1,
    },
    
    -- GENERAL INFO    
    STATES = {
        CLOSED = 0,
        IDLE = 1,
        IN_PROGRESS = 2,
        REWARD = 3,
    },
    STATE = 0,

    
    rewards = {
        total = 7,
        per_rarity = {
            ['Common'] = 3,
            ['Uncommon'] = 2,
            ['Rare'] = 1,
            ['Bad'] = 1
        }
    },

    roll_cost_reset = {
        -- No vouchers
        {ante_left = 2, rounds_left = 0},
        -- Tier 1
        {ante_left = 1, rounds_left = 0},
        -- Tier 2
        {ante_left = 0, rounds_left = 1},
    },
    
    -- Functions
    f = { },
}

--#region Game logic

function PlinkoLogic.f.reset_plinko()
  PlinkoLogic.STATE = PlinkoLogic.STATES.IDLE
  PlinkoGame.f.init_dummy_ball()
end

function PlinkoLogic.f.generate_rewards()
  for rarity, amount in pairs(G.GAME.plinko_rewards) do
    for i = 1, amount do
      local card = SMODS.create_card {
        set = "bottlecap_"..rarity,
        rarity = rarity
      }
      if rarity == 'Bad' then
        card:set_edition("e_negative")
      else
        card:set_edition()
      end
      card.ability.extra.chosen = rarity
      G.plinko_rewards:emplace(card)
    end
  end
end

-- GIVE REWARD

function PlinkoLogic.f.won_reward(reward_num)
  assert(type(reward_num) == "number", "won_reward must be called with a number")
  
  PlinkoGame.f.remove_balls()

  draw_card(G.plinko_rewards, G.play, 1, 'up', true, G.plinko_rewards.cards[reward_num], nil, nil)

  local start = G.TIMERS.REAL
  local first_time = true

  G.E_MANAGER:add_event(Event{delay = 0.5, blocking = false, func = function ()
    play_sound('hpot_tada')
    return true
  end})

  G.E_MANAGER:add_event(Event({
    delay = 5,
    func = function()
      if first_time then
        first_time = false
        PlinkoUI.f.clear_plinko_rewards()

        G.CONTROLLER:snap_to {node = G.plinko_rewards.cards[1]}
      end

      if G.TIMERS.REAL - start < 3 then
        return false
      end

      local card = G.play.cards[1]
      if card then
        card:use_consumeable()
        for i = 1, #G.jokers.cards do
          G.jokers.cards[i]:calculate_joker({using_consumeable = true, consumeable = G.play.cards[1]})
        end
        card:start_dissolve({G.C.BLACK, G.C.WHITE, G.C.RED, G.C.GREY, G.C.JOKER_GREY}, true, 4)
        play_sound('hpot_bottlecap')
      end

      PlinkoUI.f.update_plinko_rewards(true)

      PlinkoLogic.f.reset_plinko()

      G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
      return true
    end
  }))
end

--#endregion

--#region Roll cost logic

-- NOTE FOR VOUCHER IMPL: 
-- run PlinkoLogic.f.reset_cost(true) to update when the roll cost is gonna reset

function PlinkoLogic.f.reset_cost(keep_roll_cost)
  local current_level = 1
  if G.GAME.used_vouchers['hpot_plincoin2'] then
    current_level = 3
  elseif G.GAME.used_vouchers['hpot_plincoin1'] then
    current_level = 2
  end

  if not keep_roll_cost then
    G.GAME.current_round.plinko_roll_cost = PlinkoLogic.default_roll_cost
    G.GAME.current_round.plinko_rolls = 0
    G.GAME.current_round.plinko_cost_up_in = G.GAME.rolls_to_up_cost
  end
  G.GAME.current_round.plinko_cost_reset = copy_table(PlinkoLogic.roll_cost_reset[current_level])
end

function PlinkoLogic.f.ante_up(mod)
  G.GAME.current_round.plinko_cost_reset.ante_left = math.max(0, G.GAME.current_round.plinko_cost_reset.ante_left - mod)

  if G.GAME.current_round.plinko_cost_reset.ante_left <= 0 and G.GAME.current_round.plinko_cost_reset.rounds_left <= 0 then
    PlinkoLogic.f.reset_cost()
  end
end

local ea = ease_ante
function ease_ante(mod)
  ea(mod)
  PlinkoLogic.f.ante_up(mod)
end


function PlinkoLogic.f.round_up(mod)
  G.GAME.current_round.plinko_cost_reset.rounds_left = math.max(0, G.GAME.current_round.plinko_cost_reset.rounds_left - mod)
  
  if G.GAME.current_round.plinko_cost_reset.ante_left <= 0 and G.GAME.current_round.plinko_cost_reset.rounds_left <= 0 then
    PlinkoLogic.f.reset_cost()
  end
end

local er = ease_round
function ease_round(mod)
  er(mod)
  PlinkoLogic.f.round_up(mod)
end

function PlinkoLogic.f.update_roll_cost()
  G.GAME.current_round.plinko_cost_up_in = G.GAME.rolls_to_up_cost - G.GAME.current_round.plinko_rolls % G.GAME.rolls_to_up_cost

  -- Cost grows every 3 rounds +1
  if G.GAME.current_round.plinko_rolls % G.GAME.rolls_to_up_cost == 0 then
    G.GAME.current_round.plinko_roll_cost = G.GAME.current_round.plinko_roll_cost + 1
  end
end

function PlinkoLogic.f.can_roll()
  return G.GAME.plincoins >= G.GAME.current_round.plinko_roll_cost
end

function PlinkoLogic.f.handle_roll()
  ease_plincoins(-G.GAME.current_round.plinko_roll_cost)

  G.GAME.current_round.plinko_rolls = G.GAME.current_round.plinko_rolls + 1

  PlinkoLogic.f.update_roll_cost()
end

--#endregion



Plincoin = {
  default_roll_cost = 1,
  -- Functions
  f = { }
}


SMODS.Font {
  key = "plincoin",
  path = "plincoin2.ttf"
}

--#region Plinko Roll cost logic
local costs = {
  {ante_left = 2, rounds_left = 0},
  {ante_left = 1, rounds_left = 0},
  {ante_left = 0, rounds_left = 1},
}

-- NOTE FOR VOUCHER IMPL: 
-- run Plincoin.f.reset_cost(true) to update when the roll cost is gonna reset

function Plincoin.f.reset_cost(keep_roll_cost)
  local current_level = 1
  if G.GAME.used_vouchers['hpot_plincoin2'] then
    current_level = 3
  elseif G.GAME.used_vouchers['hpot_plincoin1'] then
    current_level = 2
  end

  if not keep_roll_cost then
    G.GAME.current_round.plinko_roll_cost = Plincoin.default_roll_cost
  end
  G.GAME.current_round.plinko_cost_reset = copy_table(costs[current_level])
end

function Plincoin.f.ante_up()
  G.GAME.current_round.plinko_cost_reset.ante_left = math.max(0, G.GAME.current_round.plinko_cost_reset.ante_left - 1)

  if G.GAME.current_round.plinko_cost_reset.ante_left <= 0 and G.GAME.current_round.plinko_cost_reset.rounds_left <= 0 then
    Plincoin.f.reset_cost()
  end
end

function Plincoin.f.round_up()
  G.GAME.current_round.plinko_cost_reset.rounds_left = math.max(0, G.GAME.current_round.plinko_cost_reset.rounds_left - 1)

  if G.GAME.current_round.plinko_cost_reset.ante_left <= 0 and G.GAME.current_round.plinko_cost_reset.rounds_left <= 0 then
    Plincoin.f.reset_cost()
  end
end

function Plincoin.f.can_roll()
  return G.GAME.plincoins >= G.GAME.current_round.plinko_roll_cost
end

function Plincoin.f.handle_roll()
  G.GAME.current_round.plinko_rolls = G.GAME.current_round.plinko_rolls + 1
  -- Cost grows every 3 rounds +1
  if G.GAME.current_round.plinko_rolls % 3 == 0 then
    G.GAME.current_round.plinko_roll_cost = G.GAME.current_round.plinko_roll_cost + 1
  end
end

--#endregion

local gigo = Game.init_game_object
function Game:init_game_object()
  local t = gigo(self)
  t.plincoins = 0
  t.current_round.plincoins = 0
  
  t.current_round.plinko_roll_cost = Plincoin.default_roll_cost
  t.current_round.plinko_rolls = 0
  t.current_round.plinko_cost_reset = {ante_left = 2, rounds_left = 0}

  return t
end




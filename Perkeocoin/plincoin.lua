
Plincoin = {
  -- Functions
  f = { }
}

-- SMODS.Fonts.hpot_plincoin
SMODS.Font {
  key = "plincoin",
  path = "plincoin2.ttf"
}

local gigo = Game.init_game_object
function Game:init_game_object()
  local t = gigo(self)
  t.plincoins = 0
  t.current_round.plincoins = 0
  
  t.current_round.plinko_roll_cost = PlinkoLogic.s.default_roll_cost
  t.current_round.plinko_rolls = 0
  t.current_round.plinko_cost_reset = {ante_left = 2, rounds_left = 0}

  return t
end




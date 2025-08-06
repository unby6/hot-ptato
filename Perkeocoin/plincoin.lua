
-- SMODS.Fonts.hpot_plincoin
SMODS.Font {
  key = "plincoin",
  path = "plincoin2.ttf"
}

local gigo = Game.init_game_object
function Game:init_game_object()
  local t = gigo(self)
  t.plincoins = 0
  t.balls_dropped = 0
  t.current_round.plincoins = 0
  
  t.current_round.plinko_roll_cost = PlinkoLogic.s.default_roll_cost
  t.current_round.plinko_rolls = 0
  t.current_round.plinko_cost_reset = {ante_left = 2, rounds_left = 0}

  return t
end

local cuh = create_UIBox_HUD
function create_UIBox_HUD()
  local nodes = cuh()

  local contents_buttons = nodes.nodes[1].nodes[1].nodes[5].nodes[1].nodes[1].nodes

  local scale = 0.4
  local temp_col = G.C.DYN_UI.BOSS_MAIN
  local temp_col2 = G.C.DYN_UI.BOSS_DARK

  -- run_info
  contents_buttons[1].config.minh = 1
  -- options
  contents_buttons[2].config.minh = 1

  -- Literally dollars UI copypasted
  table.insert(contents_buttons, 2, {n=G.UIT.R, config={align = "cm"}, nodes={
      {n=G.UIT.C, config={align = "cm", padding = 0.05, minw = 1.55, minh = 1.15, colour = temp_col, emboss = 0.05, r = 0.1}, nodes={
        {n=G.UIT.R, config={align = "cm"}, nodes={
          {n=G.UIT.C, config={align = "cm", r = 0.1, minw = 1.25, minh = 1, colour = temp_col2}, nodes={
            {n=G.UIT.O, config={object = DynaText({string = {{ref_table = G.GAME, ref_value = 'plincoins', prefix = localize('$')}}, maxw = 1.2, colours = {G.C.MONEY}, font = SMODS.Fonts.hpot_plincoin, shadow = true,spacing = 2, bump = true, scale = 2.2*scale}), id = 'plincoin_text_UI'}}
          }},
        }},
      }},
    }})

  return nodes
end



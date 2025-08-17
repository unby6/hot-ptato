-- This is by far the worst thing added probably

local c_u_h_ref = create_UIBox_HUD
function create_UIBox_HUD()
	local nodes = c_u_h_ref()

	-- whole lot of padding here
	local contents = nodes.nodes[1].nodes[1].nodes

	local scale = 0.4
	local temp_col = G.C.DYN_UI.BOSS_MAIN
	local temp_col2 = G.C.DYN_UI.BOSS_DARK

	-- add text for spark points
	table.insert(contents,
		{
			n = G.UIT.R,
			config = { align = "cm", id = 'row_spark' },
			nodes = {
				{
					n = G.UIT.C,
					config = { align = "cm", padding = 0.05, minw = 3, minh = 0.6, colour = temp_col, emboss = 0.05, r = 0.1 },
					nodes = {
						{
							n = G.UIT.R,
							config = { align = "cm" },
							nodes = {
								{
									n = G.UIT.C,
									config = { align = "cm", r = 0.1, minw = 2.85, minh = 0.5, colour = temp_col2, padding = -0.8*scale },
									nodes = {
										{
											n = G.UIT.C,
											config = { id = 'spark_text_label', align = "tl", minw = 2.85 },
											nodes = {
												{
													n = G.UIT.R,
													config = { minw = 0, minh = 0 }
												},
												{
													n = G.UIT.T,
													-- Having to add manual spaces fucking SUCKS
													config = { text = '    Joker points:', colour = G.C.UI.TEXT_LIGHT, scale = 0.8 * scale }
												}
											}
										},
										{
											n = G.UIT.C,
											config = { align = "cr", minw = 2.85 },
											nodes = {
												{
													n = G.UIT.R,
													config = { minw = 0.5, minh = 0 }
												},
												{
													n = G.UIT.O,
													config = {
														object = DynaText {
															string = {
																{ ref_table = G.GAME, ref_value = 'spark_points' }
															},
															colours = { G.C.BLUE },
															shadow = true,
															spacing = 2,
															bump = true,
															scale = 0.8 * scale
														},
														id = 'spark_text_UI'
													}
												}
											}
										},
									}
								},
							}
						},
					}
				},
			}
		})

	return nodes
end

local i_g_o_ref = Game.init_game_object
function Game:init_game_object()
	local game = i_g_o_ref(self)

	-- obviously you start with NOTHING !!!!
	game.spark_points = 0

	return game
end

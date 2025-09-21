function G.FUNCS.toggle_currencies()
    if not Toggle_currencies then Toggle_currencies = true else Toggle_currencies = false end
    G.HUD:remove()
    G.HUD_blind:remove()
    G.HUD = UIBox{
        definition = create_UIBox_HUD(),
        config = {align=('cli'), offset = {x=-0.7,y=0},major = G.ROOM_ATTACH}
    }
    G.HUD_blind = UIBox{
        definition = create_UIBox_HUD_blind(),
        config = {major = G.HUD:get_UIE_by_ID('row_blind_bottom'), align = 'bmi', offset = {x=0,y=-10}, bond = 'Weak'}
    }
end
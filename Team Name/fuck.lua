-- Fucking global thing to hold FUCKING EVERYTHING TEAM NAME
HPTN = {
    is_shitfuck = true,
}

SMODS.Rarity{
    key = "creditable",
    loc_txt = {name = "Creditable"},
    pools = {Joker = true},
    badge_colour = G.C.PURPLE,
    default_weight = 0.25
}
SMODS.Atlas{key = "teamname_shitfuck", path = "Team Name/shitfuck.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_jokers", path = "Team Name/tname_jokers.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_jokers2", path = "Team Name/tname_jokers2.png", px = 71, py = 95} -- 2 joker atlases. Wow. just wow.

G.FUNCS.can_sell_card = function(e)
    if e.config.ref_table:can_sell_card() then 
        if e.config.ref_table.config.center.credits then
        e.config.colour = G.C.PURPLE
        e.config.button = 'sell_card'
        else
        e.config.colour = G.C.GREEN
        e.config.button = 'sell_card'
        end
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end
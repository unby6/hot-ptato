-- Fucking global thing to hold FUCKING EVERYTHING TEAM NAME
HPTN = {
    is_shitfuck = true,
}

SMODS.Atlas{key = "teamname_shitfuck", path = "Team Name/shitfuck.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_jokers", path = "Team Name/tname_jokers.png", px = 71, py = 95}
SMODS.Joker:take_ownership('j_joker',
    {
    atlas = "teamname_shitfuck",
    credits = 120,
	cost = 0,
    loc_txt = {name = "Joker", text = {"{C:attention}Revives{} one character"}},
    loc_vars = function (self, info_queue, card)
        return { vars = {} }
    end,
    config = {},
    calculate = function (self, card, context)
        local ck = math.random(56, 98)
        if context.end_of_round and context.game_over and context.main_eval then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end -- copied from vr LMAO
            }))
            return {
                message = "+"..ck.." HP",
                saved = 'teamname_off_reference',
                colour = G.C.GREEN
            }
        end
    end,
    hotpot_credits = {
        art = {'GoldenLeaf'},
        idea = {"GoldenLeaf"},
        code = {'GoldenLeaf'},
        team = {'Team Name'}
    },
    },
    false
)

G.FUNCS.can_sell_card = function(e)
    if e.config.ref_table:can_sell_card() then 
        if e.config.ref_table.config.center.credits then
        e.config.colour = G.C.BLUE
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
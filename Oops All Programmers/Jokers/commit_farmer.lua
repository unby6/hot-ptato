SMODS.Joker {
    key = "commit_farmer",
    rarity = 3,
    cost = 8,
    config = {
        extra = {
            commits = {
                perkeocoin = 275,
                sillyposting = 97,
                jtem = 255,
                ["team name"] = 307,
                ["team :)"] = 16,
                horsechicot = 540,
                ["oops! all programmers"] = 14
            },
            xmult_base = 1,
            xmult_inc = 0.01
        }
    },
    atlas = "oap_jokers",
    pos = { x = 4, y = 0 },
    loc_vars = function(self, info_queue, card)
        local team = G.GAME.current_round.hpot_commit_farmer_team or "Sillyposting"
        local commits = card.ability.extra.commits[team:lower()] or 0
        local xmult = card.ability.extra.xmult_inc * commits
        return {vars={card.ability.extra.xmult_inc, team, xmult}}
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return { xmult = card.ability.extra.xmult_inc * (card.ability.extra.commits[G.GAME.current_round.hpot_commit_farmer_team:lower()] or 0) }
        end
    end,
    hotpot_credits = {
        art = {'?'},
        code = {'trif'},
        idea = {'trif'},
        team = {'Oops! All Programmers'}
    }
}
function reset_commit_farmer()
    G.GAME.current_round.hpot_commit_farmer_team = G.GAME.current_round.hpot_commit_farmer_team or "Sillyposting"
    local teams = {}
    for k, v in ipairs({"Perkeocoin", "Sillyposting", "Jtem", "Team Name", "Team :)", "Horsechicot", "Oops! All Programmers"}) do -- add more for last week pls
        if v ~= G.GAME.current_round.hpot_commit_farmer_team then
            teams[#teams+1] = v
        end
    end
    local team = pseudorandom_element(teams, "commit_farmer_" .. G.GAME.round_resets.ante)
    G.GAME.current_round.hpot_commit_farmer_team = team
end

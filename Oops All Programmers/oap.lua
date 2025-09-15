OAP = {} -- GET GLOBAL NOW!!!!!!!
function OAP.credit(coders, arters, ideaers) -- stolen from horsechicot god bless
    if type(coders) == "string" then
        coders = {coders}
    end
    if type(arters) == "string" then
        arters = {arters}
    end
    if type(ideaers) == "string" then
        ideaers = {ideaers}
    end
    return {
        code = coders,
        art = arters,
        idea = ideaers,
        team = { 'Oops! All Programmers' }
    }
end

local rgg_ref = SMODS.current_mod.reset_game_globals
function SMODS.current_mod.reset_game_globals(run_start) -- i am the worst developer of all time - trif
    rgg_ref(run_start) -- so sorry
    reset_commit_farmer()
end

-- atlas stuff, keep it at the end probably
SMODS.Atlas{key = "oap_jokers", path = "Oops! All Programmers/oap_jokers.png", px = 71, py = 95}

--ads
SMODS.Atlas{key = "oap_roffle", path = "Ads/roffleland.png", px=218, py=121}
SMODS.Atlas{key = "oap_danielad", path = "Ads/findhim.png", px=125, py=188}
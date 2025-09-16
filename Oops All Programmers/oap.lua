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
SMODS.Atlas{key = "oap_pb", path = "Oops! All Programmers/oap_pb.png", px = 71, py = 95}

--ads
SMODS.Atlas{key = "oap_roffle", path = "Ads/roffleland.png", px=218, py=121}
SMODS.Atlas{key = "oap_danielad", path = "Ads/findhim.png", px=125, py=188}
SMODS.Atlas{key = "oap_barga", path = "Ads/barga.png", px=218, py=270}
SMODS.Atlas{key = "oap_sex", path = "Ads/sex.png", px=218, py=140} -- hey what the fuck - myst
SMODS.Atlas{key = "oap_superepicramp", path = "Ads/SuperEpicRamp.png", px=218, py=153}
SMODS.Atlas{key = "oap_thanosyikes", path = "Ads/thanosYikes.png", px=218, py=217}
SMODS.Atlas{key = "oap_palombi", path = "Ads/palombi.png", px=224, py=250}
SMODS.Atlas{key = "oap_lebron", path = "Ads/lebron.png", px=100, py=100}
SMODS.Atlas{key = "oap_donut", path = "Ads/donut.png", px=200, py=263}

-- sounds
SMODS.Sound {
    key = 'forgiveness',
    path = 'sfx_forgiveness.ogg'
}

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

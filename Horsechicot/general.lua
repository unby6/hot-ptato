Horsechicot = {}
function Horsechicot.credit(coders, arters)
    if type(coders) == "string" then
        coders = {coders}
    end
    if type(arters) == "string" then
        arters = {arters}
    end
    return {
        code = coders,
        art = arters,
        team = { 'Horsechicot' }
    }
end
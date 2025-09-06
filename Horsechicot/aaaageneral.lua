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
SMODS.Atlas{key = "hc_jokers", path = "Horsechicot/hc_jokers.png", px = 71, py = 95}

HPJTTT.add_texts({
    "and now... a word from our Sponsor. Entropy.",
    "Attempt to compare Joker with Table",
    "Now in 3D",
})
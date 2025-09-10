---@diagnostic disable: undefined-field




function Horsechicot.num_jokers()
    if Horsechicot.joker_count_cache then
        return Horsechicot.joker_count_cache
    end
    Horsechicot.joker_count_cache = 0
    for i, v in pairs(G.P_CENTERS) do
        if string.sub(i, 1, 2) == "j_" and not v.no_collection then
            Horsechicot.joker_count_cache = Horsechicot.joker_count_cache + 1
        end
    end
    return Horsechicot.joker_count_cache
end

SMODS.Atlas {
    key = "cg223",
    path = "Horsechicot/cg223.png",
    px = 71,
    py = 95
}


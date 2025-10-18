SMODS.Joker {
    key = 'box_of_frogs',
    rarity = 3,
    blueprint_compat = false,
    cost = 7,
    atlas = "oap_jokers",
    pos = { x = 9, y = 0 },
    hotpot_credits = {
        art = { 'th30ne' },
        code = { 'theAstra' },
        idea = { 'th30ne' },
        team = { 'O!AP' }
    }
}

local gcp = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    local _pool, _pool_key = gcp(_type, _rarity, _legendary, _append)

    if _type == 'Joker' and next(SMODS.find_card('j_hpot_box_of_frogs')) and _append == 'sho' then
        for i = 1, #_pool do
            local key = _pool[i]
            if key ~= G.GAME.current_forced_key and G.P_CENTERS[key] and not G.P_CENTERS[key].original_mod then
                _pool[i] = "UNAVAILABLE"
            end
        end
    end

    return _pool, _pool_key
end

local cc = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, extra)
    if forced_key then
        G.GAME.current_forced_key = forced_key
    end
    local ret = cc(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append, extra)
    G.GAME.current_forced_key = nil
    return ret
end
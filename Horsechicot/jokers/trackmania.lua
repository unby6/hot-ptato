SMODS.Joker {
    key = "hc_trackmania",
    config = {
        start_time = 0,
        def_xmult = 4,
        dec_per_sec = 0.01,
    },
    rarity = 3,
    cost = 6,
    atlas = "hc_jokers",
    pos = { x = 6, y = 4 },
    soul_pos = { x = 7, y = 4 },
    loc_vars = function(self, info_queue, card)
        local t_since_ante = love.timer.getTime() - card.ability.start_time
        local xmult = card.ability.def_xmult - (t_since_ante * card.ability.dec_per_sec)
        xmult = math.max(xmult, 1)
        xmult = math.floor(xmult * 10) / 10
        return {
            vars = {
                card.ability.def_xmult,
                card.ability.dec_per_sec,
                xmult
            }
        }
    end,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    calculate = function(self, card, context)
        if context.joker_main then
            local t_since_ante = love.timer.getTime() - card.ability.start_time
            local xmult = card.ability.xmult - (t_since_ante * card.ability.dec_per_sec)
            xmult = math.max(xmult, 1)
            xmult = math.floor(xmult * 10) / 10
            return { xmult = xmult }
        elseif context.beat_boss then
            card.ability.start_time = love.timer.getTime()
        end
    end,
    set_ability = function(self, card, from_debuff)  --so you cant reload game for x30 mult, etc
        card.ability.start_time = love.timer.getTime()
    end,
    hotpot_credits = Horsechicot.credit("cg223", "cg223", "cg223")
}

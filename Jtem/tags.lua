
-- mmm tag
SMODS.Tag {
    key = "jokerexchange",
    atlas = "jtem_jxtag",
    pos = { x = 0, y = 0 },
    config = { jx = 25000 },
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.jx } }
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            tag:yep('+', G.C.BLUE, function()
                ease_spark_points(tag.config.jx)
                return true
            end)
            tag.triggered = true
        end
    end,
    hotpot_credits = {
        art = {'MissingNumber'},
        idea = {'MissingNumber'},
        code = {'Haya'},
        team = {'Jtem'}
    },
}


SMODS.Tag{
    key = "double_jx",
    config = {
        extras = {odds = 1, denom = 2, xgive_jx = 2}
    },
    loc_vars = function (self, info_queue, tag)
        local n, d = SMODS.get_probability_vars(tag, tag.config.extras.odds, tag.config.extras.denom, "double_jx")
        return {
            vars = {
                n,
                d,
                tag.config.extras.xgive_jx
            }
        }
    end,
    atlas = "jtem_jxtag_dobule", pos = { x = 0, y = 0},
    apply = function (self, tag, context)
        if context.type == 'immediate' then
            local lock = tag.ID
            G.GAME.spark_points = G.GAME.spark_points or 0
            G.CONTROLLER.locks[lock] = true
            if SMODS.pseudorandom_probability(tag,  "double_jx", tag.config.extras.odds, tag.config.extras.denom) then
                tag:yep("+",G.C.BLUE,function ()
                    ease_spark_points(G.GAME.spark_points - tag.config.extras.give_jx * G.GAME.spark_points)
                end)
            else
                tag:nope()
            end
            tag.triggered = true
            return true
        end 
    end,
    hotpot_credits = {
        art = {'MissingNumber'},
        idea = {'Aikoyori'},
        code = {'Aikoyori'},
        team = {'Jtem'}
    },
}

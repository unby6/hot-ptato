SMODS.Tag {
    key = "credits_tag",
    config = { add = 10 },
    loc_vars = function(self, info_queue, tag)
        return { vars = { tag.config.add } }
    end,
    apply = function(self, tag, context)
        if context.type == 'immediate' then
            tag:yep('+', G.C.PURPLE, function()
                HPTN.ease_credits(tag.config.add )
                return true
            end)
            tag.triggered = true
        end
    end,
    hotpot_credits = {
        art = {'No Art'},
        idea = {'Revo'},
        code = {'Revo'},
        team = {'Team Name'}
    },
}
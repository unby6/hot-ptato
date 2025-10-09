SMODS.Achievement {
    key = 'sign_here',
    hidden_name = false,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
        if args.type == 'fine_print' and args.conditions == 3 then
            return true
        end
    end
}

SMODS.Achievement{
    key = 'selfcest',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return args.type == 'selfcest'
    end
}

SMODS.Achievement{
    key = 'maniac',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    reset_on_startup = true,
    unlock_condition = function(self, args)
        return args.type == 'maniac'
    end
}
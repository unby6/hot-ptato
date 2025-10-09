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

SMODS.Achievement {
    key = 'rigged',
    bypass_all_unlocked = true,
    hidden_name = false,
    hidden_text = false,
    unlock_condition = function(self, args)
        return (args.type == 'max_rare_caps' and args.conditions == 7)
    end
}

SMODS.Achievement {
    key = 'cungadero',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return (args.type == 'cungadero' and args.conditions >= 100)
    end
}
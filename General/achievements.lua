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

SMODS.Achievement {
    key = 'aura_farming',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return (args.type == 'aura_farming' and args.conditions.joke <= 0 and args.conditions.cons <= 0 and args.conditions.hand <= 1)
    end

}

SMODS.Achievement {
    key = 'whoppers',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    unlock_condition = function(self,args)
        return(args.type == 'whoppers')
    end,
}

SMODS.Achievement {
    key = 'destroy_the_stones',
    hidden_name = false,
    hidden_text = true,
    bypass_all_unlocked = true,
    unlock_condition = function(self, args)
       if args.type == 'lotus_banish' and args.key == 'j_hpot_lotus' then
           return true
       end
   end
}

SMODS.Achievement {
    key = 'max_mood',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return (args.type == 'max_mood' and args.conditions == 'trance')
    end
}

SMODS.Achievement {
    key = 'five_lights',
    bypass_all_unlocked = true,
    hidden_name = true,
    hidden_text = false,
    unlock_condition = function(self, args)
        return (args.type == 'five_lights')
    end
}
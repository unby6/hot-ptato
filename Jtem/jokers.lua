SMODS.Atlas {
    key = "jtem_jokers",
    path = "Jtem/jokers.png",
    px = 71, py = 95
}

SMODS.Joker {
    key = "jtemj",
    atlas = "jtem_jokers",
    config = {x_mult = 1.1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.x_mult}}
    end,
    hotpot_credits = {
        art = {'LocalThunk'},
        code = {'Squidguset'},
        team = {'Jtem'}
    },
}

SMODS.Joker {
    key = "jtemo",
    atlas = "jtem_jokers",
    pos = {x=1,y=0},
    config = {x_mult = 1.1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.x_mult}}
    end,
    hotpot_credits = {
        art = {'LocalThunk'},
        code = {'Squidguset'},
        team = {'Jtem'}
    },
}

SMODS.Joker {
    key = "jtemk",
    atlas = "jtem_jokers",
    pos = {x=2,y=0},
    config = {x_mult = 1.1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.x_mult}}
    end,
    hotpot_credits = {
        art = {'LocalThunk'},
        code = {'Squidguset'},
        team = {'Jtem'}
    },
}


SMODS.Joker {
    key = "jteme",
    atlas = "jtem_jokers",
    pos = {x=3,y=0},
    config = {x_mult = 1.1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.x_mult}}
    end,
    hotpot_credits = {
        art = {'LocalThunk'},
        code = {'Squidguset'},
        team = {'Jtem'}
    },
}


SMODS.Joker {
    key = "jtemr",
    atlas = "jtem_jokers",
    pos = {x=4,y=0},
    config = {x_mult = 1.1},
    loc_vars = function(self,info_queue,card)
        return {vars = {card.ability.x_mult}}
    end,
    hotpot_credits = {
        art = {'LocalThunk'},
        code = {'Squidguset'},
        team = {'Jtem'}
    },
}

SMODS.Joker {
    key = "nxkoodead",
    atlas = "jtem_jokers",
    pos = {x=0,y=1},
    config = {extra = {gain = 0.25,per = 20,}},
    soul_pos = {x=1,y=1},
    rarity = 4,
    loc_vars = function (self,info_queue,card)
        local save = G.PROFILES[G.SETTINGS.profile]
        return {vars = {
            card.ability.extra.per, card.ability.extra.gain,math.min((math.floor((save.JtemNXkilled or 0)/card.ability.extra.per) * card.ability.extra.gain)+1,15)
        }}
    end,
    calculate = function(self,card,context)
        local save = G.PROFILES[G.SETTINGS.profile]
        if context.joker_main then
            return {
                xmult = math.min((math.floor((save.JtemNXkilled or 0)/card.ability.extra.per) * card.ability.extra.gain)+1,15)
            }
        end
    end,
    hotpot_credits = {
        art = {'MissingNumber'},
        code = {'Squidguset'},
        team = {'Jtem'}
    },
}

SMODS.Joker {
    key = "retriggered",
    atlas = "jtem_jokers",
    pos = { x = 3, y = 1 },
    config = { extra = { retriggers = 1 } },
    rarity = 3,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers } }
    end,
    calculate = function(self, card, context)
        if (context.repetition) or (context.retrigger_joker_check and not context.retrigger_joker) then
            return {
                repetitions = card.ability.extra.retriggers,
                sound = "hpot_ws_again"
            }
        end
    end,
    hotpot_credits = {
        art = {'MissingNumber'},
        code = {'Haya'},
        idea = {'MissingNumber'}, -- No one adds this for some reason. For future mods please do :pray:
        team = {'Jtem'}
    }
}



SMODS.Joker {
    key = "greedybastard",
    atlas = "jtem_jokers",
    pos = {x=4,y=1},
    rarity = 2,
    config = {
        mult = 0,
        extra = {
            gain = 12
        }
    },
    calculate = function (self,card,context)
        if context.hp_card_removed and not context.blueprint then
            local key = context.card.config.center.key
            if (G.P_CENTERS[key].pools and G.P_CENTERS[key].pools.Food) then
                card.ability.mult = card.ability.mult + card.ability.extra.gain
                card_eval_status_text(
					card,
					nil,
					nil,
					nil,
					{ message = localize("k_upgrade_ex"), colour = G.C.RED}
				)
            end
        end
    end
}

local ref = SMODS.showman
function SMODS.showman(key)
    if next(SMODS.find_card('j_hpot_greedybastard')) and (G.P_CENTERS[key].pools and G.P_CENTERS[key].pools.Food) then
        return true
    end
    return ref(key)
end



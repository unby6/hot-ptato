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
    loc_vars = function (self, info_queue, card)
        return {
            vars = {
                card.ability.extra.gain,
                card.ability.mult
            }
        }
    end,
    calculate = function (self,card,context)
        if context.hp_card_destroyed and not context.blueprint and not context.is_being_sold then
            local key = context.card_being_destroyed.config.center.key
            if (G.P_CENTERS[key].pools and G.P_CENTERS[key].pools.Food) then
                return {
                    func = function()
                        card.ability.mult = card.ability.mult + card.ability.extra.gain
                    end,
                    message = localize("k_upgrade_ex")
                }
                
            end
        end
    end,
    hotpot_credits = {
        art = {'MissingNumber'},
        code = {'Squidguset'},
        idea = {'MissingNumber'}, -- No one adds this for some reason. For future mods please do :pray:
        team = {'Jtem'}
    }
}

function hpot_jtem_scale_card(card, key)
    if SMODS.scale_card then
        SMODS.scale_card(card,
            {
                ref_table = card.ability.extra,
                ref_value = key,
                scalar_value = key.."_mod",
                operation = "+",
                no_message = true
            }
        )
    else
        card.ability.extra[key] = card.ability.extra[key] + card.ability.extra[key.."_mod"]
    end
end

SMODS.Joker {
    key = "labubu",
    atlas = "jtem_jokers",
    pos = {x=0,y=2},
    rarity = 2,
    config = { extra = { xmult = 1, xmult_mod = 0.1, cion = 1 } },
    calculate = function(self, card, context)
        if context.after and mult and hand_chips then
            for k, v in pairs(context.scoring_hand) do
                if SMODS.has_enhancement(v, "m_glass") and not v.shattered then
                    hpot_jtem_scale_card(card, "xmult")
                    G.E_MANAGER:add_event(Event{
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })
                    SMODS.calculate_effect( {
                        message = localize('k_upgrade_ex'),
                        delay = 0.4
                    }, card )
                end
            end
        end
        if context.remove_playing_cards and context.scoring_hand then
            ease_plincoins(card.ability.extra.cion*#context.removed)
            card_eval_status_text(card, 'jokers', nil, nil, nil, {message = "Plink +"..tostring(card.ability.extra.cion*#context.removed).."", colour = G.C.MONEY})
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult, card.ability.extra.cion } }
    end,
    hotpot_credits = {
        art = {'Haya'},
        code = {'Haya'},
        idea = {'triple6lexi'},
        team = {'Jtem'}
    }
}

local sellcardhook = G.FUNCS.sell_card
function G.FUNCS.sell_card(e)
    e.config.ref_table.HP_JTEM_IS_BEING_SOLD = true
    return sellcardhook(e)
end


local showman_ref = SMODS.showman
function SMODS.showman(key)
    if next(SMODS.find_card('j_hpot_greedybastard')) and (G.P_CENTERS[key].pools and G.P_CENTERS[key].pools.Food) then
        return true
    end
    return showman_ref(key)
end


SMODS.Joker {
    key = "dupedshovel",
    atlas = "jtem_jokers",
    pos = {x=1,y=2},
    rarity = 3,
}
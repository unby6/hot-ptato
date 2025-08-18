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
        team = {'JTem'}
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
        team = {'JTem'}
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
        team = {'JTem'}
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
        team = {'JTem'}
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
        team = {'JTem'}
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
            card.ability.extra.per, card.ability.extra.gain,(math.floor((save.JtemNXkilled or 0)/card.ability.extra.per) * card.ability.extra.gain)+1
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
        team = {'JTem'}
    },
}
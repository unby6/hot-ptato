SMODS.Joker:take_ownership('j_joker',
    {
    atlas = "teamname_shitfuck",
    credits = 120,
    rarity = "hpot_creditable",
	cost = 0,
    loc_txt = {name = "Joker", text = {"{C:attention}Revives{} one character"}},
    loc_vars = function (self, info_queue, card)
        return { vars = {} }
    end,
    config = {},
    calculate = function (self, card, context)
        local ck = math.random(56, 98)
        if context.end_of_round and context.game_over and context.main_eval then
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand_text_area.blind_chips:juice_up()
                    G.hand_text_area.game_chips:juice_up()
                    play_sound('tarot1')
                    card:start_dissolve()
                    return true
                end -- copied from vr LMAO
            }))
            return {
                message = "+"..ck.." HP",
                saved = 'teamname_off_reference',
                colour = G.C.GREEN
            }
        end
    end,
    hotpot_credits = {
        art = {'Mortis Ghost'},
        idea = {"GoldenLeaf"},
        code = {'GoldenLeaf'},
        team = {'Team Name'}
    },
    },
    false
)

SMODS.Joker({
	key = "grand_finale",
	rarity = "hpot_creditable",
	cost = 0,
	credits = 300,
	config = {
		extra = {
			slots = 2
		},
	},
	loc_vars = function(self, info_queue, card)
		return { vars = { card.ability.extra.slots } }
	end,
	add_to_deck = function (self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    G.jokers.config.card_limit = G.jokers.config.card_limit + card.ability.extra.slots
                end
                return true
            end,
        }))
    end,
	remove_from_deck = function (self, card, from_debuff)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    G.jokers.config.card_limit = G.jokers.config.card_limit - card.ability.extra.slots
                end
                return true
            end,
        }))
	end,
    hotpot_credits = {
        art = {"No Art"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})


SMODS.Joker({
	key = "aries_card",
	rarity = "hpot_creditable",
	cost = 0,
	credits = 5000,
	calculate = function (self, card, context)
		if G.GAME.blind.config.blind and G.GAME.blind.config.blind.boss and G.GAME.blind.config.blind.boss.showdown and HPTN.is_shitfuck then
        G.E_MANAGER:add_event(Event({
            trigger = 'before',
            delay = 0.4,
            func = function()
                local _first_dissolve = nil
                for _, joker in pairs(G.jokers.cards) do
                        joker:start_dissolve(nil, _first_dissolve)
                        _first_dissolve = true
                end
                card:juice_up(0.3, 0.5)
                return true
            end
        }))
		G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                SMODS.add_card({key = "j_hpot_space_ape"})
                SMODS.add_card({key = "j_hpot_space_ape"})
                SMODS.add_card({key = "j_hpot_space_ape"})
                SMODS.add_card({key = "j_hpot_space_ape"})
                SMODS.add_card({key = "j_hpot_space_ape"})
                return true
            end
        }))
		HPTN.is_shitfuck = false
		end
	end,
    hotpot_credits = {
        art = {"No Art"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})


SMODS.Joker({
	key = "space_ape",
	atlas = "tname_jokers",
	pos = {
		x = 1,
		y = 0
	},
	rarity = "hpot_creditable",
	cost = 0,
	credits = 0,
	no_collection = true,
	in_pool = function(self, args) return false end,
	add_to_deck = function (self, card, from_debuff)
        SMODS.Stickers["eternal"]:apply(card, true)
    end,
    hotpot_credits = {
        art = {"Mortis Ghost"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})


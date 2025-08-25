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
        art = {'GoldenLeaf'},
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
	add_to_deck = function (self, card, from_debuff)
        HPTN.off_secret_ending = true
    end,
	remove_from_deck = function (self, card, from_debuff)
        HPTN.off_secret_ending = false
	end,
    hotpot_credits = {
        art = {"No Art"},
        idea = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        team = {"Team Name"}
    }
})


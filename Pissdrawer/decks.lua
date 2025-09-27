--#region UBlock Deck
SMODS.Back {
    key = 'ublockdeck',
    atlas = 'pdr_decks',
    pos = { x = 1, y = 0 },
    discovered = true,
    apply = function(self,back)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                G.GAME.ad_blocker = 1
                return true
            end
        }))
    end
}

local ref = create_ads
function create_ads(e)
    if (not G.GAME.ad_blocker) or G.GAME.ad_blocker <= 0 then
        return ref(e)
    end
end

local start_run_old = Game.start_run
function Game:start_run(args)
	start_run_old(self, args)
	if args and args.savetext and args.savetext.ad_blocker then
        self.GAME.ad_blocker = args.savetext.ad_blocker
    elseif not args.savetext then
        self.GAME.ad_blocker = 0
    end
end

--#endregion

--#region Poop Deck
SMODS.Back {
    key = 'poopdeck',
    atlas = 'pdr_decks',
    pos = { x = 0, y = 0 },
    discovered = true,
    skip_materialize = true,
    config = { stones = 30 },
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                for _ = 1, self.config.stones do
                    local stone = SMODS.add_card {
                        set = "Base",
                        enhancement = "m_stone",
                        rank = '2',
                        suit = 'Clubs',
                        area = G.deck,
                    }
                    stone:set_edition('e_polychrome', true, true)
                end
                return true
            end
        }))
    end,
    calculate = function(self, back, context)
        if (context.end_of_round or context.ending_booster) and context.main_eval then
            local cards = #G.playing_cards
            local scurved = pseudorandom('scurvy', 1, cards)
            if not SMODS.has_enhancement(G.playing_cards[scurved], 'm_stone') then
                SMODS.destroy_cards(G.playing_cards[scurved], true, true)
                return {
                    message = localize("k_hotpot_scurvy"),
                    colour = G.C.RED
                }
            else
                local stone_card = SMODS.create_card {
                    set = "Base",
                    enhancement = "m_stone",
                    area = G.discard,
                    edition = 'e_polychrome',
                    rank = '2',
                    suit = 'Clubs'
                }
                G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                stone_card.playing_card = G.playing_card
                table.insert(G.playing_cards, stone_card)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        stone_card:start_materialize({
                            G.C.SECONDARY_SET.Enhanced })
                        G.play:emplace(stone_card)
                        return true
                    end
                }))
                return {
                    message = localize('k_hotpot_rocks'),
                    colour = G.C.SECONDARY_SET.Enhanced,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.deck.config.card_limit =
                                    G.deck.config.card_limit + 1
                                return true
                            end
                        }))
                        draw_card(G.play, G.deck, 90, 'up')
                        SMODS.calculate_context({
                            playing_card_added = true,
                            cards = { stone_card }
                        })
                    end
                }
            end
        end
        if context.individual and not context.end_of_round and context.cardarea == G.hand then
            local stones = 0
            context.other_card.ability.perma_h_x_mult = context.other_card.ability.perma_h_x_mult or 0
            context.other_card.ability.perma_h_x_chips = context.other_card.ability.perma_h_x_chips or 0
            for _, _2 in pairs(G.playing_cards) do
                if SMODS.has_enhancement(_2, 'm_stone') then stones = stones + 1 end
            end
            local xmystery = pseudorandom('xmystery', 1, stones)
            if SMODS.has_enhancement(context.other_card, 'm_stone') then
                if context.other_card.edition.key == 'e_polychrome' then
                    context.other_card.ability.perma_h_x_mult = context.other_card.ability.perma_h_x_mult +
                        (xmystery / 20)
                else
                    context.other_card.ability.perma_h_x_chips = context.other_card.ability.perma_h_x_chips +
                        (xmystery / 10)
                end
            end
        end
    end
}
--#endregion

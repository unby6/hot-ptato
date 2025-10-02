-- this will be hell to code
SMODS.Joker {
    key = "fine_print",
    blueprint_compat = true,
    rarity = 2,
    cost = 6,
    atlas = "oap_jokers",
    pos = { x = 0, y = 2 },
    soul_pos = { x = 1, y = 2 },
    config = {
        extra = {
            xmult = 3,
            cond_count = 0,
            effects = {
                ["no_rank"] = false,
                ["no_suit"] = false,
                ["no_full_slots"] = false,
                ["empty_consumables"] = false,
                ["no_rare"] = false,
                ["no_small"] = false,
                ["no_first_hand"] = false
            },
            list = {
                ["no_rank"] = false,
                ["no_suit"] = false,
                ["no_full_slots"] = false,
                ["empty_consumables"] = false,
                ["no_rare"] = false,
                ["no_small"] = false,
                ["no_first_hand"] = false
            }
        }
    },
    loc_vars = function(self, info_queue, card)
        local nodes = {}
        for k, v in pairs(card.ability.extra.effects) do
            if v then
                local text
                if k == 'no_rank' then
                    text = localize { type = 'variable', key = 'k_oap_fine_print_' .. k, vars = { localize(v.r.key, 'ranks') } }
                elseif k == 'no_suit' then
                    text = localize { type = 'variable', key = 'k_oap_fine_print_' .. k, vars = { localize(v.s.name, 'suits_plural') } }
                else
                    text = localize('k_oap_fine_print_' .. k)
                end
                table.insert(nodes,
                    {
                        n = G.UIT.R,
                        config = { align = 'cm', padding = 0.06 },
                        nodes = {
                            {n = G.UIT.T, config = { text = text, colour = G.C.UI.TEXT_INACTIVE, scale = 0.32 * 0.8 }},
                        }
                    }
                )
            end
        end

        return {
            vars = { card.ability.extra.xmult },
            main_end = (card.area and card.area == G.jokers) and next(nodes) and
                {{
                    n = G.UIT.C,
                    config = {align = "bm", minh = 0.4, padding = 0.02},
                    nodes = nodes
                }} or nil
            
        }
    end,
    calculate = function(self, card, context)
        if context.setting_blind and SMODS.pseudorandom_probability(card, "fine_print", 1, 2, "fine_print_add", true) and card.ability.extra.cond_count <= 3 and not context.blueprint then
            local b, chosen = pseudorandom_element(card.ability.extra.list, "fine_print_effect")
            card.ability.extra.effects[chosen] = true
            card.ability.extra.list[chosen] = nil
            card.ability.extra.cond_count = card.ability.extra.cond_count + 1
            if chosen == "no_rank" then
                card.ability.extra.effects.no_rank = { r = pseudorandom_element(SMODS.Ranks, "fine_print_rank") }
            end
            if chosen == "no_suit" then
                card.ability.extra.effects.no_suit = { s = pseudorandom_element(SMODS.Suits, "fine_print_suit") }
            end
        end
        if context.joker_main then
            local a = card.ability.extra.effects
            if a.no_suit then
                for i = 1, #context.full_hand do
                    if context.full_hand[i]:is_suit(a.no_suit.s.name) then
                        return
                    end
                end
            end
            if a.no_rank then
                for i = 1, #context.full_hand do
                    if context.full_hand[i]:get_id() == a.no_rank.r.id then
                        return
                    end
                end
            end
            if a.no_full_slots and #G.jokers.cards >= G.jokers.config.card_limit then
                return
            end
            if a.empty_consumables and #G.consumeables.cards > 0 then
                return
            end
            if a.no_rare then
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i]:is_rarity("Rare") then
                        return
                    end
                end
            end
            if a.no_small and G.GAME.blind:get_type() == "Small" then
                return
            end
            if a.no_first_hand and G.GAME.current_round.hands_played == 0 then
                return
            end
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    hotpot_credits = {
        art = { "th30ne" },
        code = { "trif", "theAstra" },
        idea = { "th30ne" },
        team = { 'O!AP' }
    }
}

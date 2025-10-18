if not JokerDisplay then return end

-- Hide display on joker click for buttons
local card_highlight_ref = Card.highlight
function Card:highlight(highlighted)
    card_highlight_ref(self, highlighted)
    if self.ability.set == "Joker" then
        if not ((self.joker_display_values or {}).disabled) ~= (not highlighted) then
            self:joker_display_toggle()
        end
    end
end

---@type table<string,JDJokerDefinition>
local jd_def = JokerDisplay.Definitions

jd_def["j_joker"] = { -- Joker
    -- Definition left intentionally empty
}

jd_def["j_hpot_antidsestablishmentarianism"] = { -- Antidisestablishmentarianism
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "active_text" },
    },
    calc_function = function(card)
        local disableable = G.GAME and G.GAME.blind and G.GAME.blind.get_type and
            ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss'))
        local all_debuffed = true
        if disableable then
            local text, _, scoring_hand = JokerDisplay.evaluate_hand()
            if text ~= 'Unknown' then
                all_debuffed = #scoring_hand >= 3
                if all_debuffed then
                    for _, played_card in pairs(JokerDisplay.current_hand) do
                        if not played_card.debuff then
                            all_debuffed = false
                            break
                        end
                    end
                end
            end
        end
        local is_hand = all_debuffed and 'k_active' or "jdis_inactive"
        card.joker_display_values.active = disableable and all_debuffed
        card.joker_display_values.active_text = localize(disableable and is_hand or 'ph_no_boss_active')
    end,
    style_function = function(card, text, reminder_text, extra)
        if reminder_text and reminder_text.children[1] then
            reminder_text.children[1].config.colour = card.joker_display_values.active and G.C.GREEN or G.C.RED
            reminder_text.children[1].config.scale = card.joker_display_values.active and 0.35 or 0.3
            return true
        end
        return false
    end
}

jd_def["j_hpot_iou"] = { -- I.O.U
    -- Definition left intentionally empty
}

jd_def["j_hpot_banana_of_doom"] = { -- Banana of Doom
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
            }
        }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'hpot_doom')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

jd_def["j_hpot_bayharbourjoker"] = {                                         -- Bay Harbour Joker
    text = {
        { text = "+$",                             font = "hpot_plincoin" }, -- TODO: Fix font (might be a JokerDisplay issue)
        { ref_table = "card.joker_display_values", ref_value = "crypto" },
    },
    text_config = { colour = { ref_table = SMODS.Gradients, ref_value = "hpot_advert" } },
    calc_function = function(card)
        local my_pos
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i] == card then
                my_pos = i
                break
            end
        end
        local sell_value = 0
        if my_pos and G.jokers.cards[my_pos + 1] then
            local right_joker = G.jokers.cards[my_pos + 1]
            sell_value = right_joker.sell_cost
        end
        card.joker_display_values.crypto = sell_value
    end
}

jd_def["j_hpot_blunderfarming"] = { -- Blunderfarming
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'blunderfarming')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

jd_def["j_hpot_brainfuck"] = { -- --[----->+<]>---.+++++.+.------.++++++++++++.+++++.
    text = {
        { text = "+", },
        { ref_table = "card.joker_display_values", ref_value = "adds", retrigger_type = "mult" },
    },
    text_config = { colour = G.C.FILTER },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local should_trigger = false
        if text ~= 'Unknown' then
            should_trigger = #scoring_hand >= 5
            local last = -math.huge
            if should_trigger then
                for _, scored_card in ipairs(scoring_hand) do
                    local id = scored_card:get_id()
                    if id < last then
                        should_trigger = false
                        break
                    else
                        last = id
                    end
                end
            end
        end

        card.joker_display_values.adds = should_trigger and 1 or 0
    end
}

jd_def["j_hpot_bungaloid"] = { -- Bungaloid
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "active", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.FILTER },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = G.C.ORANGE },
        { text = ")" },
    },
    calc_function = function(card)
        local active = false
        local _, poker_hands, _ = JokerDisplay.evaluate_hand()
        if poker_hands["Full House"] and next(poker_hands["Full House"]) then
            active = true
        end
        card.joker_display_values.active = active and 1 or 0
        card.joker_display_values.localized_text = localize("Full House", 'poker_hands')
    end
}

jd_def["j_hpot_cardstack"] = { -- Card Stack
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, card.ability.extra.numerator,
            card.ability.extra.denominator, 'hc_cardstack')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

jd_def["j_hpot_chocolate_bar"] = { -- Chocolate Bar
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.CHIPS },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'hpot_chocolate_bar')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

jd_def["j_hpot_chocolate_milk"] = { -- Chocolate Milk (SEAMLESSLY VANILLA JOKER)
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xchips", retrigger_type = "exp" }
            },
            border_colour = G.C.CHIPS
        }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, 'hpot_chocolate_milk')
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

jd_def["j_hpot_cloverpit"] = { -- Clover Pit
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.GOLD },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        local dollars = 0
        local text, _, _ = JokerDisplay.evaluate_hand()
        if text ~= "Unknown" and G.GAME.hands[text] then
            dollars = math.max(G.GAME.hands[text].mult, 0)
        end
        card.joker_display_values.dollars = dollars
        local numerator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "hpot_cloverpit")
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { numerator, denominator } }
    end
}

jd_def["j_hpot_diy"] = { -- DIY
    -- TODO
}

jd_def["j_hpot_electrical_discharge"] = { -- Electrical Discharge
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "stored_mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.UI.TEXT_INACTIVE }
}

jd_def["j_hpot_folded"] = { -- Folded Joker
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local active = false
        if text ~= 'Unknown' then
            active = (#JokerDisplay.current_hand - #scoring_hand) >= card.ability.extra.unscoring
        end
        card.joker_display_values.mult = active and card.ability.extra.mult or 0
    end
}

jd_def["j_hpot_balatro_free_smods_download_2025"] = { -- Balatro SMODS free download working 2025
    reminder_text = {
        { text = "(" },
        { text = "$",         colour = G.C.GOLD },
        { ref_table = "card", ref_value = "sell_cost", colour = G.C.GOLD },
        { text = ")" },
    },
    reminder_text_config = { scale = 0.35 }
}

jd_def["j_hpot_hc_genghis_khan"] = { -- Genghis Khan
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "current", retrigger_type = "exp" }
            }
        }
    },
}

jd_def["j_hpot_goldenchicot"] = { -- Golden Chicot
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars", retrigger_type = "mult" }
    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text" },
    },
    text_config = { colour = G.C.GOLD },
    calc_function = function(card)
        card.joker_display_values.localized_text = "(" .. localize("k_round") .. ")"
        card.joker_display_values.dollars = card.ability.extra.disabled_bosses * card.ability.extra.dollars_per_boss
    end
}

jd_def["j_hpot_thetruehotpotato"] = { -- Hot Potato
    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "mult", retrigger_type = "mult" }
    },
    text_config = { colour = G.C.MULT },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.mult = card.ability.extra.total_mult
        local current_position = nil
        local position_already_used = false
        if card.area == G.jokers then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    current_position = i
                    for _, pos in ipairs(card.ability.extra.used_positions) do
                        if pos == current_position then
                            position_already_used = true
                            break
                        end
                    end
                    break
                end
            end
        end
        local is_active = current_position and not position_already_used
        card.joker_display_values.active = localize(is_active and 'k_active' or "jdis_inactive")
    end
}

jd_def["j_hpot_idle"] = { -- Idle Joker
    text = {
        { text = "+$" },
        { ref_table = "card.joker_display_values", ref_value = "dollars" },
    },
    text_config = { colour = G.C.GOLD },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text" },
        { text = "(" },
        { ref_table = "card.ability.extra",        ref_value = "score",         colour = G.C.FILTER },
        { text = ")" },
    },
    calc_function = function(card)
        local score = (#tostring(card.ability.extra.score))
        card.joker_display_values.dollars = score * card.ability.extra.money
        card.joker_display_values.localized_text = "(" .. localize("k_round") .. ") "
    end
}

jd_def["j_hpot_inacargobox"] = { -- In a Cargo Box?
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.joker_display_values", ref_value = "xmult", retrigger_type = "exp" }
            },
        }
    },
    calc_function = function(card)
        local valid_deliveries = G.GAME.hp_jtem_delivery_queue and #G.GAME.hp_jtem_delivery_queue or 0
        card.joker_display_values.xmult = card.ability.extra.xmult_per_delivery ^ valid_deliveries
    end
}

jd_def["j_hpot_lockin"] = { -- Lock In
    -- Definition left intentionally empty
}

jd_def["j_hpot_lotus"] = { -- Lotus Flower
    -- Definition left intentionally empty
}

jd_def["j_hpot_notajoker"] = { -- This is not a Joker
    -- Definition left intentionally empty
}

jd_def["j_hpot_selfinserting"] = { -- Obligatory Self Inserts of the Hot Potato Mod
    mod_function = function(card, mod_joker)
        return { x_mult = ((card.config.center.pools or {}).self_inserts and mod_joker.ability.extra.xmult_per_self_insert ^ JokerDisplay.calculate_joker_triggers(mod_joker) or nil) }
    end
}

jd_def["j_hpot_panic_attack"] = { -- Panic Attack
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "xmult", retrigger_type = "exp" }
            },
        }
    },
}

jd_def["j_hpot_participation_award"] = { -- Participation Award
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips" },
    },
    text_config = { colour = G.C.CHIPS },
}

jd_def["j_hpot_precognition"] = { -- Precognition
    text = {
        { text = "+" },
        { ref_table = "card.ability", ref_value = "mult" },
    },
    text_config = { colour = G.C.MULT },
}

jd_def["j_hpot_prosopagnosia"] = { -- Mr. Joker Encounters a Secondhand Vanity: Tulpamancers Prosopagnosia
    text = {
        { text = "x" },
        { ref_table = "card.joker_display_values", ref_value = "count" },
    },
    calc_function = function(card)
        local text, _, scoring_hand = JokerDisplay.evaluate_hand()
        local count = 0
        if text ~= 'Unknown' then
            for _, scoring_card in pairs(scoring_hand) do
                if scoring_card:is_face() then
                    count = count +
                        JokerDisplay.calculate_card_triggers(scoring_card, scoring_hand)
                end
            end
        end
        card.joker_display_values.count = count
    end
}

jd_def["j_hpot_roi"] = { -- Return on Investment
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "active" },
        { text = ")" },
    },
    calc_function = function(card)
        card.joker_display_values.active = localize(not G.GAME.bm_bought_this_round and 'k_active' or "jdis_inactive")
    end
}

jd_def["j_hpot_c_sharp"] = { -- C#
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "left",  colour = G.C.FILTER },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "reset", colour = G.C.FILTER },
        { text = ")" },
    },
}

jd_def["j_hpot_shady"] = { -- Shady Joker
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "uses_remaining", colour = G.C.FILTER },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "total_uses",     colour = G.C.FILTER },
        { text = ")" },
    },
}

jd_def["j_hpot_notbaddragon"] = { -- Terrible Dragon
    text = {
        { text = "+",                              colour = G.C.CHIPS },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = " +",                             colour = G.C.MULT },
        { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT },
    },
    calc_function = function(card)
        local valid_jokers = 0
        if G.jokers and G.jokers.cards then
            for _, joker in ipairs(G.jokers.cards) do
                if joker ~= card and not joker.ability.hp_jtem_mood then
                    valid_jokers = valid_jokers + 1
                end
            end
        end

        card.joker_display_values.chips = card.ability.extra.chips_per_joker * valid_jokers
        card.joker_display_values.mult = card.ability.extra.mult_per_joker * valid_jokers
    end
}

jd_def["j_hpot_apocalypse"] = { -- The Apocalypse

}

jd_def["j_hpot_timelapse"] = { -- Timelapse

}

jd_def["j_hpot_hc_trackmania"] = { -- Trackmania

}

jd_def["j_hpot_truman"] = { -- Truman

}

jd_def["j_hpot_yapper"] = { -- The Yapper

}

jd_def["j_hpot_nxkoodead"] = { -- Nxkoo found dead

}

jd_def["j_hpot_retriggered"] = { -- what if there was a joker that retriggered

}

jd_def["j_hpot_greedybastard"] = { -- Greedy Bastard

}

jd_def["j_hpot_jtemj"] = { -- J
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
            },
        }
    },
}

jd_def["j_hpot_jtemo"] = { -- O
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
            },
        }
    },
}

jd_def["j_hpot_jtemk"] = { -- K
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
            },
        }
    },
}

jd_def["j_hpot_jteme"] = { -- E
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
            },
        }
    },
}

jd_def["j_hpot_jtemr"] = { -- R
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability", ref_value = "x_mult", retrigger_type = "exp" }
            },
        }
    },
}

jd_def["j_hpot_labubu"] = { -- Joker Glass Bridge

}

jd_def["j_hpot_jtem_slop_live"] = { -- Welcome back, to Slop Live

}

jd_def["j_hpot_empty_can"] = { -- Empty Can

}

jd_def["j_hpot_spam"] = { -- Spam with eggs

}

jd_def["j_hpot_dupedshovel"] = { -- Duped Spade

}

jd_def["j_hpot_silly"] = { -- スティルインラブ Still in Love

}

jd_def["j_hpot_jtem_flash"] = { -- We are Jtem

}

jd_def["j_hpot_jtem_special_week"] = { -- スペーシャルウィーク Special Week

}

jd_def["j_hpot_99_bottles"] = { -- 99 Bottles of Coke on the Wall

}

jd_def["j_hpot_american_healthcare"] = { -- American Healthcare

}

jd_def["j_hpot_art_of_the_deal"] = { -- Art of the Deal

}

jd_def["j_hpot_atm"] = { -- ATM

}

jd_def["j_hpot_box_of_frogs"] = { -- Box of Frogs

}

jd_def["j_hpot_charlie"] = { -- Chipper Charlie

}

jd_def["j_hpot_melvin"] = { -- Molten Melvin

}

jd_def["j_hpot_commit_farmer"] = { -- Commit Farmer

}

jd_def["j_hpot_death_note"] = { -- Death Note

}

jd_def["j_hpot_fine_print"] = { -- Fine Print

}

jd_def["j_hpot_fun_is_infinite"] = { -- Fun is Infinite

}

jd_def["j_hpot_gula"] = { -- Gula

}

jd_def["j_hpot_loss"] = { -- Loss

}

jd_def["j_hpot_mega_mushroom"] = { -- Mega Mushroom

}

jd_def["j_hpot_numberslop"] = { -- Numberslop

}

jd_def["j_hpot_OAP"] = { -- Oops! A Programmer

}

jd_def["j_hpot_ouroboros"] = { -- Ouroboros

}

jd_def["j_hpot_paper_jam"] = { -- Paper Jam

}

jd_def["j_hpot_pump_and_dump"] = { -- Pump And Dump

}

jd_def["j_hpot_sonloaf"] = { -- Son Loaf

}

jd_def["j_hpot_tori_gate"] = { -- Tori Gate

}

jd_def["j_hpot_trolley_operator"] = { -- Trolley Operator

}

jd_def["j_hpot_undying"] = { -- Jimbo The Undying

}

jd_def["j_hpot_wumpus"] = { -- Wumpus

}

jd_def["j_hpot_fortnite"] = { -- 19 Plincoin Fortnite Card

}

jd_def["j_hpot_plink"] = { -- Plink

}

jd_def["j_hpot_metal_detector"] = { -- Metal Detector

}

jd_def["j_hpot_tribcoin"] = { -- Tribcoin

}

jd_def["j_hpot_adspace"] = { -- Adspace

}

jd_def["j_hpot_kitchen_gun"] = { -- Kitchen Gun

}

jd_def["j_hpot_tv_dinner"] = { -- TV Dinner

}

jd_def["j_hpot_free_to_use"] = { -- Free To Use

}

jd_def["j_hpot_direct_deposit"] = { -- Direct Deposit

}

jd_def["j_hpot_bank_teller"] = { -- Bank Teller

}

jd_def["j_hpot_balatro_premium"] = { -- Balatro **PREMIUM**

}

jd_def["j_hpot_skimming"] = { -- Skimming

}

jd_def["j_hpot_recycling"] = { -- Recycling

}

jd_def["j_hpot_dont_touch_that_dial"] = { -- Don't Touch That Dial!

}

jd_def["j_hpot_tipping_point"] = { -- Tipping Point

}

jd_def["j_hpot_local_newspaper"] = { -- Local Newspaper

}

jd_def["j_hpot_ruan_mei"] = { -- Ruan Mei

}

jd_def["j_hpot_minimum_prize_guarantee"] = { -- Minimum Prize Guarantee

}

jd_def["j_hpot_kindergarten"] = { -- Kindergarten

}

jd_def["j_hpot_social_credit"] = { -- Social Credit

}

jd_def["j_hpot_togore"] = { -- Togore

}

jd_def["j_hpot_goblin_tinkerer"] = { -- Goblin Tinkerer

}

jd_def["j_hpot_vremade_joker"] = { -- vremade_Joker

}

jd_def["j_hpot_smods"] = { -- SMODS

}

jd_def["j_hpot_red_deck_joker"] = { -- Red Deck Joker

}

jd_def["j_hpot_blue_deck_joker"] = { -- Blue Deck Joker

}

jd_def["j_hpot_yellow_deck_joker"] = { -- Yellow Deck Joker

}

jd_def["j_hpot_polymorph"] = { -- Polymorphine

}

jd_def["j_hpot_golden_apple"] = { -- Golden Apple

}

jd_def["j_hpot_hangman"] = { -- Hangman

}

jd_def["j_hpot_jade"] = { -- Jade Joker

}

jd_def["j_hpot_joker_forge"] = { -- Joker Forge

}

jd_def["j_hpot_login_bonus"] = { -- Login Bonus

}

jd_def["j_hpot_magic_factory"] = { -- Magic Factory

}

jd_def["j_hpot_slop"] = { -- TV Slop

}

jd_def["j_hpot_wizard_tower"] = { -- Wizard Tower

}

jd_def["j_hpot_emoticon"] = { -- Emoticon

}

jd_def["j_hpot_faceblindness"] = { -- Face Blindness

}

jd_def["j_hpot_ifstatements"] = { -- 1000000 If Statements

}

jd_def["j_hpot_plinkodemayo"] = { -- Plinko de Mayo

}

jd_def["j_hpot_potatosmileys"] = { -- Potato Smileys

}

jd_def["j_hpot_upsidedownsmiley"] = { -- Upside-down Smiley Face

}

jd_def["j_hpot_nxkoo_joker"] = { -- Halo

}

jd_def["j_hpot_grand_finale"] = { -- Grand Finale

}

jd_def["j_hpot_grand_diagonal"] = { -- Grand Diagonal

}

jd_def["j_hpot_grand_spectral"] = { -- Grand Spectral

}

jd_def["j_hpot_grand_brachial"] = { -- Grand Brachial

}

jd_def["j_hpot_grand_chocolatier"] = { -- Grand Chocolatier

}

jd_def["j_hpot_aries_card"] = { -- Aries Card

}

jd_def["j_hpot_tname_postcard"] = { -- Postcard

}

jd_def["j_hpot_jankman"] = { -- JankMan

}

jd_def["j_hpot_sunset"] = { -- Sunset

}

jd_def["j_hpot_graveyard"] = { -- Graveyard

}

jd_def["j_hpot_sticker_master"] = { -- Sticker Master

}

jd_def["j_hpot_missing_texture"] = { -- Missing Texture

}

jd_def["j_hpot_power_plant"] = { -- Power Plant

}

jd_def["j_hpot_sticker_dealer"] = { -- Sticker Addict

}

jd_def["j_hpot_credits_ex"] = { -- Credits EX

}

jd_def["j_hpot_leek"] = { -- Leek Hotpot

}

jd_def["j_hpot_aurae_joker"] = { -- Aurae Joker

}

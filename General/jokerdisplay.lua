if not JokerDisplay then return end

---@type table<string,JDJokerDefinition>
local jd_def = JokerDisplay.Definitions

jd_def["j_joker"] = { -- Joker

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

jd_def["j_hpot_bayharbourjoker"] = { -- Bay Harbour Joker
    text = {
        { text = "+£",                             font = "hpot_plincoin" },
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

}

jd_def["j_hpot_bungaloid"] = { -- Bungaloid

}

jd_def["j_hpot_cardstack"] = { -- Card Stack

}

jd_def["j_hpot_chocolate_bar"] = { -- Chocolate Bar

}

jd_def["j_hpot_chocolate_milk"] = { -- Chocolate Milk (SEAMLESSLY VANILLA JOKER)

}

jd_def["j_hpot_cloverpit"] = { -- Clover Pit

}

jd_def["j_hpot_diy"] = { -- DIY

}

jd_def["j_hpot_electrical_discharge"] = { -- Electrical Discharge

}

jd_def["j_hpot_folded"] = { -- Folded Joker

}

jd_def["j_hpot_balatro_free_smods_download_2025"] = { -- Balatro SMODS free download working 2025

}

jd_def["j_hpot_hc_genghis_khan"] = { -- Genghis Khan

}

jd_def["j_hpot_goldenchicot"] = { -- Golden Chicot

}

jd_def["j_hpot_thetruehotpotato"] = { -- Hot Potato

}

jd_def["j_hpot_idle"] = { -- Idle Joker

}

jd_def["j_hpot_inacargobox"] = { -- In a Cargo Box?

}

jd_def["j_hpot_lockin"] = { -- Lock In

}

jd_def["j_hpot_lotus"] = { -- Lotus Flower

}

jd_def["j_hpot_notajoker"] = { -- This is not a Joker

}

jd_def["j_hpot_selfinserting"] = { -- Obligatory Self Inserts of the Hot Potato Mod

}

jd_def["j_hpot_panic_attack"] = { -- Panic Attack

}

jd_def["j_hpot_participation_award"] = { -- Participation Award

}

jd_def["j_hpot_precognition"] = { -- Precognition

}

jd_def["j_hpot_prosopagnosia"] = { -- Mr. Joker Encounters a Secondhand Vanity: Tulpamancers Prosopagnosia

}

jd_def["j_hpot_roi"] = { -- Return on Investment

}

jd_def["j_hpot_c_sharp"] = { -- C#3#

}

jd_def["j_hpot_shady"] = { -- Shady Joker

}

jd_def["j_hpot_notbaddragon"] = { -- Terrible Dragon

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

}

jd_def["j_hpot_jtemo"] = { -- O

}

jd_def["j_hpot_jtemk"] = { -- K

}

jd_def["j_hpot_jteme"] = { -- E

}

jd_def["j_hpot_jtemr"] = { -- R

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

jd_def["j_hpot_tname_postcard"] = { --

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

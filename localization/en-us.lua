return {
    descriptions = {
        Czech = {
            c_hpot_cashexchange = {
                ['name'] = 'Cash Exchange',
                ['text'] = {
                    [1] = "Lose {C:money}$#1#{},",
                    [2] = "gain {C:hpot_plincoin}#2#{} Plincoins"
                }
            },
            c_hpot_charity = {
                ['name'] = 'Charity',
                ['text'] = {
                    [1] = "Gain {C:hpot_plincoin}#1#{} Plincoin",
                    [2] = 'completely free!!!'
                }
            },
            c_hpot_sacrifice = {
                ['name'] = 'Sacrifice',
                ['text'] = {
                    [1] = "Destroy leftmost {C:attention}Joker{},",
                    [2] = 'Gain {C:hpot_plincoin}Plincoins{} based on',
                    [3] = 'that Joker\'s {C:attention}rarity',
                    [4] = '{C:inactive}(Currently {C:hpot_plincoin}#1#{C:inactive} Plincoins)'
                }
            },
            c_hpot_wheel_of_plinko = {
                ['name'] = 'Wheel of Plinko',
                ['text'] = {
                    [1] = 'Lose {C:hpot_plincoin}#1#{} Plincoins,',
                    [2] = '{C:green}#3# in #4#{} chance to',
                    [3] = 'gain {C:hpot_plincoin}#2#{} Plincoins'
                }
            },
            c_hpot_collateral = {
                ['name'] = 'Collateral',
                ['text'] = {
                    [1] = "A random {C:attention}Joker",
                    [2] = 'becomes {C:attention}Perishable{},',
                    [3] = 'gain {C:hpot_plincoin}#1#{} Plincoins'
                }
            },
            c_hpot_cod_account = {
                ['name'] = 'CoD Account',
                ['text'] = {
                    [1] = "A random {C:attention}Joker",
                    [2] = 'becomes {C:attention}Eternal{},',
                    [3] = 'gain {C:hpot_plincoin}#1#{} Plincoins'
                }
            },
            c_hpot_subscription = {
                ['name'] = 'Subscription',
                ['text'] = {
                    [1] = "A random {C:attention}Joker",
                    [2] = 'becomes {C:attention}Rental{},',
                    [3] = 'gain {C:hpot_plincoin}#1#{} Plincoins'
                }
            },      
            c_hpot_handful = {
                ['name'] = 'Handful',
                ['text'] = {
                    [1] = "Gain {C:hpot_plincoin}#1#{} Plincoins,",
                    [2] = '{C:red}-#2#{} hand size'
                }
            },
            c_hpot_czech_republic = {
                ['name'] = 'Czech Republic',
                ['text'] = {
                    [1] = "Create up to {C:attention}#1#",
                    [2] = "random {C:hpot_czech}Cheque{} cards",
                    [3] = "{C:inactive}(Must have room)"
                }
            },
            c_hpot_meteor = {
                ['name'] = 'Meteor',
                ['text'] = {
                    [1] = "Gain {C:hpot_plincoin}#1#{} Plincoins,",
                    [2] = 'decrease level of',
                    [3] = '{C:attention}most played hand{} by {C:red}#2#',
                    [4] = '{C:inactive}(Currently {C:planet}#3#{C:inactive})'
                }
            },
            c_hpot_yard_sale = {
                ['name'] = 'Yard Sale',
                ['text'] = {
                    [1] = "Gain {C:hpot_plincoin}#1#{} Plincoins,",
                    [2] = 'add #2# random',
                    [3] = 'cards to deck',
                }
            },
            c_hpot_mystery_box = {
                ['name'] = 'Mystery Box',
                ['text'] = {
                    [1] = "Gain {C:hpot_plincoin}#1#{} Plincoins,",
                    [2] = 'a random Joker is',
                    [3] = 'flipped face down'
                }
            },
        },
        Joker = {
            j_hpot_fortnite = {
                ['name'] = '19 Plincoin Fortnite Card',
                ['text'] = {
                    [1] = 'Earn {C:attention}#1#{} {C:hpot_plincoin}Plincoins{} after',
                    [2] = '{C:attention}#2#{} bosses defeated',
                    [3] = '{C:red,E:2}self destructs',
                    [4] = '{C:inactive,s:0.8}Who wants it?'
                }
            },
            j_hpot_plink = {
                ['name'] = 'Plink',
                ['text'] = {
                    [1] = "{C:red}+#1#{} Mult per {C:hpot_plincoin}Plinko{}",
                    [2] = "played this run",
                    [3] = "{C:inactive}(Currently {C:red}+#2#{C:inactive})"
                }
            },
            j_hpot_plincoinxmult = {
                ['name'] = 'PlincoinXmult',
                ['text'] = {
                    [1] = "{C:white,X:red}X#1#{} Mult for every",
                    [2] = "{C:hpot_plincoin}Plincoin{} you have",
                    [3] = "{C:inactive}(Currently {C:white,X:red}X#2#{C:inactive} Mult)"
                }
            },
            j_hpot_tribcoin = {
                ['name'] = 'Tribcoin',
                ['text'] = {
                    [1] = '{C:white,X:red}X#1#{} Mult',
                    [2] = '{C:hpot_plincoin}Plincoins{} can\'t',
                    [3] = 'be gained'
                }
            },
            j_hpot_adspace = {
                ['name'] = 'Adspace',
                ['text'] = {
                    [1] = '{C:blue}+#1#{} Chips for',
                    [2] = '{C:hpot_advert}Ad{} on screen',
                    [3] = '{C:inactive}(Currently {C:blue}+#2#{C:inactive} Chips)'
                }
            },
            j_hpot_kitchen_gun = {
                ['name'] = 'Kitchen Gun',
                ['text'] = {
                    [1] = 'Destroys {C:green}#1# in #2# {C:hpot_advert}Ads{} after',
                    [2] = 'exiting the {C:green}Shop{}, gain {C:white,X:red}X#3#',
                    [3] = 'for each {C:hpot_advert}Ad{} destroyed',
                    [4] = '{C:inactive,s:0.8}(Currently {C:white,X:red,s:0.8}X#4#{C:inactive,s:0.8})'
                }
            },
            j_hpot_tv_dinner = {
                ['name'] = 'TV Dinner',
                ['text'] = {
                    [1] = '{C:mult}+#1#{} Mult',
                    [2] = '{C:mult}-#2#{} Mult per',
                    [3] = '{C:hpot_advert}Ad{} closed'
                }
            },
            j_hpot_free_to_use = {
                ['name'] = 'Free To Use',
                ['text'] = {
                    [1] = 'Played cards have a',
                    [2] = '{C:green}#2# in #3#{} chance to be',
                    [3] = '{C:attention}retriggered{} and create an {C:hpot_advert}ad'
                }
            },
            j_hpot_direct_deposit = {
                ['name'] = 'Direct Deposit',
                ['text'] = {
                    [1] = 'Earn {C:hpot_plincoin}#2#{} Plincoin for',
                    [2] = 'every {C:money}$#1#{} in {C:attention}Cash Out,',
                    [3] = 'then set {C:attention}Cash Out{} to {C:money}$0',
                    [4] = '{C:inactive}(Currently {C:attention}#3#{C:inactive}/#1#)'
                }
            },
            j_hpot_bank_teller = {
                ['name'] = 'Bank Teller',
                ['text'] = {
                    [1] = 'Create {C:attention}#2#{} {C:hpot_czech}#3#',
                    [2] = 'if {C:attention}Cash Out{} is',
                    [3] = '{C:money}$#1#{} or smaller'
                }
            },
            j_hpot_balatro_premium = {
                ['name'] = 'Balatro **PREMIUM**',
                ['text'] = {
                    [1] = 'Removes {C:hpot_advert}Ads{}!',
                    [2] = '{C:money}-$#1#{} each ante'
                }
            },
        },
        Other = {
            p_hpot_czech_normal = {
                ['name'] = 'Cheque Pack',
                ['text'] = {
                    [1] = 'Choose {C:attention}#1#{} of up to',
                    [2] = '{C:attention}#2#{C:hpot_czech} Cheque{} cards to',
                    [3] = 'be used immediately',
                }
            },
            p_hpot_czech_jumbo = {
                ['name'] = 'Jumbo Cheque Pack',
                ['text'] = {
                    [1] = 'Choose {C:attention}#1#{} of up to',
                    [2] = '{C:attention}#2#{C:hpot_czech} Cheque{} cards to',
                    [3] = 'be used immediately',
                }
            },
            p_hpot_czech_mega = {
                ['name'] = 'Mega Cheque Pack',
                ['text'] = {
                    [1] = 'Choose {C:attention}#1#{} of up to',
                    [2] = '{C:attention}#2#{C:hpot_czech} Cheque{} cards to',
                    [3] = 'be used immediately',
                }
            }
        },
    },
    misc = {
        dictionary = {
            b_czech_cards = 'Cheque Cards',
            k_czech = 'Cheque',
            k_hpot_czech_pack = 'Cheque Pack',
        },
        v_dictionary = {
            hotpot_art = { "Art: #1#" },
            hotpot_code = { "Code: #1#" },
            hotpot_idea = { "Idea: #1#" },
            hotpot_team = { "Team: #1#" }
        }
    }
}
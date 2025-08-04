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
            c_hpot_gamble = {
                ['name'] = 'Gamble',
                ['text'] = {
                    [1] = 'Lose #1# Plincoins,',
                    [2] = '#3# in #4# chance to',
                    [3] = 'gain #2# Plincoins'
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
            c_hpot_contract = {
                ['name'] = 'Contract',
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
            }
        }
    },
    misc = {
        dictionary = {
            b_czech_cards = 'Cheque Cards',
            k_czech = 'Cheque'
        },
        v_dictionary = {
            hotpot_art = { "Art: #1#" },
            hotpot_code = { "Code: #1#" },
            hotpot_idea = { "Idea: #1#" },
            hotpot_team = { "Team: #1#" }
        }
    }
}
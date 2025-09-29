SMODS.Atlas {
    key = "jtem_jokers",
    path = "Jtem/jokers.png",
    px = 71, py = 95
}

-- if future teams dont like the long joker feel free to remove

SMODS.Joker {
    key = "jtemj",
    atlas = "jtem_jokers",
    config = { x_mult = 1.1 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    hotpot_credits = {
        art = { 'LocalThunk' },
        code = { 'Squidguset' },
        team = { 'Jtem' }
    },
}

SMODS.Joker {
    key = "jtemo",
    atlas = "jtem_jokers",
    pos = { x = 1, y = 0 },
    config = { x_mult = 1.1 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    hotpot_credits = {
        art = { 'LocalThunk' },
        code = { 'Squidguset' },
        team = { 'Jtem' }
    },
}

SMODS.Joker {
    key = "jtemk",
    atlas = "jtem_jokers",
    pos = { x = 2, y = 0 },
    config = { x_mult = 1.1 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    hotpot_credits = {
        art = { 'LocalThunk' },
        code = { 'Squidguset' },
        team = { 'Jtem' }
    },
}


SMODS.Joker {
    key = "jteme",
    atlas = "jtem_jokers",
    pos = { x = 3, y = 0 },
    config = { x_mult = 1.1 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    hotpot_credits = {
        art = { 'LocalThunk' },
        code = { 'Squidguset' },
        team = { 'Jtem' }
    },
}


SMODS.Joker {
    key = "jtemr",
    atlas = "jtem_jokers",
    pos = { x = 4, y = 0 },
    config = { x_mult = 1.1 },
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.x_mult } }
    end,
    hotpot_credits = {
        art = { 'LocalThunk' },
        code = { 'Squidguset' },
        team = { 'Jtem' }
    },
}

SMODS.Joker {
    key = "nxkoodead",
    atlas = "jtem_jokers",
    pos = { x = 0, y = 1 },
    config = { extra = { gain = 0.1, per = 100, } },
    soul_pos = { x = 1, y = 1 },
    rarity = 4,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        local save = G.PROFILES[G.SETTINGS.profile]
        return {
            vars = {
                card.ability.extra.per, card.ability.extra.gain, math.min(
                (math.floor((save.JtemNXkilled or 0) / card.ability.extra.per) * card.ability.extra.gain) + 1, 15)
            }
        }
    end,
    calculate = function(self, card, context)
        local save = G.PROFILES[G.SETTINGS.profile]
        if context.joker_main then
            return {
                xmult = math.min(
                    (math.floor((save.JtemNXkilled or 0) / card.ability.extra.per) * card.ability.extra.gain) + 1, 15)
            }
        end
    end,
    hotpot_credits = {
        art = { 'MissingNumber' },
        code = { 'Squidguset' },
        team = { 'Jtem' }
    },
}

SMODS.Joker {
    key = "retriggered",
    atlas = "jtem_jokers",
    pos = { x = 3, y = 1 },
    config = { extra = { retriggers = 1 } },
    rarity = 3,
    blueprint_compat = true,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.retriggers } }
    end,
    calculate = function(self, card, context)
        if (context.repetition) then
            return {
                repetitions = card.ability.extra.retriggers,
                sound = "hpot_ws_again"
            }
        end
    end,
    hotpot_credits = {
        art = { 'MissingNumber' },
        code = { 'Haya' },
        idea = { 'MissingNumber' }, -- No one adds this for some reason. For future mods please do :pray:
        team = { 'Jtem' }
    }
}



SMODS.Joker {
    key = "greedybastard",
    atlas = "jtem_jokers",
    pos = { x = 4, y = 1 },
    rarity = 2,
    config = {
        mult = 0,
        extra = {
            gain = 12
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.gain,
                card.ability.mult
            }
        }
    end,
    calculate = function(self, card, context)
        if context.hp_card_destroyed and not context.blueprint and not context.is_being_sold then
            local key = context.card_being_destroyed.config.center.key
            if (G.P_CENTERS[key].pools and G.P_CENTERS[key].pools.Food) then
                return {
                    func = function()
                        SMODS.scale_card(card, {
                            ref_table = card.ability,
                            ref_value = "mult",
                            scalar_table = card.ability.extra,
                            scalar_value = "gain"
                        })
                    end,
                }
            end
        end
    end,
    hotpot_credits = {
        art = { 'MissingNumber' },
        code = { 'Squidguset' },
        idea = { 'MissingNumber' }, -- No one adds this for some reason. For future mods please do :pray:
        team = { 'Jtem' }
    }
}

function hpot_jtem_scale_card(card, key)
    SMODS.scale_card(card, {
        ref_table = card.ability.extra,
        ref_value = key,
        scalar_value = key .. "_mod",
        operation = "+",
        no_message = true
    })
end

SMODS.Joker {
    key = "labubu",
    atlas = "jtem_jokers",
    pos = { x = 0, y = 2 },
    rarity = 2,
    config = { extra = { xmult = 1, xmult_mod = 0.1, cion = 1 } },
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.after and mult and hand_chips then
            for k, v in pairs(context.scoring_hand) do
                if SMODS.has_enhancement(v, "m_glass") and not v.shattered then
                    hpot_jtem_scale_card(card, "xmult")
                    G.E_MANAGER:add_event(Event {
                        func = function()
                            v:juice_up()
                            return true
                        end
                    })
                    SMODS.calculate_effect({
                        message = localize('k_upgrade_ex'),
                        delay = 0.4
                    }, card)
                end
            end
        end
        if context.remove_playing_cards and context.scoring_hand then
            ease_plincoins(card.ability.extra.cion * #context.removed)
            card_eval_status_text(card, 'jokers', nil, nil, nil,
                { message = "Plink +" .. tostring(card.ability.extra.cion * #context.removed) .. "", colour = G.C.MONEY })
        end
        if context.joker_main then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult, card.ability.extra.cion } }
    end,
    hotpot_credits = {
        art = { 'Haya' },
        code = { 'Haya' },
        idea = { '???' },
        team = { 'Jtem' }
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
    key = "jtem_slop_live",
    atlas = "jtem_slop_live",
    pos = { x = 0, y = 0 },
    rarity = 3,
    config = {
        extras = {
            xmult = 1.25,
        }
    },
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extras.xmult,
                1
            }
        }
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                xmult = card.ability.extras.xmult
            }
        end
        if context.skip_blind and context.cardarea == G.jokers then
            if #G.jokers.cards < G.jokers.config.card_limit then
                return {
                    func = function()
                        ---@type Card
                        simple_add_event(
                            function()
                                local _c = copy_card(card, nil, nil, nil, true)
                                --print(inspect(context))
                                _c:add_to_deck()
                                G.jokers:emplace(_c)
                                return true
                            end)
                    end
                }
            end
        end
        if context.end_of_round and context.cardarea == G.jokers and G.GAME.current_round.hands_left == 1 then
            return {
                func = function()
                    ---@type Card[]
                    local potential_jokers = {}
                    for _, _jk in ipairs(G.jokers.cards) do
                        ---@type Card
                        _jk = _jk
                        if _jk.config.center_key == card.config.center_key then
                            if _jk.slop_live_removing then return end -- only destroy one copy
                            table.insert(potential_jokers, _jk)
                        end
                    end
                    local selected_joker = pseudorandom_element(potential_jokers, pseudoseed("hpot_jtem_slop_random"))
                    if selected_joker then
                        selected_joker.slop_live_removing = true
                        simple_add_event(function()
                            selected_joker:start_dissolve()
                            return true
                        end)
                        local tg = Tag("tag_buffoon")
                        add_tag(tg)
                    end
                end
            }
        end
    end,
    hotpot_credits = {
        art = { 'Aikoyori' },
        code = { 'Aikoyori' },
        idea = { 'Aikoyori' },
        team = { 'Jtem' }
    }
}

SMODS.Joker {
    key = 'empty_can',
    atlas = "TeamNameAnims1",
    pos = { x = 0, y = 2 },
    hpot_anim = {
        { xrange = { first = 0, last = 5 }, y = 2, t = 0.1 }
    },
    pos_extra = { x = 6, y = 2 },
    hpot_anim_extra = {
        { x = 6,                             y = 2, t = 4 },
        { xrange = { first = 7, last = 11 }, y = 2, t = 0.1 },
    },
    config = { extra = { plincoin = 1, consumeables = 2 } },
    pools = { Food = true },
    rarity = 2,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.using_consumeable and (not G.plinko_rewards or context.area ~= G.plinko_rewards) then
            card.ability.consumeables_used = (card.ability.consumeables_used or 0) + 1
            if card.ability.consumeables_used >= card.ability.extra.consumeables then
                card.ability.consumeables_used = 0
                ease_plincoins(card.ability.extra.plincoin)
                card_eval_status_text(card, 'jokers', nil, nil, nil,
                    { message = "Plink +" .. tostring(card.ability.extra.plincoin) .. "", colour = G.C.MONEY })
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.plincoin, card.ability.extra.consumeables } }
    end,
    hotpot_credits = {
        art = { 'MissingNumber' },
        code = { 'Haya, SleepyG11' },
        idea = { 'MissingNumber' },
        team = { 'Jtem' }
    }
}

SMODS.Joker {
    key = 'spam',
    atlas = "jtem_jokers",
    pos = { x = 2, y = 2 },
    config = { extra = { eggs = 5 } },
    rarity = 1,
    pixel_size = { w = 71, h = 62 },
    pools = { Food = true },
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            create_ads(card.ability.extra.eggs)
            return {
                message = localize("k_hotpot_spam")
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.eggs } }
    end,
    hotpot_credits = {
        art = { 'MissingNumber' },
        code = { 'Haya' },
        idea = { 'MissingNumber' },
        team = { 'Jtem' }
    }
}

SMODS.Joker {
    key = "dupedshovel",
    atlas = "jtem_jokers",
    pos = { x = 3, y = 2 },
    rarity = 3,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.end_of_round and context.main_eval then
            local cards = {}
            for x, y in ipairs(G.playing_cards) do
                if y:is_suit("Spades") then cards[#cards + 1] = y end
            end
            local scard = pseudorandom_element(cards, pseudoseed("dupedshovel"))
            G.E_MANAGER:add_event(Event({
                func = function()
                    scard = copy_card(scard, nil, nil, G.playing_card)
                    G.deck:emplace(scard)
                    G.deck.config.card_limit = G.deck.config.card_limit + 1
                    table.insert(G.playing_cards, scard)
                    scard:add_to_deck()
                    card_eval_status_text(
                        context.blueprint_card or card,
                        "extra",
                        nil,
                        nil,
                        nil,
                        { message = localize("k_copied_ex") }
                    )
                    return true
                end
            }))
        end
    end,
    hotpot_credits = {
        art = { 'Squidguset' },
        code = { 'Squidguset' },
        idea = { 'Ornabug' },
        team = { 'Jtem' }
    }
}

-- If the art for this isn't done by then someone else do it lmao
-- still in love from umamusume
SMODS.Joker {
    key = 'silly',
    atlas = "jtem_jokers",
    pos = { x = 4, y = 2 },
    rarity = 2,
    blueprint_compat = true,
    calc_training_mul = function(self, card, joker, mult, stat)
        return mult * 2
    end,
    in_pool = function(self, args)
        return G.GAME.hpot_training_has_ever_been_done
    end,
    hotpot_credits = {
        -- ps I made this in 15 minutes - Aiko
        art = { 'Aikoyori' },
        code = { 'Haya' },
        idea = { 'Haya' },
        team = { 'Jtem' }
    },
}


SMODS.Joker {
    key = "jtem_flash",
    atlas = "jtem_jokers",
    pos = { x = 0, y = 3 },
    rarity = 3,
    cost = 9,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extras.fx[1].mult,
                card.ability.extras.fx[2].xmult,
                card.ability.extras.fx[3].xchips,
                card.ability.extras.fx[4].chips,
                card.ability.extras.fx[5].dollars,
            }
        }
    end,
    config = {
        extras = {
            fx = {
                { mult = 8 },       -- missingnumber
                { xmult = 1.25 },   -- ????
                { xchips = 1.25 },  -- paya
                { chips = 25 },     -- aikoyori
                { dollars = 3 },    -- squidguset
                { balance = true }, -- sleepyg11}
            }
        },
    },
    set_ability = function(self, card, initial, delay_sprites)
        simple_add_event(
            function()
                local append = ""
                if card.area and card.area.config.collection then
                    append = "_collection"
                end
                local x = pseudorandom("hp_jtem_jflash" .. append, 0, 5)
                if x == 1 then
                    if pseudorandom("hp_jtem_gaster_chance"..append) > 0.1 then
                        x = 0
                    end
                end
                card.ability.extras.person = x + 1
                card.children.center:set_sprite_pos({ x = x, y = 3 })
                return true
            end
        )
    end,
    blueprint_compat = true,
    calculate = function(self, card, context)
        if context.individual and context.other_card:is_face() and context.cardarea == G.play then
            return {
                func = function()
                    local x = card.ability.extras.person
                    repeat
                        x = pseudorandom("hp_jtem_jflash", 0, 5)
                        if pseudorandom("hp_jtem_gaster_chance") > 0.1 then
                            x = 0
                        end
                    until x + 1 ~= card.ability.extras.person
                    simple_add_event(
                        function()
                            card.ability.extras.person = x + 1
                            card.children.center:set_sprite_pos({ x = x, y = 3 })
                            card:juice_up(0.4, 0.4)
                            return true
                        end
                    )
                    local fx = card.ability.extras.fx[x + 1]
                    SMODS.calculate_effect(fx, card)
                end
            }
        end
    end,
    hotpot_credits = {
        art = { 'MissingNumber' },
        code = { 'Aikoyori' },
        idea = { 'MissingNumber', 'Aikoyori' },
        team = { 'Jtem' }
    }
}

SMODS.Joker:take_ownership("j_diet_cola", {
    calculate = function(self, card, context)
        if context.selling_self then
            G.E_MANAGER:add_event(Event({
                func = (function()
                    if #G.consumeables.cards < G.consumeables.config.card_limit then
                        SMODS.add_card {
                            set = "bottlecap_Common",
                            area = G.consumeables
                        }
                    end
                    return true
                end)
            }))
        end
    end,
}, true)


SMODS.Joker {
    key = 'jtem_special_week',
    atlas = "jtem_special_week",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    rarity = 4,
    blueprint_compat = true,
    calc_training_mul = function(self, card, joker, mult, stat)
        return mult * 4
    end,
    in_pool = function(self, args)
        return G.GAME.hpot_training_has_ever_been_done
    end,
    hotpot_credits = {
        art = { 'Aikoyori' },
        code = { 'Aikoyori' },
        idea = { 'Haya' },
        team = { 'Jtem' }
    },
}

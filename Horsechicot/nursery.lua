G.STATES.NURSERY = 69420223
function G.FUNCS.show_nursery(e)
    stop_use()
    hide_shop()
    G.STATE = G.STATES.NURSERY
    G.STATE_COMPLETE = false
end

if Nursery then
    if G.nursery then
        G.FUNCS.hide_nursery()
        G.nursery:remove()
        G.nursery = nil
        G.nursery_mother:remove()
        G.nursery_father:remove()
    end
end

--light copying from plinko
Nursery = {
    o = {},
    f = {}
}

local start_run_ref = Game.start_run
function Game:start_run(args)
  local ret = start_run_ref(self, args)
  local saveTable = args.savetext or nil
  if saveTable and saveTable.cardAreas then
    G.GAME.nursery_father_table = saveTable.cardAreas.nursery_father
    G.GAME.nursery_mother_table = saveTable.cardAreas.nursery_mother
    G.GAME.nursery_child_table = saveTable.cardAreas.nursery_child
  end
  return ret
end

function update_nursery(dt) -- talen from plinko so idk
    if not G.STATE_COMPLETE then
        stop_use()
        ease_background_colour_blind(G.STATES.NURSERY)
        G.nursery = G.nursery or UIBox {
            definition = G.UIDEF.hotpot_horsechicot_nursery_section(),
            config = { align = 'tmi', offset = { x = 0, y = G.ROOM.T.y + 11 }, major = G.hand, bond = 'Weak' }
        }

        G.E_MANAGER:add_event(Event({
            func = function()
                G.nursery.alignment.offset.y = -5.3
                G.nursery.alignment.offset.x = 0
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.2,
                    blockable = false,
                    func = function()
                        if math.abs(G.nursery.T.y - G.nursery.VT.y) < 3 then
                            G.ROOM.jiggle = G.ROOM.jiggle + 3
                            play_sound('cardFan2')
                            -- Back to shop button
                            G.CONTROLLER:snap_to({ node = G.nursery:get_UIE_by_ID('shop_button') })

                            return true
                        end
                    end
                }))
                return true
            end
        }))

        G.STATE_COMPLETE = true
    end
    if G.GAME.breeding_finished then
        G.GAME.breeding_finished = false
    end
end

function G.FUNCS.can_hide_nursery(e)
    return true
end

function G.FUNCS.hide_nursery(e)
    stop_use()

    G.STATE = G.STATES.SHOP
    G.STATE_COMPLETE = false
    ease_background_colour_blind(G.STATE)
    show_shop()


    G.E_MANAGER:add_event(Event({
        func = function()
            if G.shop then G.CONTROLLER:snap_to({ node = G.shop:get_UIE_by_ID('next_round_button') }) end
            return true
        end
    }))
end

function G.UIDEF.hotpot_horsechicot_nursery_section()
    if not G.nursery_father or not G.nursery_father.cards then
        G.nursery_father = CardArea(
            G.hand.T.x - 1,
            G.hand.T.y + G.ROOM.T.y + 9,
            math.min(1.02 * G.CARD_W, 4.08 * G.CARD_W),
            1.05 * G.CARD_H,
            { card_limit = 1, type = 'shop', highlight_limit = 1, negative_info = true })
        G.nursery_mother = CardArea(
            G.hand.T.x + 1,
            G.hand.T.y + G.ROOM.T.y + 9,
            math.min(1.02 * G.CARD_W, 4.08 * G.CARD_W),
            1.05 * G.CARD_H,
            { card_limit = 1, type = 'shop', highlight_limit = 1, negative_info = true })
        G.nursery_child = CardArea(
            G.hand.T.x + 1,
            G.hand.T.y + G.ROOM.T.y + 9,
            math.min(1.02 * G.CARD_W, 4.08 * G.CARD_W),
            1.05 * G.CARD_H,
            { card_limit = 1, type = 'shop', highlight_limit = 1, negative_info = true })
    end
    if G.GAME.nursery_father_table then
        G.nursery_father:load(G.GAME.nursery_father_table)
        G.GAME.nursery_father_table = nil
    end
    if G.GAME.nursery_mother_table then
        G.nursery_mother:load(G.GAME.nursery_mother_table)
        G.GAME.nursery_mother_table = nil
    end
    if G.GAME.nursery_child_table then
        G.nursery_child:load(G.GAME.nursery_child_table)
        G.GAME.nursery_child_table = nil
    end
    return
    {
        n = G.UIT.ROOT,
        config = { align = 'cl', colour = G.C.CLEAR },
        nodes = {
            UIBox_dyn_container({
                {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.1, emboss = 0.05, r = 0.1, colour = G.C.DYN_UI.BOSS_MAIN },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm" },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { align = "cm", padding = 0.05 },
                                    nodes = {
                                        {
                                            n = G.UIT.C,
                                            config = { align = "cm", padding = 0.1 },
                                            nodes = {
                                                {
                                                    n = G.UIT.R,
                                                    config = { id = 'shop_button', align = "cm", minw = 2.8, minh = 1.5, r = 0.15, colour = G.C.RED, one_press = false, button = 'hide_nursery', func = 'can_hide_nursery', hover = true, shadow = true },
                                                    nodes = {
                                                        {
                                                            n = G.UIT.R,
                                                            config = { align = "cm", padding = 0.07, focus_args = { button = 'y', orientation = 'cr' }, func = 'set_button_pip' },
                                                            nodes = {
                                                                {
                                                                    n = G.UIT.R,
                                                                    config = { align = "cm", maxw = 1.3 },
                                                                    nodes = {
                                                                        -------------------
                                                                        { n = G.UIT.T, config = { text = localize("hotpot_plinko_to_shop1"), scale = 0.4, colour = G.C.WHITE, shadow = true } }
                                                                        -------------------
                                                                    }
                                                                },
                                                                {
                                                                    n = G.UIT.R,
                                                                    config = { align = "cm", maxw = 1.3 },
                                                                    nodes = {
                                                                        -------------------
                                                                        { n = G.UIT.T, config = { text = localize("hotpot_plinko_to_shop2"), scale = 0.4, colour = G.C.WHITE, shadow = true } }
                                                                        -------------------
                                                                    }
                                                                }
                                                            }
                                                        },
                                                    }
                                                },

                                                {
                                                    n = G.UIT.R,
                                                    config = { id = "wheel_credits", align = "cm", minw = 2.8, 1, r = 0.15, padding = 0.07, colour = G.C.PURPLE, button = 'emplace_father', func = 'can_emplace_father', hover = true, shadow = true },
                                                    nodes = {
                                                        {
                                                            n = G.UIT.C,
                                                            config = { align = "cm", focus_args = { button = 'x', orientation = 'cr' }, func = 'set_button_pip' },
                                                            nodes = {
                                                                {
                                                                    n = G.UIT.R,
                                                                    config = { align = "cm", maxw = 1.3 },
                                                                    nodes = {
                                                                        -------------------
                                                                        { n = G.UIT.T, config = { text = "Emplace", scale = 0.7, colour = G.C.WHITE, shadow = true } },
                                                                        -------------------
                                                                    }
                                                                },
                                                                {
                                                                    n = G.UIT.R,
                                                                    config = { align = "cm", maxw = 1.3, minw = 1 },
                                                                    nodes = {
                                                                        -------------------
                                                                        { n = G.UIT.T, config = { text = "Father", scale = 0.7, colour = G.C.WHITE, shadow = true } },
                                                                        -------------------
                                                                    }
                                                                } or nil
                                                            }
                                                        }
                                                    }
                                                },
                                                {
                                                    n = G.UIT.R,
                                                    config = { id = "wheel_credits", align = "cm", minw = 2.8, minh = 1, r = 0.15, padding = 0.07, colour = G.C.PURPLE, button = 'emplace_mother', func = 'can_emplace_mother', hover = true, shadow = true },
                                                    nodes = {
                                                        {
                                                            n = G.UIT.C,
                                                            config = { align = "cm", focus_args = { button = 'x', orientation = 'cr' }, func = 'set_button_pip' },
                                                            nodes = {
                                                                {
                                                                    n = G.UIT.R,
                                                                    config = { align = "cm", maxw = 1.3 },
                                                                    nodes = {
                                                                        -------------------
                                                                        { n = G.UIT.T, config = { text = "Emplace", scale = 0.7, colour = G.C.WHITE, shadow = true } },
                                                                        -------------------
                                                                    }
                                                                },
                                                                {
                                                                    n = G.UIT.R,
                                                                    config = { align = "cm", maxw = 1.3, minw = 1 },
                                                                    nodes = {
                                                                        -------------------
                                                                        { n = G.UIT.T, config = { text = "Mother", scale = 0.7, colour = G.C.WHITE, shadow = true } },
                                                                        -------------------
                                                                    }
                                                                } or nil
                                                            }
                                                        }
                                                    }
                                                },
                                            }
                                        },
                                    }
                                },
                            }
                        },

                        {
                            n = G.UIT.C,
                            config = { align = "cm", padding = 0.2, r = 0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2 },
                            nodes = {
                                {
                                    n = G.UIT.R,
                                    config = { id = "nursery_area", align = "cm", colour = G.C.BLACK, r = 0.2 },
                                    nodes = {

                                        {
                                            n = G.UIT.C,
                                            config = { align = "cm", colour = G.C.BLACK, padding = 0.2, minw = 2.3, minh = 1.9, r = 0.2 },
                                            nodes = {
                                                { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W },                                              nodes = { { n = G.UIT.T, config = { text = "Father", scale = 0.7, colour = G.C.WHITE, shadow = true } }, } },
                                                { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H, colour = G.C.GREY, r = 0.2 }, nodes = { { n = G.UIT.O, config = { object = G.nursery_father, align = "cl" } } } },
                                            }
                                        },
                                        {
                                            n = G.UIT.C,
                                            config = { align = "cm", colour = G.C.BLACK, padding = 0.2, minw = 2.3, minh = 1.9, r = 0.2 },
                                            nodes = {
                                                { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W },                                              nodes = { { n = G.UIT.T, config = { text = "Mother", scale = 0.7, colour = G.C.WHITE, shadow = true } }, } },
                                                { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H, colour = G.C.GREY, r = 0.2 }, nodes = { { n = G.UIT.O, config = { object = G.nursery_mother, align = "cl" } } } },
                                            }
                                        },
                                        {
                                            n = G.UIT.C,
                                            config = { align = "cm", colour = G.C.BLACK, padding = 0.2, minw = 2.3, minh = 1.9, r = 0.2 },
                                            nodes = {
                                                { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W },                                              nodes = { { n = G.UIT.T, config = { text = "Child", scale = 0.7, colour = G.C.WHITE, shadow = true } }, } },
                                                { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W, minh = G.CARD_H, colour = G.C.GREY, r = 0.2 }, nodes = { { n = G.UIT.O, config = { object = G.nursery_child, align = "cl" } } } },
                                            }
                                        },
                                    }
                                },
                            }
                        },
                    }
                },
                {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.2, colour = G.C.L_BLACK, emboss = 0.05, r = 0.02 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "cm", r = 0.2 },
                            nodes = {
                                UIBox_button {
                                    label = { "Breed" },
                                    colour = G.C.ETERNAL,
                                    scale = 0.4,
                                    minh = 0.6,
                                    maxh = 0.6,
                                    minw = 2,
                                    maxw = 2,
                                    button = "nursery_breed",
                                    func = "can_nursery_breed",
                                },
                            }
                        },
                        {
                            n = G.UIT.C,
                            config = { align = "cm", r = 0.2 },
                            nodes = {
                                UIBox_button {
                                    label = { "Abort" },
                                    colour = G.C.ETERNAL,
                                    scale = 0.4,
                                    minh = 0.6,
                                    maxh = 0.6,
                                    minw = 2,
                                    maxw = 2,
                                    button = "nursery_abort",
                                    func = "can_nursery_abort",
                                },
                            }
                        },
                        -- {
                        --     n = G.UIT.C,
                        --     config = { align = "cm", r = 0.2 },
                        --     nodes = {
                        --         { n = G.UIT.R, config = { align = "cm", minw = G.CARD_W }, nodes = { { n = G.UIT.T, config = { text = "Mother", scale = 0.5, colour = G.C.WHITE, shadow = true } }, } },
                        --     }
                        -- },
                    }
                },

            }, false)
        }
    }
end

function G.FUNCS.nursery_abort(e)
    G.GAME.active_breeding = false
    G.GAME.center_being_duped = nil
    SMODS.calculate_effect { card = G.nursery_mother.cards[1], message = "Aborted!" }
end

function G.FUNCS.can_nursery_abort(e)
    if not G.GAME.active_breeding then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = "nursery_abort"
    end
end

function G.FUNCS.nursery_breed(e)
    local mom = G.nursery_mother.cards[1]
    local dad = G.nursery_father.cards[1]
    Horsechicot.breed(mom.config.center, dad.config.center)
    mom:juice_up()
    SMODS.calculate_effect {
        card = mom,
        message = "Impregnated!",
    }
end

local ca_dref = CardArea.draw
function CardArea:draw(...)
    if self == G.hand and (G.STATE == G.STATES.NURSERY) then
        return
    end
    return ca_dref(self, ...)
end

function G.FUNCS.emplace_mother(e)
    local jkr = G.jokers.highlighted[1]
    G.jokers:remove_from_highlighted(jkr, true)
    G.jokers:remove_card(jkr)
    G.nursery_mother:emplace(jkr)
end

function G.FUNCS.can_emplace_mother(e)
    if #G.jokers.highlighted ~= 1 or #G.nursery_mother.cards ~= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = "emplace_mother"
    end
end

function G.FUNCS.emplace_father(e)
    local jkr = G.jokers.highlighted[1]
    G.jokers:remove_from_highlighted(jkr, true)
    G.jokers:remove_card(jkr)
    G.nursery_father:emplace(jkr)
end

function G.FUNCS.can_emplace_father(e)
    if #G.jokers.highlighted ~= 1 or #G.nursery_father.cards ~= 0 then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.RED
        e.config.button = "emplace_father"
    end
end

function G.FUNCS.can_nursery_breed(e)
    if #G.nursery_mother.cards == 1 and #G.nursery_father.cards == 1 and not G.nursery_mother.cards[1].infertile and not G.nursery_father.cards[1].infertile then
        e.config.colour = G.C.ETERNAL
        e.config.button = "nursery_breed"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end

local old = Card.highlight
function Card:highlight(is)
    if (G.nursery_mother and self.area == G.nursery_mother and not G.GAME.active_breeding) or (G.nursery_father and self.area == G.nursery_father) then
        local area = self.area
        area:remove_card(self)
        G.jokers:emplace(self)
    else
        old(self, is)
    end
end

--end ui, start mechanics
G.C.HPOT_PINK = HEX("fe89d0")
G.ARGS.LOC_COLOURS.hpot_pink = G.C.HPOT_PINK
function Horsechicot.breed(mother_center, father_center)
    local center_to_dupe
    if G.GAME.guaranteed_breed_center == "mother" then
        center_to_dupe = mother_center
    else
        local poll = pseudorandom("hc_breed_result")
        if poll > 0.5 then
            G.GAME.child_color = G.C.HPOT_PINK
            center_to_dupe = mother_center
        else
            G.GAME.child_color = G.C.BLUE
            center_to_dupe = father_center
        end
    end
    G.GAME.active_breeding = true
    G.GAME.center_being_duped = center_to_dupe
    G.GAME.breeding_rounds_passed = 0
end

local old = end_round
function end_round()
    old()
    G.E_MANAGER:add_event(Event {
        func = function()
            local to_dupe = G.GAME.center_being_duped
            if to_dupe then
                G.GAME.breeding_rounds_passed = G.GAME.breeding_rounds_passed + 1
                if G.GAME.breeding_rounds_passed >= (G.GAME.quick_preggo and 1 or 2) then
                    G.GAME.active_breeding = false
                    G.GAME.breeding_finished = true
                    G.GAME.center_being_duped = false
                    local card = SMODS.create_card { key = to_dupe.key }
                    card.infertile = true
                    G.nursery_mother.cards[1].infertile = true
                    G.nursery_child:emplace(card)
                end
            end
            return true
        end
    })
end

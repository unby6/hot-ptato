G.dynamic_train_messages = {
    speed = "",
    stamina = "",
    power = "",
    guts = "",
    wits = "",

    stats_speed = "",
    stats_stamina = "",
    stats_power = "",
    stats_guts = "",
    stats_wits = "",
}

local update_ref = Game.update


-- this moves the shop up and down along with slide whistle sound :joy::ok_hand:
function G.FUNCS.hotpot_pd_toggle_training()
    if (G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)) then return end
    stop_use()
    if not G.HP_TRAINING_VISIBLE then
        ease_background_colour({ new_colour = G.C.BLUE, special_colour = G.C.RED, tertiary_colour = darken(G.C.BLACK, 0.4), contrast = 3 })
        G.shop.alignment.offset.y = -60
        G.HP_TRAINING_VISIBLE = true
        play_sound("hpot_sfx_whistleup", nil, 0.25)
    else
        if G.train_jokers and #(G.train_jokers.cards or {}) > 0 then
            for _,v in ipairs(G.train_jokers.cards) do
                HotPotato.draw_card(G.train_jokers, G.jokers, 1, 'up', nil, v, 0)
            end
        end
        ease_background_colour_blind(G.STATES.SHOP)
        G.shop.alignment.offset.y = -5.3
        G.HP_TRAINING_VISIBLE = false
        play_sound("hpot_sfx_whistledown", nil, 0.25)
    end
end

local start_run_ref = Game.start_run
function Game:start_run(args)
    G.HP_TRAINING_VISIBLE = nil
    local ret = start_run_ref(self, args)
    local saveTable = args.savetext or nil
    if saveTable and saveTable.cardAreas then
        G.GAME.train_table = saveTable.cardAreas.train_jokers
    end
    G.jokers.states.collide.can = true

    G.GAME.training_level = G.GAME.training_level or {
        speed = 1,
        stamina = 1,
        power = 1,
        guts = 1,
        wits = 1
    }
    G.GAME.training_count = G.GAME.training_count or {
        speed = 0,
        stamina = 0,
        power = 0,
        guts = 0,
        wits = 0
    }

    return ret
end

function G.FUNCS.hotpot_training_grounds_train(e)

end

function G.UIDEF.hotpot_pd_training_section()
    if not G.train_jokers or not G.train_jokers.cards then
        G.train_jokers = CardArea(
            G.hand.T.x + 0,
            G.hand.T.y + G.ROOM.T.y + 9,
            math.min(1.02 * G.CARD_W, 4.08 * G.CARD_W),
            1.05 * G.CARD_H,
            { card_limit = 1, type = 'title', highlight_limit = 0, negative_info = true }
        )
        G.train_jokers.states.collide.can = true
    end
    if G.GAME.train_table then
        G.train_jokers:load(G.GAME.train_table)
        G.GAME.train_table = nil
    end
    local training_level = {
        speed = 1,
        stamina = 1,
        power = 1,
        guts = 1,
        wits = 1
    }

    local button_minsize = 1.5
    local function create_train_button(train)
        return {n = G.UIT.C, config = {align = "cm", padding = 0.05, r = 0.2, colour = G.C.training_colors[train], minw = button_minsize, minh = button_minsize, outline_colour = G.C.WHITE, outline = 1.6, button = "hotpot_training_grounds_train", train = train, hover = true, shadow = true}, nodes = {
            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                {n = G.UIT.T, config = {text = localize("hotpot_"..train), scale = 0.45, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n = G.UIT.R, config = {align = "cm"}, nodes = {
                {n = G.UIT.T, config = {text = localize("hotpot_training_level")..training_level[train], scale = 0.3, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
        }}
    end
    local function create_stat_display(stat)
        return {n = G.UIT.C, config = {align = "tm"}, nodes = {
            {n = G.UIT.R, config = {align = "cm", colour = G.C.hotpot_default_stat_color, minh = 0.4, padding = 0.05}, nodes = {
                {n = G.UIT.T, config = {text = localize("hotpot_"..stat), scale = 0.35, colour = G.C.UI.TEXT_LIGHT, shadow = true}},
            }},
            {n = G.UIT.R, config = {align = "cm", padding = 0.025}, nodes = {
                {n = G.UIT.C, config = {align = "cm", padding = 0.02}, nodes = {
                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                        {n = G.UIT.T, config = {text = "F", scale = 0.6, colour = G.C.UI.TEXT_DARK, shadow = true}},
                    }},
                }},
                {n = G.UIT.C, config = {align = "cm", padding = 0.02}, nodes = {
                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                        {n = G.UIT.T, config = {text = "60", scale = 0.425, colour = G.C.UI.TEXT_DARK, shadow = true}},
                    }},
                    {n = G.UIT.R, config = {align = "cm"}, nodes = {
                        {n = G.UIT.T, config = {text = "/1200", scale = 0.3, colour = G.C.UI.TEXT_DARK, shadow = true}},
                    }},
                }},
            }},
        }}
    end
    local function create_stat_display_gap(minw, padding, r)
        return {n = G.UIT.C, config = {align = "tm", padding = padding or nil}, nodes = {
            {n = G.UIT.R, config = {align = "cm", colour = G.C.hotpot_default_stat_color, minh = 0.4, minw = minw or 0.35, r = r or nil}},
        }}
    end

    return {n = G.UIT.R, config = {minw = 3, minh = 2.5, colour = G.C.CLEAR}, nodes = {}},
        {n = G.UIT.R, config = {align = "cm", padding = 0.05}, nodes = {
            {n = G.UIT.C, config = {align = "cm", padding = 0.1}, nodes = {
                {n = G.UIT.R, config = {align = "cm"}, nodes = {
                    {n = G.UIT.C, config = {align = "cm", padding = 0.125, r = 0.2, colour = G.C.L_BLACK, minw = 3, minh = 3.75}, nodes = {
                        {n = G.UIT.R, config = {align = "cm"}, nodes = {
                            {n = G.UIT.T, config = {text = localize("hotpot_training_joker"), scale = 0.45, colour = G.C.BLACK}},
                        }},
                        {n = G.UIT.R, config = {align = "cm"}, nodes = {
                            {n = G.UIT.C, config = {align = "cm", padding = 0.1, r = 0.2, colour = G.C.BLACK}, nodes = {
                                {n = G.UIT.O, config = {object = G.train_jokers}},
                            }},
                        }},
                        {n = G.UIT.R, config = {align = "cm", minh = 0.05}},
                    }},
                }},
                {n = G.UIT.R, config = {align = "cm", minh = 0.5}},
                {n = G.UIT.R, config = {align = "tm"}, nodes = {
                    {n = G.UIT.C, config = {align = "tm"}, nodes = {
                        {n = G.UIT.R, config = {align = "tm", colour = G.C.WHITE, r = 0.15, outline_colour = G.C.hotpot_default_stat_color, outline = 1}, nodes = {
                            create_stat_display_gap(0.45),
                            create_stat_display("speed"),
                            create_stat_display_gap(),
                            create_stat_display("stamina"),
                            create_stat_display_gap(),
                            create_stat_display("power"),
                            create_stat_display_gap(),
                            create_stat_display("guts"),
                            create_stat_display_gap(),
                            create_stat_display("wits"),
                            create_stat_display_gap(0.45),
                        }},
                    }},
                }},
                {n = G.UIT.R, config = {align = "cm", minh = 0.3}},
                {n = G.UIT.R, config = {align = "cm", padding = 0.2}, nodes = {
                    create_train_button("speed"),
                    create_train_button("stamina"),
                    create_train_button("power"),
                    create_train_button("guts"),
                    create_train_button("wits"),
                }},
            }},
        }},
        { n = G.UIT.R, config = { minw = 3, minh = 7, colour = G.C.CLEAR }, nodes = {} }
end

G.C = G.C or {}
G.C.level_colors = {
    level_1 = HEX("61c963"),
    level_2 = copy_table(G.C.BLUE),
    level_3 = copy_table(G.C.FILTER),
    level_4 = HEX("cf3853"),
    level_5 = HEX("6156a6"),
}
G.C.hotpot_default_stat_color = HEX("61c963")
G.C.training_colors = {
    speed = copy_table(G.C.level_colors["level_1"]),
    stamina = copy_table(G.C.level_colors["level_1"]),
    power = copy_table(G.C.level_colors["level_1"]),
    guts = copy_table(G.C.level_colors["level_1"]),
    wits = copy_table(G.C.level_colors["level_1"])
}

local loc_colour_ref = loc_colour
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        loc_colour_ref()
    end

    for i,v in pairs(G.C.level_colors) do
        G.ARGS.LOC_COLOURS["train_"..i] = v
        G.C["train_"..i] = v
    end

    return loc_colour_ref(_c, _default)
end

--Code to drag card between areas, adapted from Aikoyori Shenanigans' code (check it out btw)
function HotPotato.draw_card(from, to, percent, dir, sort, card, delay, mute, stay_flipped, vol, discarded_only, forced_facing)
    percent = percent or 50
    delay = delay or 0.1 
    if dir == 'down' then 
        percent = 1-percent
    end
    sort = sort or false
    local drawn = nil

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = delay,
        blocking = not (G.SETTINGS.GAMESPEED >= 999 and ((to == G.hand and from == G.deck) or (to == G.deck and from == G.hand))), -- Has to be these specific draws only, otherwise it's buggy
        
        func = function()
            if card then 
                if from then card = from:remove_card(card) end
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                local stay_flipped = G.GAME and G.GAME.blind and G.GAME.blind:stay_flipped(to, card, from)
                if to then
                    to:emplace(card, nil, stay_flipped)
                else
                    
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            else
                card = to:draw_card_from(from, stay_flipped, discarded_only)
                if card then drawn = true end
                if card and to == G.hand and not card.states.visible then
                    card.states.visible = true
                end
                if card and forced_facing then 
                    card.sprite_facing = forced_facing
                    card.facing = forced_facing
                end
            end
            if not mute and drawn then
                if from == G.deck or from == G.hand or from == G.play or from == G.jokers or from == G.consumeables or from == G.discard then
                    G.VIBRATION = G.VIBRATION + 0.6
                end
                play_sound('card1', 0.85 + percent*0.2/100, 0.6*(vol or 1))
            end
            if sort then
                to:sort()
            end
            SMODS.drawn_cards = SMODS.drawn_cards or {}
            if card and card.playing_card then SMODS.drawn_cards[#SMODS.drawn_cards+1] = card end
            
            if card and forced_facing then 
                card.facing = forced_facing
                card.sprite_facing = forced_facing
            end
            return true
        end
      }))
end

local toHook = Card.stop_drag
function Card:stop_drag()
    if G.jokers and G.train_jokers then
        local area = self.area
        self.hp_oldarea = self.area or self.hp_oldarea
        for i, k in ipairs(G.CONTROLLER.collision_list) do
            if (k:is(CardArea)) then
                area = k
                break
            end
            
            if (k:is(Card)) and false then
                area = k.area
                break
            end
        end
        if self.hp_oldarea ~= area and (area == G.train_jokers and G.train_jokers.cards and #(G.train_jokers.cards or {}) <= 0) or (area == G.jokers and self.hp_oldarea == G.train_jokers) then
            HotPotato.draw_card(self.hp_oldarea, area, 1, 'up', nil, self ,0)
            G.E_MANAGER:add_event(Event({
                func = function()
                    self.hp_oldarea = nil
                    return true 
                end
            }))
            area:align_cards()
        end
    end
    local c = toHook(self)
    return c
end 
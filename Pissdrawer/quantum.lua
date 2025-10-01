Quantum = Card:extend()

for key, func in pairs(Card) do
    if type(func) == 'function' then
        Quantum[key] = function(self, ...)
            return Card[key](self.quantum, ...)
        end
    end
end


function Quantum:init(args, source)
    --ty eremel <3
    self.base_cost = args.base_cost or 0
    self.extra_cost = args.extra_cost or 0
    self.cost = args.cost or 0
    self.sell_cost = args.sell_cost or 0
    self.sell_cost_label = args.sell_cost_label or 0
    self.base = {}

    self.key = args.key
    self.fake_card = true
    self.ability = args.ability
    self.config = args.config
    self.quantum = source
end

function Quantum:save()
    local cardTable = {
        base_cost = self.base_cost,
        extra_cost = self.extra_cost,
        cost = self.cost,
        sell_cost = self.sell_cost,
        ability = self.ability,
        key = self.key,
        fake_card = true,
        config = {
            center = self.config.center
        },
    }
    return cardTable
end

local cs = Card.save
function Card:save()
    local cardTable = cs(self)
    if self.ability and self.ability.quantum_1 and type(self.ability.quantum_1) ~= 'string' then
        for i = 1, 2 do
            cardTable['quantum_' .. i] = Quantum.save(self.ability['quantum_' .. i])
        end
    end
    return cardTable
end

local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    if card.quantum then card = card.quantum end
    cest(card, eval_type, amt, percent, dir, extra)
end

local smods_find_card = SMODS.find_card
function SMODS.find_card(key, count_debuffed)
    local results = smods_find_card(key, count_debuffed)
    if not G.jokers or not G.jokers.cards then return {} end
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
        if area.cards then
            for _, v in pairs(area.cards) do
                if v and type(v) == 'table' and v.ability and v.ability.quantum_1 and (v.ability.quantum_1.key == key or v.ability.quantum_2.key == key) and (count_debuffed or not v.debuff) then
                    table.insert(results, v)
                end
            end
        end
    end
    return results
end

-- is rarity
local is_rarity = Card.is_rarity
function Card:is_rarity(rarity)
    if self.ability.quantum_1 then
        local rarities = { "Common", "Uncommon", "Rare", "Legendary" }
        rarity = rarities[rarity] or rarity
        local own_rarity_1 = rarities[self.ability.quantum_1.config.center.rarity] or
            self.ability.quantum_1.config.center.rarity
        local own_rarity_2 = rarities[self.ability.quantum_2.config.center.rarity] or
            self.ability.quantum_2.config.center.rarity
        return own_rarity_1 == rarity or SMODS.Rarities[own_rarity_1] == rarity or own_rarity_2 == rarity or
            SMODS.Rarities[own_rarity_2] == rarity
    end
    return is_rarity(self, rarity)
end

SMODS.Rarity {
    key = "child",
    loc_txt = { name = "Child" },
    badge_colour = G.C.HPOT_PINK,
}

SMODS.Joker {
    key = 'child',
    rarity = 'hpot_child',
    hotpot_credits = {
        idea = { "fey <3" },
        code = { "fey <3" },
        team = { "Pissdrawer" }
    },
    no_collection = true,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        local q1, q2 = card.ability.quantum_1, card.ability.quantum_2
        local func = (q1.config.center.generate_ui or SMODS.Joker.generate_ui)
        func(q1.config.center, info_queue, q1, desc_nodes, Card.generate_UIBox_ability_table(q1, true), full_UI_table)
        if q1.config.center.key == "j_blueprint" or q1.config.center.key == "j_brainstorm" then
            desc_nodes[#desc_nodes + 1] =
            {
                {
                    n = G.UIT.C,
                    config = { align = "bm", minh = 0.4 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { ref_table = q1, align = "m", colour = G.C.JOKER_GREY, r = 0.05, padding = 0.06, func = 'blueprint_compat' },
                            nodes = {
                                { n = G.UIT.T, config = { ref_table = q1.ability, ref_value = 'blueprint_compat_ui', colour = G.C.UI.TEXT_LIGHT, scale = 0.32 * 0.8 } },
                            }
                        }
                    }
                }
            }
        end
    end,
    calculate = function(self, card, context)
        if card.ability.quantum_1 and card.ability.quantum_2 then
            --local ret, trig = card.ability.quantum_1:calculate_joker(context)
            local ret, trig = Card.calculate_joker(card.ability.quantum_1, context)
            --local ret2, trig2 = card.ability.quantum_2:calculate_joker(context)
            local ret2, trig2 = Card.calculate_joker(card.ability.quantum_2, context)
            if ret and ret.card and ret.card == card.ability.quantum_1 then ret.card = card end
            if ret2 and ret2.card and ret2.card == card.ability.quantum_2 then ret2.card = card end
            return SMODS.merge_effects { ret or {}, ret2 or {} }, trig or trig2
        end
    end,
    calc_dollar_bonus = function(self, card)
        if card.ability.quantum_1 or card.ability.quantum_2 then
            local ret1 = Card.calculate_dollar_bonus(card.ability.quantum_1)
            local ret2 = Card.calculate_dollar_bonus(card.ability.quantum_2)
            if ret1 and ret2 and type(ret1) == 'number' and type(ret2) == 'number' then
                ret1 = ret1 + ret2
            end
            return ret1 or ret2
        end
    end,
    add_to_deck = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if card.ability.quantum_1 and card.ability.quantum_2 then
                    Card.add_to_deck(card.ability.quantum_1)
                    Card.add_to_deck(card.ability.quantum_2)
                    return true
                end
            end
        }))
    end,
    remove_from_deck = function(self, card)
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = function()
                if card.ability.quantum_1 and card.ability.quantum_2 then
                    Card.remove_from_deck(card.ability.quantum_1)
                    Card.remove_from_deck(card.ability.quantum_2)
                    return true
                end
            end
        }))
    end,
    in_pool = function(self, args)
        return false
    end,
    load = function(self, card, table, other)
        if table.ability and table.ability.quantum_1 then
            local args = table.quantum_1
            args.config.center = G.P_CENTERS[args.key]
            table.ability.quantum_1 = Quantum(args)
            args = table.quantum_2
            args.config.center = G.P_CENTERS[args.key]
            table.ability.quantum_2 = Quantum(args)
            update_child_atlas(card, G.ASSET_ATLAS[G.P_CENTERS[table.ability.quantum_1.key].atlas or 'Joker'],
                G.P_CENTERS[table.ability.quantum_1.key].pos)
            card.loaded = true
        end
    end,
    update = function(self, card, dt)
        if card.loaded then
            card.loaded = false
            update_child_atlas(card, G.ASSET_ATLAS[G.P_CENTERS[card.ability.quantum_1.key].atlas or 'Joker'],
                G.P_CENTERS[card.ability.quantum_1.key].pos)
        end
    end
}

-- Tooltips use multibox
local gen_card_ui = generate_card_ui
function generate_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    local ui = gen_card_ui(_c, full_UI_table, specific_vars, card_type, badges, hide_desc, main_start, main_end, card)
    if card and card.ability.quantum_1 then
        local quantum_nodes = {}
        local info_queue = {}
        local vars = card.ability.quantum_2.config.center.loc_vars and
            card.ability.quantum_2.config.center.loc_vars(card.ability.quantum_2.config.center, info_queue,
                card.ability.quantum_2)
            .vars -- custom loc_vars functions
            or
            Card.generate_UIBox_ability_table(
                { ability = card.ability.quantum_2.ability, config = card.ability.quantum_2.config, bypass_lock = true },
                true)
        localize { type = 'descriptions', set = 'Joker', key = card.ability.quantum_2.key, nodes = quantum_nodes, vars = vars or {}, AUT = { info = { "yes" } } } -- some jank here to allow the second quantum object to have a multi box, currently combines them into one box like info_queues
        ui.quantum = quantum_nodes

        -- Can't get this working for vanilla jokers rn, this code lets custom jokers in slot 2 add to info queue
        -- if next(info_queue) then
        --     for _, v in ipairs(info_queue) do
        --         generate_card_ui(v, full_UI_table, {is_info_queue = true})
        --     end
        -- end
    end
    return ui
end

local card_h_popup = G.UIDEF.card_h_popup
function G.UIDEF.card_h_popup(card)
    local ret_val = card_h_popup(card)
    local AUT = card.ability_UIBox_table
    if AUT.quantum then
        table.insert(ret_val.nodes[1].nodes[1].nodes[1].nodes,
            #ret_val.nodes[1].nodes[1].nodes[1].nodes + (card.config.center.discovered and 0 or 1),
            desc_from_rows(AUT.quantum))
    end
    return ret_val
end

-- soul sprites
SMODS.DrawStep {
    key = 'floating_sprite',
    order = 60,
    func = function(self)
        if self.ability.quantum_1 and self.ability.quantum_1.config.center.soul_pos then
            local scale_mod = 0.07 + 0.02 * math.sin(1.8 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL - math.floor(G.TIMERS.REAL)) * math.pi * 14) *
                (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 3
            local rotate_mod = 0.05 * math.sin(1.219 * G.TIMERS.REAL) +
                0.00 * math.sin((G.TIMERS.REAL) * math.pi * 5) * (1 - (G.TIMERS.REAL - math.floor(G.TIMERS.REAL))) ^ 2

            if type(self.ability.quantum_1.config.center.soul_pos.draw) == 'function' then
                self.ability.quantum_1.config.center.soul_pos.draw(self, scale_mod, rotate_mod)
            elseif self.children.floating_sprite then
                if self.ability.quantum_1.key == 'j_hologram' then
                    self.hover_tilt = self.hover_tilt * 1.5
                    self.children.floating_sprite:draw_shader('hologram', nil, self.ARGS.send_to_shader, nil,
                        self.children.center, 2 * scale_mod, 2 * rotate_mod)
                    self.hover_tilt = self.hover_tilt / 1.5
                else
                    self.children.floating_sprite:draw_shader('dissolve', 0, nil, nil, self.children.center, scale_mod,
                        rotate_mod, nil, 0.1 + 0.03 * math.sin(1.8 * G.TIMERS.REAL), nil, 0.6)
                    self.children.floating_sprite:draw_shader('dissolve', nil, nil, nil, self.children.center, scale_mod,
                        rotate_mod)
                end
            end
            if self.edition then
                local edition = G.P_CENTERS[self.edition.key]
                if edition.apply_to_float and self.children.floating_sprite then
                    self.children.floating_sprite:draw_shader(edition.shader, nil, nil, nil, self.children.center,
                        scale_mod, rotate_mod)
                end
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}


--quantum can find its own position during ipairs/pairs
local ip = ipairs
function ipairs(t)
    if G.jokers and t == G.jokers.cards then return quantumipairs(t) end
    return ip(t)
end

function quantumipairs(t)
    local ret = {}
    for i,v in ip(t) do
        table.insert(ret, v)
        if v.ability and v.ability.holds_quantum then 
            table.insert(ret, v.ability.quantum_1)
            table.insert(ret, v.ability.quantum_2)
        end
    end
    return ip(ret)
end

local p = pairs
function pairs(t)
    if G.jokers and t == G.jokers.cards then return quantumpairs(t) end
    return p(t)
end

function quantumpairs(t)
    local ret = {}
    for i,v in p(t) do
        table.insert(ret, v)
        if v.ability and v.ability.holds_quantum then 
            table.insert(ret, v.ability.quantum_1)
            table.insert(ret, v.ability.quantum_2)
        end
    end
    return p(ret)
end
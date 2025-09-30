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
        for i=1, 2 do
            cardTable['quantum_'..i] = Quantum.save(self.ability['quantum_'..i])
        end
    end
    return cardTable
end

local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    if card.quantum then card = card.quantum end
    cest(card, eval_type, amt, percent, dir, extra)
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
        -- `self`, `info_queue`, `card`: See loc_vars
        -- `desc_nodes`: A table to place UIElements into to be displayed in the current description box
        -- `specific_vars`: Variables passed from outside the current `generate_ui` call. Can be ignored for modded objects
        -- `full_UI_table`: A table representing the main description box. 
        -- Mainly used for checking if this is the main description or a tooltip, or manipulating the main description from tooltips.
        -- This function need not return anything, its effects should be applied by modifying desc_nodes
        local q1, q2 = card.ability.quantum_1, card.ability.quantum_2
        SMODS.Joker.generate_ui(q1.config.center, info_queue, q1, desc_nodes, Card.generate_UIBox_ability_table(q1, true), full_UI_table)
        desc_nodes[#desc_nodes+1] = {{
            n = G.UIT.C,
            config = { minh = 0.2 },
            nodes = {}
        }}
        SMODS.Joker.generate_ui(q2.config.center, info_queue, q2, desc_nodes, Card.generate_UIBox_ability_table(q2, true), full_UI_table)
    end,
    calculate = function(self, card, context)
        if card.ability.quantum_1 and card.ability.quantum_2 then
            --local ret, trig = card.ability.quantum_1:calculate_joker(context)
            local ret, trig = Card.calculate_joker(card.ability.quantum_1, context)
            --local ret2, trig2 = card.ability.quantum_2:calculate_joker(context)
            local ret2, trig2 = Card.calculate_joker(card.ability.quantum_2, context)
            if ret and ret2 then
                for i, v in pairs(ret) do
                    if ret2[i] and type(v) == 'number' then ret[i] = v + ret2[i] end
                end
            end
            if ret and ret.card and ret.card == card.ability.quantum_1 then ret.card = card end
            if ret2 and ret2.card and ret2.card == card.ability.quantum_2 then ret2.card = card end
            return ret or ret2, trig or trig2
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
            update_child_atlas(card, G.ASSET_ATLAS[G.P_CENTERS[table.ability.quantum_1.key] or 'Joker'], G.P_CENTERS[table.ability.quantum_1.key].pos)
        end
    end,
}
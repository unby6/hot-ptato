Quantum = Card:extend()

function Quantum:init(args)
    --ty eremel <3
    self.base_cost = args.base_cost or 0
    self.extra_cost = args.extra_cost or 0
    self.cost = args.cost or 0
    self.sell_cost = args.sell_cost or 0
    self.sell_cost_label = args.sell_cost_label or 0
    self.base = {}

    self.key = args.key
    self.fake_card = true
    self.card_to = args.card_to
    self.ability = args.ability
    self.config = args.config
    self.quantum = true
end

function quantumsave(card)
    local cardTable = {
        base_cost = card.base_cost,
        extra_cost = card.extra_cost,
        cost = card.cost,
        card_to = card.card_to,
        sell_cost = card.sell_cost,
        ability = card.ability,
        fake_card = true,
        config = {
            center = card.config.center
        },
    }
    return cardTable
end

local cs = Card.save
function Card:save()
    local cardTable = cs(self)
    if self.ability and self.ability.quantum and type(self.ability.quantum) ~= 'string' then
        cardTable.ability.quantum = cardTable.ability.quantum or {}
        for i,v in ipairs(self.ability.quantum) do
            cardTable.ability.quantum[i] = quantumsave(v)
        end
    end
    return cardTable
end

local cl = Card.load
function Card:load(...)
    local ret = cl(self, ...)
    if self.config.center.key == 'j_hpot_child' then
        update_child_atlas(self, G.ASSET_ATLAS[self.ability.quantum[1].config.center.atlas or 'Joker'], self.ability.quantum[1].config.center.pos)
    end
    return ret
end

local cest = card_eval_status_text
function card_eval_status_text(card, eval_type, amt, percent, dir, extra)
    if card.quantum then card = card.card_to end
    cest(card, eval_type, amt, percent, dir, extra)
end

--to fix funcs like juice_up || I'm almost there I can feel it
for key, func in pairs(Card) do
    if type(func) == 'function' and key ~= 'calculate_joker' and key ~= 'set_ability' then
        local ori = func
        func = function(obj, ...)
            local target = obj.card_to or obj
            return ori(target, ...)
        end
        Quantum[key] = func
    end
end
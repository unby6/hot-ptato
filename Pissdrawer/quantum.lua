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

function Quantum:save()
    local cardTable = {
        base_cost = self.base_cost,
        extra_cost = self.extra_cost,
        cost = self.cost,
        sell_cost = self.sell_cost,
        ability = self.ability,
        fake_card = true,
        config = {
            center = self.config.center.key
        },
    }
    return cardTable
end

local cs = Card.save
function Card:save()
    local cardTable = cs(self)
    if self.ability and self.ability.quantum and type(self.ability.quantum) ~= 'string' then
        cardTable.quantum = cardTable.quantum or {}
        for i,v in ipairs(self.ability.quantum) do
            cardTable.quantum[i] = v:save()
        end
    end
    return cardTable
end

local ju = Card.juice_up
function Card:juice_up(a, b)
    if not self.quantum then
        return ju(self, a, b)
    end
end

local sd = Card.start_dissolve
function Card:start_dissolve(...)
    if self.quantum then 
        for i,v in pairs(SMODS.get_card_areas('jokers')) do
            for _,c in pairs(v.cards or {}) do
                for p,q in pairs(c.ability.quantum or {}) do
                    if q == self then sd(self, ...) return end
                end
            end
        end
    end
    sd(self, ...)
end
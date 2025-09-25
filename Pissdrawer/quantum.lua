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
        for i,v in pairs(self.ability.quantum) do
            cardTable.quantum[i] = Quantum.save(v)
        end
    end
    return cardTable
end
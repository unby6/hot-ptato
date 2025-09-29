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
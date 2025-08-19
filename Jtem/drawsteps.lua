
SMODS.DrawStep {
    key = 'hp_misc_buttons',
    order = -29,
    func = function(self)
        --Draw any tags/buttons
        if self.children.hp_jtem_price_side then self.children.hp_jtem_price_side:draw() end
        if self.children.hp_jtem_cancel_order then self.children.hp_jtem_cancel_order:draw() end
    end,
} 

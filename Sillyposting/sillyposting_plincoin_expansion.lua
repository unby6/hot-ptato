function Card:calculate_plincoin_bonus()
    if not self:can_calculate() then return end
    local obj = self.config.center
    if obj.calc_plincoin_bonus and type(obj.calc_plincoin_bonus) == 'function' then
        return obj:calc_plincoin_bonus(self)
    end
end
-- for direct deposit. janky as fuck
function Card:calculate_plincoin_bonus_delayed()
    if not self:can_calculate() then return end
    local obj = self.config.center
    if obj.calc_plincoin_bonus_delayed and type(obj.calc_plincoin_bonus_delayed) == 'function' then
        return obj:calc_plincoin_bonus_delayed(self)
    end
end
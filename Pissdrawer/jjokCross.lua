if Jjok then
    Jjok.curse {
        key = 'pinpoint',
        loc_txt = {name = 'Pinpoint Precision', text = {'This Joker is pinned', '{s:0.8,C:inactive}(Cannot be sold)'}},
        set_ability = function(self,card)
            card.pinned = true
        end
    }
end

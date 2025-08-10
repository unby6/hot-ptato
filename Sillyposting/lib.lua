--for modifying max_highlights of consumables. *should* work with any modded consumeables that use the usual max_highlighted system
--#region Max Highlight stuff
--please fucking work PLEASE

create_card_ref = create_card
function create_card(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    local card = create_card_ref(_type, area, legendary, _rarity, skip_materialize, soulable, forced_key, key_append)
    if card.ability then
        if card.ability.consumeable and type(card.ability.consumeable) == "table" then
            if card.ability.consumeable.max_highlighted then
                card.ability.consumeable.max_highlighted = card.ability.consumeable.max_highlighted +
                    (G.GAME.max_highlighted_mod or 0)
                if card.ability.consumeable.max_highlighted < 1 then card.ability.consumeable.max_highlighted = 1 end
            end
        elseif card.ability.extra and type(card.ability.extra) == "table" then
            if card.ability.extra.max_highlighted then
                card.ability.extra.max_highlighted = card.ability.extra.max_highlighted +
                    (G.GAME.max_highlighted_mod or 0)
                if card.ability.extra.max_highlighted < 1 then card.ability.extra.max_highlighted = 1 end
            end
        elseif card.ability.max_highlighted then
            card.ability.max_highlighted = card.ability.max_highlighted + (G.GAME.max_highlighted_mod or 0)
        end
    end
    return card
end

function change_max_highlight(amount) --modifies the max_highlighted_mod variable and updates all existing consumables automatically. mostly for simplicity
    G.GAME.max_highlighted_mod = (G.GAME.max_highlighted_mod or 0) + amount
    for _, card in pairs(G.I.CARD) do
        if card.ability then
            if card.ability.consumeable and card.ability.consumeable.max_highlighted then
                card.ability.consumeable.max_highlighted = card.ability.consumeable.max_highlighted + amount
                if card.ability.consumeable.max_highlighted < 1 then card.ability.consumeable.max_highlighted = 1 end
            elseif card.ability.extra and card.ability.extra.max_highlighted then
                card.ability.extra.max_highlighted = card.ability.extra.max_highlighted + amount
                if card.ability.extra.max_highlighted < 1 then card.ability.extra.max_highlighted = 1 end
            elseif card.ability.max_highlighted then
                card.ability.max_highlighted = card.ability.max_highlighted + (G.GAME.max_highlighted_mod or 0)
            end
        end
    end
end

--#endregion

SMODS.Joker {
    key = "jade",
    config = { extra = { coins = 4 } },
    loc_vars = function (self, info_queue, card)
        return { vars = { card.ability.extra.coins } }
    end,
    pos = { x = 4, y = 0 },
    atlas = "SillypostingJokers",
    rarity = 3,
    cost = 10,
    discovered = true,
    calculate = function (self, card, context)
        if context.pk_cashout_row then
            local new_config = context.pk_cashout_row
            if new_config.name == "bottom" then --i would like to add a new row but perkeocoin left literally no information on how that works
                new_config.dollars = new_config.dollars + card.ability.extra.coins
            end
            return {new_config = new_config}
        end
    end,
    hotpot_credits = {
        code = {"Eris"},
        art = {"Jaydchw"},
        team = {"Sillyposting"}
    }
}
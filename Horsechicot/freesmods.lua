SMODS.Joker {
    key = "balatro_free_smods_download_2025",
    rarity = 2,
    cost = 5,
    atlas = "hc_placeholder",
    pos = {x=0,y=0},
    calculate = function(self, card, context)
        if context.selling_card then
            card.ability.extra_value = card.ability.extra_value + context.card.sell_cost
            card:set_cost()
            return {
                message = localize("k_val_up"),
                colour = G.C.MONEY
            }
        end
    end,
    hotpot_credits = Horsechicot.credit("Lily Felli")
}
-- this is very easy but i spent 30 minutes confused about lsp stuff not working
--.... i spelt it smdos instead of smods.
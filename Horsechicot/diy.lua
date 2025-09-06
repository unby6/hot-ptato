SMODS.Joker {
    key = "diy",
    rarity = 3,
    cost = 10,
    add_to_deck = function(self, card)
        if not G.GAME.hotpot_diy then
            G.FUNCS.overlay_menu({ definition = create_UIBox_diy() })
        end
    end
}

function create_UIBox_diy()
    local t = create_UIBox_generic_options({
        no_back = true,
        contents = {
            {
                n = G.UIT.R,
                config = { align = "cm" },
                nodes = {
                    UIBox_button({
                        button = "pointer_apply",
                        label = { localize("cry_code_create") },
                        minw = 4.5,
                        focus_args = { snap_to = true },
                    }),
                },
            },
        },
    })
    return t
end
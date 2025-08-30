SMODS.Stake{
    key = "wooden",
    colour = HPTN.C.BROWN,
    applied_stakes = { "gold" },
    shiny = false,
    unlocked = false,
    prefix_config = { applied_stakes = { mod = false} },
    loc_txt = {
        name = "Wooden Stake",
        text = {"Kills all vampires in your run"},
                sticker = {
                    name = "Wooden Sticker",
                    text = {"How did you even",
                            "get this?"}

                }
    },
    modifiers = function()
        G.GAME.modifiers.YOU_LOSE = true
    end,
    hotpot_credits = {
		art = { "GoldenLeaf" },
		idea = { "Corobo" },
		code = { "Revo" },
		team = { "Team Name" },
	},
}
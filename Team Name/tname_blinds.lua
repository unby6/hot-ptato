-- credits blind that makes you lose credits when a card is scored

SMODS.Atlas({ key = "TeamNameBlinds", path = "Team Name/tname_blinds.png", px = 34, py = 34, atlas_table = "ANIMATION_ATLAS", frames = 21})
SMODS.Atlas({ key = "TeamNameBlinds2", path = "Team Name/tname_blinds2.png", px = 34, py = 34, atlas_table = "ANIMATION_ATLAS", frames = 21})
SMODS.Blind {
    key = "holed",
    atlas = "TeamNameBlinds",
    pos = { x= 0, y = 0 },
    boss = { showdown = true },
    boss_colour = HEX("8a71e1"),
    recalc_debuff = function (self, card, from_blind)
        for k, _ in pairs(SMODS.Stickers) do
            if card.ability[k] == true then
                return false
            end
        end
        return true
    end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        idea = {"GoldenLeaf"},
        team = {"Team Name"}
    }
}

SMODS.Blind {
    key = "credential",
    atlas = "TeamNameBlinds2",
    pos = { x= 0, y = 0 },
    dollars = 5,
    mult = 2,
    boss = { showdown = false },
    boss_colour = HEX("8a71e1"),
    calculate = function (self, blind, context)
		if not blind.disabled and context.individual and context.cardarea == G.play then
            HPTN.ease_credits(1, false)
        end
    end,
    hotpot_credits = {
        art = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        idea = {"Revo"},
        team = {"Team Name"}
    }
}
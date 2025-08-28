
SMODS.Atlas({ key = "TeamNameBlinds", path = "Team Name/tname_blinds.png", px = 34, py = 34, atlas_table = "ANIMATION_ATLAS", frames = 21})
SMODS.Atlas({ key = "Fuck", path = "Team Name/tname_blinds2.png", px = 34, py = 34, atlas_table = "ANIMATION_ATLAS", frames = 21})
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
    boss = { min = 3 },
    calculate = function(self, blind, context)
        if not blind.disabled and context.press_play then
            HPTN.ease_credits(-5)
        end
    end,
    key = "credential",
    atlas = "Fuck",
    pos = { x= 0, y = 0 },
    dollars = 5,
    mult = 2,
    in_pool = function (self)
        if G.PROFILES[G.SETTINGS.profile].TNameCredits > 0 then
            return true
        end
        return false
    end,
    boss_colour = HEX("b7a2fd"),
    hotpot_credits = {
        art = {"GoldenLeaf"},
        code = {"GoldenLeaf"},
        idea = {"Revo"},
        team = {"Team Name"}
    }
}
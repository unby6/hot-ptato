SMODS.Atlas { key = "birthdayboy", path = "Pissdrawer/pdr_birthdayboy.png", px = 71, py = 95 }
SMODS.Joker {
    key = "birthdayboy",
    loc_txt = {
        name = "Birthday Boy",
        text = { "{E:1}Happy Birthday, N'!{}" }
    },
    hotpot_credits = {
        art = { "deadbeet" },
        code = { "deadbeet" },
        team = { "Pissdrawer" }
    },
    atlas = "birthdayboy",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    unlocked = true,
    discovered = true,
    rarity = 4,
    no_collection = true,
    in_pool = function(self, args)
        return false
    end
}

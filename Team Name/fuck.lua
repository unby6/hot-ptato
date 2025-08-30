
-- Fucking global thing to hold FUCKING EVERYTHING TEAM NAME
HPTN = {
    is_shitfuck = true,
    Profile = G.SETTINGS.profile
}
-- awesome lua file name
SMODS.Sound {
  key = "music_tname_off",
  path = "music_tname_off.ogg",
  pitch = 1,
  select_music_track = function (self)
    local bool = false
    if G.jokers then
        for i = 1, #G.jokers.cards do
            if G.jokers.cards[i].config.center.rarity == "hpot_creditable" then
                bool = true
            end
        end
    end
    if bool then
      return 999999
    end
  end
}

SMODS.Sound {
  key = "music_hanafuda",
  path = "music_hanafuda.ogg",
  pitch = 1,
  select_music_track = function (self)
    if not G.screenwipe and G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER and string.find(SMODS.OPENED_BOOSTER.config.center.key, "hanafuda", 0, true) ~= nil then
      return 1339
      end
  end
}
SMODS.Sound {
  key = "music_aura",
  pitch = 1,
  path = "music_aura.ogg",
  select_music_track = function (self)
    if not G.screenwipe and G.STATE == G.STATES.SMODS_BOOSTER_OPENED and SMODS.OPENED_BOOSTER and string.find(SMODS.OPENED_BOOSTER.config.center.key, "auras", 0, true) ~= nil then
      return 1339
    end
  end
}
SMODS.Sound {
  key = "music_windows95",
  pitch = 1,
  path = "music_windows95.ogg",
  select_music_track = function (self)
    if G.GAME.blind then
      local blind = G.GAME.blind -- current blind
      local key = blind.config.blind.key
      if key == "bl_hpot_bluescreen" then
        return 1e39
      end
    end
  end
}
SMODS.Sound {
  key = "music_casino",
  path = "music_casino.ogg",
  pitch = 1,
  select_music_track = function (self)
    if G.STATE == G.STATES.WHEEL then
      return 1349
    end
  end
}

SMODS.ObjectType({
  key = "CreditablePool"
})

SMODS.Rarity{
    key = "creditable",
    loc_txt = {name = "Creditable"},
    pools = {CreditablePool = true},
    badge_colour = G.C.PURPLE,
    default_weight = 0.05
}
SMODS.Atlas{key = "teamname_shitfuck", path = "Team Name/shitfuck.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_jokers", path = "Team Name/tname_jokers.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_jokers2", path = "Team Name/tname_jokers2.png", px = 71, py = 95} -- 2 joker atlases. Wow. just wow.
SMODS.Atlas{key = "tname_vouchers", path = "Team Name/TeamNameVouchers.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_boosters", path = "Team Name/tname_boosters.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_tags", path = "Team Name/tname_tags.png", px = 34, py = 34}
SMODS.Atlas{key = "tname_hanafuda", path = "Team Name/TeamNameHanafuda.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_seals", path = "Team Name/tname_seals.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_caps", path = "Team Name/tname_caps.png", px = 34, py = 34}
SMODS.Atlas{key = "tname_wheels", path = "Team Name/wip_wheel.png", px = 71, py = 95}
SMODS.Atlas{key = "tname_ads", path = "Ads/tname_TeamName.png", px = 200,py = 150,}

G.FUNCS.can_sell_card = function(e)
    if e.config.ref_table:can_sell_card() then 
        if e.config.ref_table.config.center.credits then
        e.config.colour = G.C.PURPLE
        e.config.button = 'sell_card'
        else
        e.config.colour = G.C.GREEN
        e.config.button = 'sell_card'
        end
    else
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
    end
end
SMODS.Atlas {
    key = "morb",
    path = "Jtem/plasmorbin_time.png",
    px = 40,
    py = 40
}

SMODS.Sound {
  key = "music_morbintime",
  path = "music_morbintime.ogg",
  select_music_track = function (self)
    if PlinkoLogic.STATE ~= PlinkoLogic.STATES.CLOSED and PlinkoUI.sprites.changed == "morb" then
      return 1339
    end
  end
}

SMODS.Atlas {
    key = "finityorb",
    path = "Jtem/finitorb.png",
    px = 40,
    py = 40
}

SMODS.Sound {
  key = "music_finity",
  path = "music_plinko_finity.ogg",
  select_music_track = function (self)
    if PlinkoLogic.STATE ~= PlinkoLogic.STATES.CLOSED and PlinkoUI.sprites.changed == "finity" then
      return 1340
    end
  end
}

SMODS.Sound {
  key = "ws_again",
  path = "sfx_again.ogg"
}

SMODS.Atlas {
  key = "jtemads",
  path = "Ads/Jtem.png",
  px = 200,py = 150
}

SMODS.Atlas {
  key = "jtemfuck",
  path = "Ads/fuck.png",
  px = 200,py = 150,
  frames = 16, atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas {
  key = "jtemrally",
  path = "Ads/rally.png",
  px = 240,py = 320,
  frames = 40, atlas_table = 'ANIMATION_ATLAS'
}


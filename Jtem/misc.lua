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
  key = "sfx_whistleup",
  path = "sfx_whistleup.ogg",
}

SMODS.Sound {
  key = "sfx_whistledown",
  path = "sfx_whistledown.ogg",
}

SMODS.Atlas {
  key = "jtem_pkg",
  path = "Jtem/package_icon.png",
  px = 34,py = 34
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
  key = "jtem_postlatro",
  path = "Jtem/postlatro.png",
  px = 113,py = 57,
  frames = 4, atlas_table = 'ANIMATION_ATLAS'
}

SMODS.Atlas {
  key = "jtem_aikoshen1",
  path = "Ads/aikoshenad1.png",
  px = 179,py = 97,
}

SMODS.Atlas {
  key = "jtemrally",
  path = "Ads/rally.png",
  px = 240,py = 320,
  frames = 40, atlas_table = 'ANIMATION_ATLAS'
}


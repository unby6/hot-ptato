SMODS.Sound {
  key = "sfx_tname_flip",
  path = "sfx_tname_flip.ogg",
}

SMODS.Sound {
  key = "music_reforge",
  path = "music_reforge_menu.ogg",
  select_music_track = function (self)
    if G.HP_TNAME_REFORGE_VISIBLE and G.STATE == G.STATES.SHOP then
      return 1349
    end
  end
}

SMODS.Sound {
  key = "tname_losecred",
  path = "sfx_creditslose.ogg",
}
SMODS.Sound {
  key = "tname_gaincred",
  path = "sfx_creditsgain.ogg",
}
SMODS.Sound {
  key = "tname_reforge",
  path = "sfx_reforge.ogg",
}
SMODS.Sound {
  key = "sfx_tname_flip",
  path = "sfx_tname_flip.ogg",
}

SMODS.Sound {
  key = "music_reforge",
  path = "music_reforge_menu.ogg",
  pitch = 1,
  select_music_track = function (self)
    if PissDrawer.Shop.active_tab == "hotpot_shop_tab_hotpot_tname_toggle_reforge" then
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


HPTN.C = {
	BROWN = HEX("916400"),
}

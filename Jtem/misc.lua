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
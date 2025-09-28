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


-- for iris select button

G.FUNCS.can_pull_card = function(e)
	local card = e.config.ref_table
	if #G.consumeables.cards < G.consumeables.config.card_limit then
		e.config.colour = G.C.RED
		e.config.button = "pull_card"
	else
		e.config.colour = G.C.UI.BACKGROUND_INACTIVE
		e.config.button = nil
	end
end
G.FUNCS.pull_card = function(e)
	local card = e.config.ref_table
	card.area:remove_card(card)
	card:add_to_deck()
	G.consumeables:emplace(card)
end
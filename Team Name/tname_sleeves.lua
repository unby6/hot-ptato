if next(SMODS.find_mod('CardSleeves')) then
  SMODS.Atlas {
    key = "TeamNameSleeves",
    path = "Team Name/TeamNameSleeves.png",
    px = 73,
    py = 95
  }

  CardSleeves.Sleeve {
    key = 'lime',
    atlas = 'TeamNameSleeves',
    pos = { x = 0, y = 0 },
    unlocked = false,
    unlock_condition = { deck = "b_hpot_lime", stake = "stake_white" },
    config = { plincoins = 5 },
    loc_vars = function(self, info_queue, card)
      local key = self.key
      if self.get_current_deck_key() == "b_hpot_lime" then
        key = self.key .. "_alt"
        self.config = { vouchers = { 'v_hpot_currency_exchange' } }
        return { key = key, vars = { localize({ type = 'name_text', set = 'Voucher', key = self.config.vouchers[1] }) } }
      else
        self.config = { plincoins = 5 }
        return { key = key, vars = { self.config.plincoins } }
      end
    end
  }

  local start_run_ref = Game.start_run
  function Game:start_run(args)
    start_run_ref(self, args)
    local found_sleeve = G.GAME.selected_sleeve and CardSleeves.Sleeve:get_obj(G.GAME.selected_sleeve)
    local starting_plincoins = found_sleeve and found_sleeve.config and found_sleeve.config.plincoins or 0
    G.GAME.starting_params.plincoins = G.GAME.starting_params.plincoins or 0
    G.GAME.starting_params.plincoins = G.GAME.starting_params.plincoins + starting_plincoins
    G.GAME.plincoins = G.GAME.plincoins or 0
    G.GAME.plincoins = G.GAME.plincoins + starting_plincoins
  end
end

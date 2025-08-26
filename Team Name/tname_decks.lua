SMODS.Atlas {
    key = "TeamNameDecks",
    path = "Team Name/TeamNameBacks.png",
    px = 71,
    py = 95
}

SMODS.Back {
    key = 'lime',
    atlas = 'TeamNameDecks',
    pos = { x = 0, y = 0 },
    config = { plincoins = 5 },
    loc_vars = function(self, info_queue, card)
        return { vars = { self.config.plincoins } }
    end
}

local start_run_ref = Game.start_run
function Game:start_run(args)
    start_run_ref(self, args)
    local starting_plincoins = G.GAME.selected_back and G.GAME.selected_back.effect and
    G.GAME.selected_back.effect.config and G.GAME.selected_back.effect.config.plincoins or 0
    G.GAME.starting_params.plincoins = G.GAME.starting_params.plincoins or 0
    G.GAME.starting_params.plincoins = G.GAME.starting_params.plincoins + starting_plincoins
    G.GAME.plincoins = G.GAME.plincoins or 0
    G.GAME.plincoins = G.GAME.plincoins + starting_plincoins
end

SMODS.Back {
    key = 'minimal',
    atlas = 'TeamNameDecks',
    pos = { x = 1, y = 0 }
}

-- Common utility functions

function ease_plincoins(plink)
  if plink > 0 and not next(find_joker('Tribcoin')) then
    G.GAME.plincoins = G.GAME.plincoins + plink
  elseif plink <= 0 then
    G.GAME.plincoins = G.GAME.plincoins + plink 
  end
end

local big_f = Card.flip
function Card:flip()
    if self.forever_flipped then
      return
    end
    big_f(self)
end

local cashout_row = add_round_eval_row
function add_round_eval_row(config)
    for i=1, #G.jokers.cards do
        local effects = eval_card(G.jokers.cards[i], {pk_cashout_row = config})
        if effects.jokers then
          config = effects.jokers.new_config
          --do your own card_eval_status_text
        end
    end
    return cashout_row(config)
end

function show_shop()
    if G.shop and G.shop.alignment.offset.py then 
      G.shop.alignment.offset.y = G.shop.alignment.offset.py
      G.shop.alignment.offset.py = nil
    end
end

function hide_shop()
    if G.shop and not G.shop.alignment.offset.py then
      G.shop.alignment.offset.py = G.shop.alignment.offset.y
      G.shop.alignment.offset.y = G.ROOM.T.y + 29
    end
end
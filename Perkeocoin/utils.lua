
-- Common utility functions

--its ease_dollars for plincoins
function ease_plincoins(plink)
  if plink > 0 and not next(find_joker('Tribcoin')) then
    G.GAME.plincoins = G.GAME.plincoins + plink
  elseif plink <= 0 then
    G.GAME.plincoins = G.GAME.plincoins + plink 
  end
end

--flipping cards, like in Amber Acorn, The Wheel, and Xray challenge
--this function hooks the flip and checks a bool, then terminates if true
--disallow cards to be flipped by setting [card].forever_flipped to true
--make sure it's in the correct facing direction *before* setting this
local big_f = Card.flip
function Card:flip()
    if self.forever_flipped then
      return
    end
    big_f(self)
end

--two new contexts for the cashout screen, called once for every row and one more time for the final added amount
--pk_cashout_row is for changing the values whereas pk_cashout_row_but_just_looking is for reading them after the changes
--check context.pk_cashout_row.dollars for the amounts 
--check context.pk_cashout_row.name for if its the total amount or not (== 'bottom' for total, ~= for individual rows)
local cashout_row = add_round_eval_row
function add_round_eval_row(config)
    for i=1, #G.jokers.cards do
        local effects = eval_card(G.jokers.cards[i], {pk_cashout_row = config})
        if effects.jokers then
          config = effects.jokers.new_config
          --do your own card_eval_status_text
        end
    end
    for i=1, #G.jokers.cards do
        eval_card(G.jokers.cards[i], {pk_cashout_row_but_just_looking = config})
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
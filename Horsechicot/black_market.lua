function G.UIDEF.hotpot_horsechicot_market_section()
    G.GAME.shop.market_joker_max = G.GAME.shop.market_joker_max or 4
    G.market_jokers = CardArea(
      G.hand.T.x+0,
      G.hand.T.y+G.ROOM.T.y + 9,
      math.min(G.GAME.shop.market_joker_max*1.02*G.CARD_W,4.08*G.CARD_W),
      1.05*G.CARD_H, 
      {card_limit = G.GAME.shop.market_joker_max, type = 'shop', highlight_limit = 1, negative_info = true})
    if not G.GAME.market_filled then
        G.GAME.market_filled = true
        for i = 1, G.GAME.shop.market_joker_max - #G.market_jokers.cards do
            local new_shop_card = SMODS.create_card{set = "BlackMarket", area = G.market_jokers}
            G.market_jokers:emplace(new_shop_card)
            create_market_card_ui(new_shop_card)
            new_shop_card:juice_up()
            return true
        end
    end
	return {n = G.UIT.R, config = {minw = 3, minh = .5, colour = G.C.CLEAR}, nodes = {}},
    {n=G.UIT.R, config={align = "cm", padding = 0.05}, nodes={
        {n=G.UIT.C, config={align = "cm", padding = 0.1}, nodes={
          {n=G.UIT.R, config={align = "cm", minw = 2.8, minh = 1.6, r=0.15,colour = G.C.ORANGE, button = 'reroll_market', func = 'can_reroll_market', hover = true,shadow = true}, nodes = {
            {n=G.UIT.R, config={align = "cm", padding = 0.07, focus_args = {button = 'x', orientation = 'cr'}, func = 'set_button_pip'}, nodes={
              {n=G.UIT.R, config={align = "cm", maxw = 1.3}, nodes={
                {n=G.UIT.T, config={text = localize('k_reroll'), scale = 0.4, colour = G.C.WHITE, shadow = true}},
              }},
              {n=G.UIT.R, config={align = "cm", maxw = 1.3, minw = 1}, nodes={
                {n=G.UIT.T, config={text = "B.", scale = 0.7, colour = G.C.WHITE, shadow = true}},
                {n=G.UIT.T, config={ref_table = G.GAME.current_round, ref_value = 'market_reroll_cost', scale = 0.75, colour = G.C.WHITE, shadow = true}},
              }}
            }}
          }},
        }},
        {n=G.UIT.C, config={align = "cm", padding = 0.2, r=0.2, colour = G.C.L_BLACK, emboss = 0.05, minw = 8.2}, nodes={
            {n=G.UIT.O, config={object = G.market_jokers}},
        }},
    }},
    {n = G.UIT.R, config = {minw = 3, minh = 3.5, colour = G.C.CLEAR}, nodes = {}}
end

G.FUNCS.hotpot_horsechicot_toggle_market = function () -- takn from deliveries
    if (G.CONTROLLER.locked or G.CONTROLLER.locks.frame or (G.GAME and (G.GAME.STOP_USE or 0) > 0)) then return end
    stop_use()
    local sign_sprite = G.SHOP_SIGN.UIRoot.children[1].children[1].children[1].config.object
    if not G.HP_HC_MARKET_VISIBLE then
        --starting market
		ease_background_colour({new_colour = G.C.BLACK, special_colour = darken(G.C.BLACK,0.6), tertiary_colour = darken(G.C.BLACK,0.4), contrast = 3})
        G.shop.alignment.offset.y = -46.3
        G.HP_HC_MARKET_VISIBLE = true
		simple_add_event(function()
            sign_sprite.pinch.y = true
            delay(0.5)
            simple_add_event(function()
                sign_sprite.atlas = G.ANIMATION_ATLAS["hpot_tname_shop_sign"]
                sign_sprite.pinch.y = false
                return true
            end)
            return true
        end, { trigger = "after", delay = 0 })
        play_sound("hpot_sfx_whistleup", 1.3, 0.25)
    else
        --exiting market
        ease_background_colour_blind(G.STATES.SHOP)
        G.shop.alignment.offset.y = -5.3
        G.HP_HC_MARKET_VISIBLE = false
        G.FUNCS.market_return()
		simple_add_event(function()
            sign_sprite.pinch.y = true
            delay(0.5)
            simple_add_event(function()
                sign_sprite.atlas = G.ANIMATION_ATLAS["shop_sign"]
                sign_sprite.pinch.y = false
                return true
            end)
            return true
        end, { trigger = "after", delay = 0 })
        play_sound("hpot_sfx_whistledown", 1.3, 0.25)
    end
end

G.FUNCS.market_return = function ()

end

local start_run_ref = Game.start_run
function Game:start_run(args)
    local ret = start_run_ref(self, args)
    local saveTable = args.savetext or nil
    if not saveTable then
        G.GAME.cryptocurrency = 0
        G.GAME.current_round.market_reroll_cost = 1
    end
    return ret
end

function ease_cryptocurrency(plink, instant)
    local function _mod(mod)
          local dollar_UI = G.HUD:get_UIE_by_ID('crypto_text_UI')
          mod = mod or 0
          local text = '+B.'
          local col = G.C.MONEY
          if mod < 0 then
              text = '-B.'
              col = G.C.RED
          end
  
          G.GAME.cryptocurrency = G.GAME.cryptocurrency + plink
      
          dollar_UI.config.object:update()
          G.HUD:recalculate()
          --Popup text next to the chips in UI showing number of chips gained/lost
          attention_text({
            text = text..tostring(math.abs(mod)),
            scale = 0.8, 
            hold = 0.7,
            cover = dollar_UI.parent,
            cover_colour = G.C.ORANGE,
            align = 'cm',
            })
          --Play a chip sound
          play_sound('coin1')
      end
      if instant then
          _mod(plink)
      else
          G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          func = function()
              _mod(plink)
              return true
          end
          }))
      end
  end

  G.FUNCS.can_reroll_market = function(e)
    if ((G.GAME.cryptocurrency) - G.GAME.current_round.market_reroll_cost < 0) and G.GAME.current_round.market_reroll_cost ~= 0 then 
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'reroll_market'
    end
end

G.FUNCS.reroll_market = function(e) 
    stop_use()
    G.CONTROLLER.locks.shop_reroll = true
    if G.CONTROLLER:save_cardarea_focus('market_jokers') then G.CONTROLLER.interrupt.focus = true end
    local market_reroll_cost = G.GAME.current_round.market_reroll_cost
    if G.GAME.current_round.market_reroll_cost > 0 then 
      ease_dollars(-G.GAME.current_round.market_reroll_cost)
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
          G.GAME.current_round.market_reroll_cost = G.GAME.current_round.market_reroll_cost + 1
          for i = #G.market_jokers.cards,1, -1 do
            local c = G.market_jokers:remove_card(G.market_jokers.cards[i])
            c:remove()
            c = nil
          end

          --save_run()

          play_sound('coin2')
          play_sound('other1')
          
--  
            for i = 1, G.GAME.market.joker_max - #G.market_jokers.cards do
                local new_market_card = SMODS.create_card{set = "BlackMarket", area = G.market_jokers}
                G.market_jokers:emplace(new_market_card)
                create_market_card_ui(new_market_card)
                new_market_card:juice_up()
            end
--
            return true
        end
      }))
      G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.3,
        func = function()
        G.E_MANAGER:add_event(Event({
          func = function()
            G.CONTROLLER.interrupt.focus = false
            G.CONTROLLER.locks.shop_reroll = false
            G.CONTROLLER:recall_cardarea_focus('market_jokers')
            SMODS.calculate_context({reroll_market = true, cost = reroll_cost})
            return true
          end
        }))
        return true
      end
    }))
    G.E_MANAGER:add_event(Event({ func = function() save_run(); return true end}))
end

function Card:get_market_cost()
    return 1
end

function create_market_card_ui(card, type, area)
    card.market_cost = card:get_market_cost()

end


G.FUNCS.can_buy_from_market = function(e)
    if (e.config.ref_table.market_cost > G.GAME.cryptocurrency) and (e.config.ref_table.market_cost > 0) then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.ORANGE
        e.config.button = 'buy_from_shop'
    end
    if e.config.ref_parent and e.config.ref_parent.children.buy_and_use then
      if e.config.ref_parent.children.buy_and_use.states.visible then
        e.UIBox.alignment.offset.y = -0.6
      else
        e.UIBox.alignment.offset.y = 0
      end
    end
end

G.FUNCS.can_buy_and_use_from_market = function(e)
    if (((e.config.ref_table.market_cost > G.GAME.cryptocurrency) and (e.config.ref_table.market_cost > 0)) or (not e.config.ref_table:can_use_consumeable())) then
        e.UIBox.states.visible = false
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        if e.config.ref_table.highlighted then
          e.UIBox.states.visible = true
        end
        e.config.colour = G.C.SECONDARY_SET.Voucher
        e.config.button = 'buy_from_shop'
    end
end

G.FUNCS.can_redeem_from_market = function(e)
  if (e.config.ref_table.market_cost > G.GAME.cryptocurrency) and (e.config.ref_table.market_cost > 0) then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else
    e.config.colour = G.C.GREEN
    e.config.button = 'use_card'
  end
end

G.FUNCS.can_open_from_market = function(e)
  if (e.config.ref_table.market_cost > G.GAME.cryptocurrency) and (e.config.ref_table.market_cost > 0) then
      e.config.colour = G.C.UI.BACKGROUND_INACTIVE
      e.config.button = nil
  else
    e.config.colour = G.C.GREEN
    e.config.button = 'use_card'
  end
end

SMODS.ObjectType {
    key = 'BlackMarket',
    default = "c_wraith"
}
Horsechicot = {}
function Horsechicot.credit(coders, arters, ideaers)
    if type(coders) == "string" then
        coders = { coders }
    end
    if type(arters) == "string" then
        arters = { arters }
    end
    if type(ideaers) == "string" then
        ideaers = { ideaers }
    end
    return {
        code = coders,
        art = arters,
        idea = ideaers,
        team = { 'Horsechicot' }
    }
end

SMODS.Atlas { key = "hc_jokers", path = "Horsechicot/hc_jokers.png", px = 71, py = 95 }
SMODS.Atlas { key = "hc_decks", path = "Horsechicot/hc_decks.png", px = 71, py = 95 }
SMODS.Atlas { key = "hc_boosters", path = "Horsechicot/hc_boosters.png", px = 71, py = 95 }
SMODS.Atlas { key = "hc_vouchers", path = "Horsechicot/hc_vouchers.png", px = 71, py = 95 }
SMODS.Atlas { key = "hc_placeholder", path = "Horsechicot/placeholders.png", px = 71, py = 95 }
SMODS.Atlas { key = "hc_consumables", path = "Horsechicot/hc_consumables.png", px = 71, py = 95 }


SMODS.Atlas {
    key = "horsechicot_market",
    path = "Horsechicot/shop_button.png",
    px = 34, py = 34,
}

SMODS.Atlas {
    key = "hc_tags",
    path = "Horsechicot/hc_tags.png",
    px = 34, py = 34,
}

SMODS.Sound {
    key = "music_market",
    path = "music_market.ogg",
    select_music_track = function(self)
        if PissDrawer.Shop.active_tab == "hotpot_shop_tab_hotpot_horsechicot_toggle_market" or (G.hpot_event and G.HP_HC_MARKET_VISIBLE) then
            return 1325
        end
    end,
    hpot_title = "Black Market Theme",
    hpot_artist = "???", -- Someone fill this up
    hpot_purpose = {
        "Music that plays in",
        "the Black Market"
    },
    hotpot_credits = Horsechicot.credit()
}


SMODS.Atlas {
    key = "hc_plinkos",
    path = "Horsechicot/plinkos.png",
    px = 40, py = 40,
}

function Horsechicot:calculate(context)
    if context.end_of_round then
        G.GAME.bm_bought_this_round = false
    end
end

local oldfunc = Game.main_menu
Game.main_menu = function(change_context)
    local ret = oldfunc(change_context)
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0,
        blockable = false,
        blocking = false,
        func = function()
            local newcard = Card(
                G.title_top.T.x,
                G.title_top.T.y,
                G.CARD_W,
                G.CARD_H,
                G.P_CARDS.empty,
                G.P_CENTERS.j_hpot_thetruehotpotato,
                { bypass_discovery_center = true }
            )
            -- recenter the title
            G.title_top.T.w = G.title_top.T.w * 1.7675
            G.title_top.T.x = G.title_top.T.x - 0.8
            G.title_top:emplace(newcard)
            -- make the card look the same way as the title screen Ace of Spades
            newcard.T.w = newcard.T.w * 1.1 * 1.2
            newcard.T.h = newcard.T.h * 1.1 * 1.2
            newcard.no_ui = true
            newcard.states.visible = false
            if change_context == "splash" then
                newcard.states.visible = true
                newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
            else
                newcard.states.visible = true
                newcard:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
            end
            return true
        end
    }))
    jokerOrder = {}
    for i, v in ipairs(G.P_CENTER_POOLS.Joker) do
        jokerOrder[v.key] = i
    end
    return ret
end

function HotPotato.get_blind_font(blind)
    if blind and (blind.name == "bl_hpot_quartz" or (blind.config and blind.config.name == "bl_hpot_quartz")) then
        return SMODS.Fonts['hpot_plincoin']
    end
end

local post_loaded = false
function Horsechicot.post_load()
    local cards = {
        c_death = true,
        c_hanged_man = true,
    }
    local sets = {
        Spectral = true,
        Omen = true,
    }
    for i, v in pairs(G.P_CENTERS) do
        if (v.set == "Joker" and v.rarity == 3) or (sets[v.set]) then
            cards[i] = true
        end
    end

    for k, v in pairs(G.P_CENTERS) do
        if v.set == 'Booster' and (string.find(k, string.lower("ultra")) ~= nil or string.find(k, string.lower("mega")) ~= nil) then
            cards[k] = true
        end
    end

    SMODS.ObjectType {
        key = 'BlackMarket',
        default = "c_wraith",
        cards = cards
    }

    if not post_loaded then
        post_loaded = true
        SMODS.ObjectTypes.BlackMarket:inject()
        local old = end_round
        function end_round()
            if not G.round_end_lock then
                G.round_end_lock = true
                old()
                G.E_MANAGER:add_event(Event { func = function()
                    G.round_end_lock = false
                    return true
                end })
            end
        end
    end
end

local loadmodsref = SMODS.injectItems
function SMODS.injectItems(...)
    loadmodsref(...)
    Horsechicot.post_load()
end

function HotPotato.reload_localization()
    SMODS.handle_loc_file(HotPotato.path)
    return init_localization()
end

SMODS.Atlas { key = "hcbananaad", path = "Ads/BananaAd.png", px = 169, py = 55 }
SMODS.Atlas { key = "hcnumberslop", path = "Ads/numberslop.png", px = 169, py = 55 }
SMODS.Atlas { key = "hcred", path = "Ads/red.png", px = 169, py = 55 }
SMODS.Atlas { key = "hcmustard", path = "Ads/mustard.png", px = 169, py = 55 }
SMODS.Atlas { key = "hcwindows", path = "Ads/WindowDeck.png", px = 154, py = 139 }
SMODS.Atlas { key = "hpot_hchorseyworseys", path = "Ads/Horseys.png", px = 200, py = 150 }

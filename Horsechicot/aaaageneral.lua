Horsechicot = {}
function Horsechicot.credit(coders, arters, ideaers)
    if type(coders) == "string" then
        coders = {coders}
    end
    if type(arters) == "string" then
        arters = {arters}
    end
    if type(ideaers) == "string" then
        arters = {ideaers}
    end
    return {
        code = coders,
        art = arters,
        idea = ideaers,
        team = { 'Horsechicot' }
    }
end

local function mod_exists(id)
    local m = SMODS.find_mod(id)
    if m[1] and m[1].can_load then
        return true
    end
end

SMODS.Atlas{key = "hc_jokers", path = "Horsechicot/hc_jokers.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_decks", path = "Horsechicot/hc_decks.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_boosters", path = "Horsechicot/hc_boosters.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_vouchers", path = "Horsechicot/hc_vouchers.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_placeholder", path = "Horsechicot/placeholders.png", px=71, py=95}

local Username = G.PROFILES[G.SETTINGS.profile].name

HPJTTT.add_texts({
    "and now... a word from our Sponsor. Entropy.",
    "Attempt to compare Joker with Table",
    "Now in 3D",
    TMJ and "Thanks for using Too Many Jokers! ~ cg" or "Use Too Many Jokers! ~ cg", --tmj prio is lower
    "Cassoosted Fuper",
    "Splipped Droost",
    "mb6fbhsphdrcb",
    "Spinner Stunning",
    "JTA",
    "Bubsdrop",
    "BIS",
    "Backboost",
    "silly ahh drivables - @lily.felli",
    "130 lbs",
    "Niko: She's 10. Can I Mate?",
    CardPronouns and "This is so woke!" or "Uhh.... install CardPronouns!", --cprns prio is  literally -99 million :3
    "awawa awebo",
    "I wish shadows had rights",
    "The cat atop the far tree whispers sweet promises to passerbys",
    "I think we should stop having money. That sounds like a good thing.",
    "One or two extra currencies",
    "Shoutouts to gay foxgirls",
    "In a Cargo Box?",
    Username .. ", Stay Determined!",
    "It's over, " .. Username .. " knows.",
    "Two Hotties, One potato.",
    "-- TODO: your mom",
    Entropy and "You are not immune to Propaganda" or "generic message", --holes bad? 
    "The Oldest Anarchy Mod In Balatro",
    "D1D7",
    "smots gaming",
    "Tip number 10: Sit at the chessboard and play with yourself"
})

SMODS.Atlas{
    key = "horsechicot_market",
    path = "Horsechicot/shop_button.png",
    px = 34, py = 34,
}

SMODS.Atlas{
    key = "hc_tags",
    path = "Horsechicot/hc_tags.png",
    px = 34, py = 34,
}

SMODS.Sound {
    key = "music_market",
    path = "music_market.ogg",
    select_music_track = function (self)
      if G.HP_HC_MARKET_VISIBLE then
        return 1225
      end
    end
}


SMODS.Atlas {
    key = "hc_plinkos",
    path = "Horsechicot/plinkos.png",
    px = 40,py = 40,
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
    return ret
end

function HotPotato.get_blind_font(blind)
    if blind and (blind.name == "bl_hpot_quartz" or (blind.config and blind.config.name == "bl_hpot_quartz")) then
        return SMODS.Fonts['hpot_plincoin']
    end
end

function Horsechicot.post_load()
    local cards = {
        c_death = true,
        c_hanged_man = true,
        p_hpot_czech_ultra_1 = true,
        p_hpot_hanafuda_ultra_1 = true,
        p_hpot_auras_ultra_1 = true,
        p_hpot_ultra_arcana = true,
        p_hpot_ultra_celestial = true,
        p_hpot_ultra_standard = true,
        p_hpot_ultra_buffoon = true,
        p_hpot_ultra_spectral = true,
        p_hpot_team_ultra_1 = true,
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


    SMODS.ObjectType {
        key = 'BlackMarket',
        default = "c_wraith",
        cards = cards
    }
    SMODS.ObjectTypes.BlackMarket:inject()
    
    local old = end_round
    function end_round()
        if not G.round_end_lock then
            G.round_end_lock = true
            old()
            G.E_MANAGER:add_event(Event{func = function() G.round_end_lock = false return true end})
        end
    end
end


local loadmodsref = SMODS.injectItems
function SMODS.injectItems(...)
    loadmodsref(...)
    Horsechicot.post_load()
end

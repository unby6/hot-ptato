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
SMODS.Atlas{key = "hc_jokers", path = "Horsechicot/hc_jokers.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_boosters", path = "Horsechicot/hc_boosters.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_vouchers", path = "Horsechicot/hc_vouchers.png", px = 71, py = 95}
SMODS.Atlas{key = "hc_placeholder", path = "Horsechicot/placeholders.png", px=71, py=95}

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
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "silly ahh drivables - @lily.felli",
    "130 lbs",
    "Niko: She's 10. Can I Mate?"
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
    if context.end_round then
        G.GAME.bm_bought_this_round = false
    end
end
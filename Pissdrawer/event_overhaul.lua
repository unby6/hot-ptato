-- TODO: maybe make these an SMODS object.
HotPotato.EventDomainPool = {
    { key = "combat",       weight = 1,    colour = G.C.RED },
    { key = "occurence",    weight = 1,    colour = G.C.PURPLE },
    { key = "encounter",    weight = 0.7,  colour = darken(G.C.RED, 0.2) },
    { key = "transaction",  weight = 0.5,  colour = G.C.GREEN },
    { key = "reward",       weight = 0.4,  colour = G.C.HPOT_PINK or HEX("fe89d0"), rare = true },
    { key = "adventure",    weight = 0.2,  colour = G.C.ORANGE,                     rare = true },
    { key = "wealth",       weight = 0.2,  colour = G.C.MONEY,                      rare = true },
    { key = "escapade",     weight = 0.01, colour = HEX("A17CFF"),                  rare = true, once_per_run = true },
    { key = "respite",      weight = 0,    colour = G.C.GREEN },
    { key = "aroombetween", weight = 0.01, colour = HEX("DE2041"),                  rare = true, once_per_run = true },
}

HotPotato.EventDomains = {}

-- TODO: do this on initialization instead for crossmod stuff
for _, domain in ipairs(HotPotato.EventDomainPool) do
    HotPotato.EventDomains[domain.key] = domain
end

function hpot_event_domain_add_to_pool(domain, args)
    local args = args or {}
    local domain = type(domain) == "string" and HotPotato.EventDomains[domain] or domain

    if type(domain) ~= "table" then
        return false
    end

    local add, pool_opts = true, {}

    if type(domain.in_pool) == "function" then
        add, pool_opts = domain:in_pool(args)
        pool_opts = pool_opts or {}
    end

    local allow_duplicates = (not args.ignore_showman and SMODS.showman("hpot_event_" .. domain.key)) or
        args.allow_duplicates or pool_opts.allow_duplicates

    if domain.once_per_run and not args.ignore_once_per_run
        and G.GAME.hpot_event_domains_this_run and G.GAME.hpot_event_domains_this_run[domain.key] then
        return false
    end

    return add and
        (allow_duplicates or not (G.GAME.hpot_event_domain_choices_used or {})[domain.key])
end

function hpot_event_get_domain_pool(args)
    local args = args or {}
    local options = args.options or HotPotato.EventDomainPool
    local pool = {}

    for _, domain in ipairs(options) do
        if hpot_event_domain_add_to_pool(domain, args) then
            pool[#pool + 1] = type(domain) == "string" and HotPotato.EventDomains[domain] or domain
        end
    end

    if #pool == 0 then
        pool[#pool + 1] = HotPotato.EventDomains.occurence
    end

    return pool
end

function hpot_event_get_domain_weight(domain, args)
    local args = args or {}
    local domain = type(domain) == "string" and HotPotato.EventDomains[domain] or domain

    local weight = type(domain.get_weight) == "function" and domain:get_weight(args) or domain.weight or 1

    if domain.rare and next(SMODS.find_card("j_hpot_ruan_mei")) then
        weight = weight * 2
    end

    return weight
end

function hpot_event_get_event_domain(args)
    local args = args or {}

    if not args.ignore_respite and (G.GAME.round_resets.ante) % G.GAME.win_ante == 0
        and G.GAME.round_resets.blind.key == "bl_big" then
        return "respite"
    end

    local options = hpot_event_get_domain_pool(args)

    local total_weight = 0

    for _, domain in ipairs(options) do
        local weight = type(domain.get_weight) == "function" and domain:get_weight(args) or domain.weight or 1
        total_weight = total_weight + weight
    end

    local domain_poll = pseudorandom(args.key or 'hpot_domain_generic')
    local weight_i = 0
    for _, domain in ipairs(options) do
        local weight = type(domain.get_weight) == "function" and domain:get_weight(args) or domain.weight or 1
        weight_i = weight_i + weight
        if domain_poll > 1 - (weight_i / total_weight) then
            return domain.key
        end
    end
end

function hpot_event_get_event_count(args)
    local args = args or {}
    if not args.ignore_respite and (G.GAME.round_resets.ante) % G.GAME.win_ante == 0
        and G.GAME.round_resets.blind.key == "bl_big" then
        return 1
    end
    if next(SMODS.find_card("j_hpot_local_newspaper")) then
        return 3
    end
    return 2
end

-- TODO: test any weird blind choice cases or, better yet, PR SMODS a better blind tracker
function hpot_event_can_appear(blind_prototype)
    if G.GAME.hpot_event_enable_all_blinds or type(blind_prototype) ~= "table" then return true end
    if (G.GAME.round_resets.ante) % G.GAME.win_ante == 0 and blind_prototype.key == "bl_big" then
        return true
    end
    if blind_prototype.key == "bl_big" and G.GAME.hpot_event_enable_big_blind then
        return true
    end
    if blind_prototype.key == "bl_small" and G.GAME.hpot_event_enable_small_blind then
        return true
    end
    return not not blind_prototype.boss
end

--- Event Cards

-- Local Newspaper
SMODS.Joker {
    key = 'local_newspaper',
    rarity = 2,
    cost = 6,
    atlas = "pdr_joker",
    pos = { x = 1, y = 0 },
    hotpot_credits = {
        art = { 'Tacashumi' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    }
}

-- Ruan Mei
SMODS.Joker {
    key = 'ruan_mei',
    rarity = 3,
    cost = 8,
    atlas = "pdr_joker",
    pos = { x = 1, y = 3 },
    hotpot_credits = {
        art = { 'BepisFever' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    }
}

-- Domain Extrapolation
SMODS.Voucher {
    key = 'domain_extrapolation',
    pos = { x = 7, y = 0 },
    hotpot_credits = {
        --art = { 'SDM_0' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    },
    redeem = function(self, voucher)
        G.GAME.hpot_event_enable_big_blind = true
    end
}

-- Domain Expansion
SMODS.Voucher {
    key = 'domain_expansion',
    requires = { "v_hpot_domain_extrapolation" },
    pos = { x = 7, y = 0 },
    hotpot_credits = {
        --art = { 'SDM_0' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    },
    redeem = function(self, voucher)
        G.GAME.hpot_event_enable_all_blinds = true
    end
}

--#region Combat

-- based on Bonus Blinds <3
function hpot_event_bonus_new_round(blind_key, extra_config)
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
            G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0

            local blhash = 'S'
            G.GAME.subhash = (G.GAME.round_resets.ante) .. (blhash)

            G.GAME.blind_on_deck = 'Combat'
            G.GAME.blind:set_blind(G.P_BLINDS[blind_key])
            G.GAME.blind.effect.hpot_combat_bonus = extra_config or {}
            G.GAME.last_blind.boss = nil
            G.HUD_blind.alignment.offset.y = -10
            G.HUD_blind:recalculate(false)

            SMODS.calculate_context({ setting_blind = true, blind = G.P_BLINDS[blind_key] })
            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('hpot_nr' .. G.GAME.round_resets.ante)
                    G.deck:hard_set_T()
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
        end
    }))
end

function hpot_event_start_combat(key, override_blind, extra_config)
    if HotPotato.CombatEvents[key] then
        hpot_event_end_scenario(true)
        G.GAME.hpot_combat_event = key
        hpot_event_bonus_new_round(override_blind or HotPotato.CombatEvents[key].blind_key, extra_config)
    else
        hpot_event_end_scenario()
    end
end

local blind_defeat_ref = Blind.defeat
function Blind:defeat(silent)
    blind_defeat_ref(self, silent)
    if G.GAME.hpot_combat_event then
        if type(HotPotato.CombatEvents[G.GAME.hpot_combat_event].defeat) == "function" then
            HotPotato.CombatEvents[G.GAME.hpot_combat_event]:defeat()
        end
    end
end

--#endregion

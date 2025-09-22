-- I will probably move all this to the other event file eventually

HotPotato.EventDomainPool = {
    { key = "combat",      weight = 1,   colour = G.C.RED },
    { key = "occurence",   weight = 1,   colour = G.C.PURPLE },
    { key = "encounter",   weight = 0.7, colour = darken(G.C.RED, 0.2) },
    { key = "transaction", weight = 0.5, colour = G.C.GREEN },
    { key = "reward",      weight = 0.4, colour = G.C.HPOT_PINK or HEX("fe89d0"), rare = true },
    { key = "adventure",   weight = 0.2, colour = G.C.ORANGE,                     rare = true },
    { key = "wealth",      weight = 0.2, colour = G.C.MONEY,                      rare = true },
    { key = "escapade",    weight = 0.1, colour = HEX("A17CFF"),                  rare = true },
    { key = "respite",     weight = 0,   colour = G.C.GREEN },
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

    return add and
        (args.allow_duplicates or pool_opts.allow_duplicates or not (G.GAME.hpot_event_domain_choices_used or {})[domain.key])
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
    if next(SMODS.find_card("j_hpot_local_newspaper")) then
        return 3
    end
    return 2
end

-- TODO: test any weird blind choice cases or, better yet, PR SMODS a better blind tracker
function hpot_event_can_appear(blind_prototype)
    if G.GAME.hpot_event_enable_all_blinds or type(blind_prototype) ~= "table" then return true end
    if blind_prototype.key == "bl_big" and G.GAME.hpot_event_enable_big_blind then
        return true
    end
    if blind_prototype.boss and G.GAME.hpot_event_enable_boss_blind then
        return true
    end
    return blind_prototype.key == "bl_small"
end

--- Event Cards

-- Local Newspaper
SMODS.Joker {
    key = 'local_newspaper',
    rarity = 1,
    cost = 5,
    atlas = "pdr_joker",
    pos = { x = 0, y = 0 },
    hotpot_credits = {
        art = { 'SDM_0' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    }
}

-- Ruan Mei
SMODS.Joker {
    key = 'ruan_mei',
    rarity = 1,
    cost = 5,
    atlas = "pdr_joker",
    pos = { x = 0, y = 0 },
    hotpot_credits = {
        art = { 'SDM_0' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    }
}

-- Domain Extrapolation
SMODS.Voucher {
    key = 'domain_extrapolation',
    hotpot_credits = {
        --art = { 'SDM_0' },
        code = { "N'" },
        idea = { "N'" },
        team = { 'Pissdrawer' }
    },
    redeem = function(self, voucher)
        G.GAME.hpot_event_enable_boss_blind = true
    end
}

-- Domain Expansion
SMODS.Voucher {
    key = 'domain_expansion',
    requires = { "v_hpot_domain_extrapolation" },
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

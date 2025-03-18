--- STEAMODDED HEADER
--- MOD_NAME: Art Mod
--- MOD_ID: ArtMod
--- MOD_AUTHOR: [Artem Korotkyy]
--- MOD_DESCRIPTION: Artems Korotkyy mod for fun)))
--- DISPLAY_NAME: ArtMod
--- BADGE_COLOUR: 5c5c5c
--- VERSION: 1.0
----------------------------------------------
------------MOD CODE -------------------------

-- Config: DISABLE UNWANTED MODS HERE
local config = {
    BulletproofDeck = true,


    CrystalVeilSpectral = true,
    GlassMoneyTarot = true,


    guitarJoker = false,
    BulletproofJoker = true,
    JokerShards = true,
    Mirror = true,
    AntiGlassJoker = true,
    Glassmaster = true,
    Glassnovice = true,
    CommonJoker = true,
    CrystalJuggler = true,
    AntimaterialJoker = true,
    DeMorraJoker = true,
}

-- Helper functions
local function init_joker(joker, no_sprite)
    no_sprite = no_sprite or false

    local new_joker = SMODS.Joker:new(
        joker.ability_name,
        joker.slug,
        joker.ability,
        { x = 0, y = 0 },
        joker.loc,
        joker.rarity,
        joker.cost,
        joker.unlocked,
        joker.discovered,
        joker.blueprint_compat,
        joker.eternal_compat,
        joker.effect,
        joker.atlas,
        joker.soul_pos
    )
    new_joker:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_joker.slug,
            SMODS.findModByID("ArtMod").path,
            new_joker.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

local function init_tarot(tarot, no_sprite)
    no_sprite = no_sprite or false

    local new_tarot = SMODS.Tarot:new(
        tarot.name,
        tarot.slug,
        tarot.config,
        { x = 0, y = 0 },
        tarot.loc,
        tarot.cost,
        tarot.cost_mult,
        tarot.effect,
        tarot.consumeable,
        tarot.discovered,
        tarot.atlas
    )
    new_tarot:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_tarot.slug,
            SMODS.findModByID("ArtMod").path,
            new_tarot.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

local function init_spectral(spectral, no_sprite)
    no_sprite = no_sprite or false

    local new_spectral = SMODS.Spectral:new(
        spectral.name,
        spectral.slug,
        spectral.config,
        { x = 0, y = 0 },
        spectral.loc,
        spectral.cost,
        spectral.consumeable,
        spectral.discovered,
        spectral.atlas
    )
    new_spectral:register()

    if not no_sprite then
        local sprite = SMODS.Sprite:new(
            new_spectral.slug,
            SMODS.findModByID("ArtMod").path,
            new_spectral.slug .. ".png",
            71,
            95,
            "asset_atli"
        )
        sprite:register()
    end
end

local original_start_run = Game.start_run

function Game:start_run(args)
    original_start_run(self, args)

    local jokershards = SMODS.find_card('j_artm_jokershards')
    local bulletproofjoker = SMODS.find_card('j_artm_bulletproofjoker')
    for _, card in ipairs(jokershards) do
        G.P_CENTERS.m_glass.config.Xmult = G.P_CENTERS.m_glass.config.Xmult + card.ability.extra.xmult
    end
    if #jokershards >= 1 and #bulletproofjoker == 0 then
        G.GAME.probabilities.glass_prob = G.GAME.probabilities.glass_prob + G.P_CENTERS['j_artm_jokershards'].ability.extra.broke_prob*#jragilejoker
    end
end

local decks = {
    BulletproofDeck = {
        loc = {
            name = "Bulletproof Deck",
            text = {
                "Start run with",
                "the negative {C:attention}Bulletproof{} joker"
            }
        },
        name = "Bulletproof Deck",
        config = {
            artm_bulletproofdeck = true
        },
        sprite = {
            x = 5,
            y = 2
        }
    },
}

local Backapply_to_runRef = Back.apply_to_run
function Back.apply_to_run(arg_56_0)
    Backapply_to_runRef(arg_56_0)

    if arg_56_0.effect.config.artm_bulletproofdeck then
        G.E_MANAGER:add_event(Event({
            func = function()
                -- Add Even Steven Joker
                add_joker("j_artm_bulletproofjoker", "negative", true, false)

                -- Return
                G.GAME.starting_deck_size = 20
                return true
            end
        }))
    end
end

function SMODS.INIT.ArtMod()
    init_localization()

    -- Initialize Decks
    for k, v in pairs(decks) do
        if config[k] then
            local newDeck = SMODS.Deck:new(v.name, k, v.config, v.sprite, v.loc)
            newDeck:register()
        end
    end

    if config.GlassMoneyTarot then
        -- Create Tarot
        local GlassMoney = {
            loc = {
                name = "Glass Money",
                text = {
                    "Gives {C:money}$1{} for each Glass card",
                    "in full deck",
                }
            },
            ability_name = "ARTM Glass Money",
            slug = "artm_glassmoney",
            config = {},
            cost = 3,
            cost_mult = 1,
            discovered = true
        }

        -- Initialize Tarot
        init_tarot(GlassMoney)



        -- Set local variables
        function SMODS.Tarots.c_artm_glassmoney.loc_def(card)
            return {}
        end

        -- Set can_use
        function SMODS.Tarots.c_artm_glassmoney.can_use(card)
            return true
        end

        -- Use effect
        function SMODS.Tarots.c_artm_glassmoney.use(card, area, copier)
            local glasses = 0
            for k, v in pairs(G.playing_cards) do
                if SMODS.has_enhancement(v, 'm_glass') then glasses = glasses + 1 end
            end
            delay(0.6)
            ease_dollars(glasses)
        end
    end

    if config.CrystalVeilSpectral then
        -- Create Spectral
        local CrystalVeilSpectral = {
            loc = {
                name = "Crystal Veil",
                text = {
                    "{C:attention}5{} highlighted cards",
                    "become glass cards",
                }
            },
            ability_name = "ARTM Crystal Veil",
            slug = "artm_crystalveil",
            config = { },
            cost = 4,
            cost_mult = 1,
            discovered = true
        }

        -- Initialize Spectral
        init_spectral(CrystalVeilSpectral)

        -- Set local variables
        function SMODS.Spectrals.c_artm_crystalveil.loc_def(card)
            return { }
        end

        -- Set can_use
        function SMODS.Spectrals.c_artm_crystalveil.can_use(card)
            return G.hand and #G.hand.highlighted > 0 and #G.hand.highlighted <= 5
        end

        -- Use effect
        function SMODS.Spectrals.c_artm_crystalveil.use(card, area, copier)
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end 
            for i=1, #G.hand.highlighted do
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.1,func = function() G.hand.highlighted[i]:set_ability("m_glass");return true end }))
            end
            for i=1, #G.hand.highlighted do
                local percent = 0.85 + (i-0.999)/(#G.hand.highlighted-0.998)*0.3
                G.E_MANAGER:add_event(Event({trigger = 'after',delay = 0.15,func = function() G.hand.highlighted[i]:flip();play_sound('tarot2', percent, 0.6);G.hand.highlighted[i]:juice_up(0.3, 0.3);return true end }))
            end 
        end
    end

    if config.guitarJoker then
        -- Create Joker
        local GuitarJoker = {
            loc = {
                name = "Sixfold Strings",
                text = {
                    "Adds {C:mult}+6{} Mult",
                    "then multiplies total Mult by {X:mult,C:white}X6{}"
                }
            },
            ability_name = "ARTM Sixfold Joker",
            slug = "j_artm_guitarjoker",
            ability = {
                extra = {
                    add_mult = 6,
                    multiply_mult = 6
                }
            },
            rarity = 2,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true
        }
        
        init_joker(GuitarJoker)

        SMODS.Jokers.j_artm_guitarjoker.calculate = function(self, context)
            if SMODS.end_calculate_context(context) then
                card_eval_status_text(self, 'extra', nil, nil, nil, {
                    message = localize{
                        type='variable', 
                        key='a_mult', 
                        vars={self.ability.extra.add_mult}
                    },
                    colour = G.C.MULT
                })
                return {
                    message = localize{
                        type = "variable",
                        key = "a_xmult",
                        vars = {self.ability.extra.multiply_mult}
                    },
                    mult_mod = self.ability.extra.add_mult,
                    Xmult_mod = self.ability.extra.multiply_mult,
                    card = self
                }
            end
        end
    end

    if config.Mirror then
        local Mirror = {
            loc = {
                name = "Mirror",
                text = {
                    "Retriger all cards,",
                    "when {C:attention}5{} glass cards played."
                }
            },
            ability_name = "ARTM Mirror",
            slug = "j_artm_mirror",
            ability = {
                extra = {
                    req = 5
                }
                ,
            },
            rarity = 2,
            cost = 7,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
        }

        init_joker(Mirror)

        SMODS.Jokers.j_artm_mirror.calculate = function(self, context)

            if context.repetition and context.cardarea == G.play then
                local glass_count = 0
                if #context.scoring_hand == self.ability.extra.req then
                    -- Подсчет стеклянных карт
                    for _, card in ipairs(context.scoring_hand) do
                        if card.ability.effect == "Glass Card" then
                            glass_count = glass_count + 1
                        end
                    end
                end
                if glass_count == self.ability.extra.req then
                    return {
                        message = localize("k_again_ex"),
                        repetitions = 1,
                        card = self
                    }
                end
            end
        end

    end

    if config.BulletproofJoker then
        local BulletproofJoker = {
            loc = {
                name = "Bulletproof Joker",
                text = {
                    "Glass cards do {C:attention}not break{} when played,",
                }
            },
            ability_name = "ARTM Bulletproof Joker",
            slug = "j_artm_bulletproofjoker",
            ability = {
            },
            rarity = 3,
            cost = 8,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = true,
        }

        init_joker(BulletproofJoker)

        SMODS.Jokers.j_artm_bulletproofjoker.add_to_deck = function(self, card)
            G.GAME.probabilities.old_glass_prob = G.GAME.probabilities.glass_prob    
            G.GAME.probabilities.glass_prob = 0      
        end

        SMODS.Jokers.j_artm_bulletproofjoker.calculate = function(self, context)
            if SMODS.end_calculate_context(context) then
                card_eval_status_text(self, 'extra', nil, nil, nil, {
                    message = "Unbreakable!",
                    colour = G.C.BLUE,
                    delay = 0.45
                })
            end
        end

        SMODS.Jokers.j_artm_bulletproofjoker.remove_from_deck = function(self, card)
            G.GAME.probabilities.glass_prob = G.GAME.probabilities.old_glass_prob
        end

    end

    if config.JokerShards then
        local JokerShards = {
            loc = {
                name = "JokerShards",
                text = {
                    "Glass cards give +{X:mult,C:white}X0,7{}",
                    "{C:green,E:1,S:1.1}+1 to prabability{} of breaking"
                }
            },
            ability_name = "ARTM JokerShards",
            slug = "j_artm_jokershards",
            ability = {
                extra = {
                    xmult = 0.7,
                    div_chance_denom = 4,
                    broke_prob = 1
                }
            },
            rarity = 2,
            cost = 7,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = true,
        }

        init_joker(JokerShards)

        SMODS.Jokers.j_artm_jokershards.add_to_deck = function(self, card)
            local bulletproofjoker = SMODS.find_card('j_artm_bulletproofjoker')
            G.P_CENTERS.m_glass.config.Xmult = G.P_CENTERS.m_glass.config.Xmult + card.ability.extra.xmult
            for _, deck_card in pairs(G.playing_cards) do
                if deck_card.config.center == G.P_CENTERS.m_glass then
                    deck_card.ability.Xmult = deck_card.ability.Xmult + card.ability.extra.xmult
                    deck_card.ability.x_mult = deck_card.ability.x_mult + card.ability.extra.xmult
                end
            end
            if #bulletproofjoker == 0 then
                G.GAME.probabilities.glass_prob = G.GAME.probabilities.glass_prob + card.ability.extra.broke_prob
            end
        end

        SMODS.Jokers.j_artm_jokershards.remove_from_deck = function(self, card)
            G.P_CENTERS.m_glass.config.Xmult = G.P_CENTERS.m_glass.config.Xmult - card.ability.extra.xmult
            for _, deck_card in pairs(G.playing_cards) do
                if deck_card.config.center == G.P_CENTERS.m_glass then
                    deck_card.ability.Xmult = deck_card.ability.Xmult - card.ability.extra.xmult
                    deck_card.ability.x_mult = deck_card.ability.x_mult - card.ability.extra.xmult
                end
            end
            
            G.GAME.probabilities.glass_prob = G.GAME.probabilities.glass_prob - card.ability.extra.broke_prob
        end
    end

    if config.AntiGlassJoker then
        local AntiGlassJoker = {
            loc = {
                name = "AntiGlass Joker",
                text = {
                    "This Joker gains {X:mult,C:white}X#2#{} mult",
                    "for each Glass card played",
                    "but loses {X:mult,C:white}X#2#{} Mult",
                    "for eache destroyed Glass card",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
                }
            },
            ability_name = "ARTM AntiGlass Joker",
            ability_set = "Joker",
            slug = "j_artm_antiglassjoker",
            ability = {
                extra = {
                    mult_mod = 0.1,
                    current_mult = 1,
                    glass_count = 0,
                    calc = false
                }
            },
            rarity = 2,
            cost = 7,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
        }

        init_joker(AntiGlassJoker)

        function SMODS.Jokers.j_artm_antiglassjoker.loc_def(card)
            return { card.ability.extra.current_mult, card.ability.extra.mult_mod, card.ability.extra.calc , card.ability.extra.glass_count}
        end

        SMODS.Jokers.j_artm_antiglassjoker.calculate = function(self, context)

            if context.before and not context.blueprint then
                local glasses = 0;
                for _, card in ipairs(context.scoring_hand) do
                    if card.ability.effect == "Glass Card" then
                        glasses  = glasses  + 1
                    end
                end
                if glasses > 0 then
                    self.ability.extra.current_mult = self.ability.extra.current_mult + self.ability.extra.mult_mod *glasses 
                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = localize{
                            type='variable', 
                            key='a_xmult', 
                            vars={self.ability.extra.current_mult}
                        },
                    })
                end
            end

            if SMODS.end_calculate_context(context) then
                return {
                    Xmult_mod = self.ability.extra.current_mult,
                    card = self,
                    message = localize{
                        type = "variable",
                        key = "a_xmult",
                        vars = {self.ability.extra.current_mult},
                    }
                }
            end


        end

        
    end

    if config.Glassmaster then
        local Glassmaster = {
            loc = {
                name = "Glassmaster",
                text = {
                    "Gives {X:mult,C:white}X#2#{} mult",
                    "for each Glass card",
                    "in your deck.",
                    "{C:inactive}(Currently {X:mult,C:white}X#1#{C:inactive} Mult)"
                }
            },
            ability_name = "ARTM Glassmaster",
            ability_set = "Joker",
            slug = "j_artm_glassmaster",
            ability = {
                extra = {
                    mult_mod = 0.2,
                    current_mult = 1,
                }
            },
            rarity = 2,
            cost = 7,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
        }

        init_joker(Glassmaster)

        function SMODS.Jokers.j_artm_glassmaster.loc_def(card)
            return { card.ability.extra.current_mult, card.ability.extra.mult_mod, card.ability.extra.calc , card.ability.extra.glass_count}
        end

        SMODS.Jokers.j_artm_glassmaster.calculate = function(self, context)
            if SMODS.end_calculate_context(context) then
                return {
                    Xmult_mod = self.ability.extra.current_mult,
                    card = self,
                    message = localize{
                        type = "variable",
                        key = "a_xmult",
                        vars = {self.ability.extra.current_mult},
                    }
                }
            end


        end

        
    end

    if config.Glassnovice then
        local Glassnovice = {
            loc = {
                name = "Glassnovice",
                text = {
                    "Gives {C:mult}+#2#{} to mult",
                    "for each Glass card",
                    "in your deck.",
                    "{C:inactive}(Currently {C:mult}+#1#{C:inactive} Mult)"
                }
            },
            ability_name = "ARTM Glassnovice",
            ability_set = "Joker",
            slug = "j_artm_glassnovice",
            ability = {
                extra = {
                    mult_mod = 2,
                    current_mult = 0,
                }
            },
            rarity = 1,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
        }

        init_joker(Glassnovice)

        function SMODS.Jokers.j_artm_glassnovice.loc_def(card)
            return { card.ability.extra.current_mult, card.ability.extra.mult_mod, card.ability.extra.calc , card.ability.extra.glass_count}
        end

        SMODS.Jokers.j_artm_glassnovice.calculate = function(self, context)
            if SMODS.end_calculate_context(context) then
                return {
                    mult_mod = self.ability.extra.current_mult,
                    card = self,
                    message = localize{
                        type = "variable",
                        key = "a_mult",
                        vars = {self.ability.extra.current_mult},
                    }
                }
            end


        end

        
    end

    if config.CommonJoker then
        local CommonJoker = {
            loc = {
                name = "Common Joker",
                text = {
                    "Common Joker ",
                    "each gives {C:mult}+5{} to mult",
                }
            },
            ability_name = "ARTM Common Joker",
            ability_set = "Joker",
            slug = "j_artm_commonjoker",
            ability = {
                extra = {
                    mult_mod = 5,
                }
            },
            rarity = 1,
            cost = 5,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
        }

        init_joker(CommonJoker)

        SMODS.Jokers.j_artm_commonjoker.calculate = function(self, context)
            if context.other_joker then
                if context.other_joker.config.center.rarity == 1 or context.other_joker.config.center.rarity == "common" then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.other_joker:juice_up(0.5, 0.5)
                            return true
                        end
                    })) 
                    return {
                        message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult_mod}},
                        mult_mod = self.ability.extra.mult_mod,
                    }
                end
            end

        end

        
    end

    if config.CrystalJuggler then
        local CrystalJuggler = {
            loc = {
                name = "Crystal Juggler",
                text = {
                    "If {C:attention}first hand{} of round",
                    "has only {C:attention}#1#{} card, give it a",
                    "{C:attention}Glass Enhancement{}",
                }
            },
            ability_name = "ARTM Crystal Juggler",
            ability_set = "Joker",
            slug = "j_artm_crystaljuggler",
            ability = {
                extra = {
                    req = 1,
                }
            },
            rarity = 2,
            cost = 6,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = true,
        }

        init_joker(CrystalJuggler)

        function SMODS.Jokers.j_artm_crystaljuggler.loc_def(card)
            return { card.ability.extra.req }
        end

        SMODS.Jokers.j_artm_crystaljuggler.calculate = function(self, context)
            if context.first_hand_drawn then
                local eval = function()
                    return G.GAME.current_round.hands_played == 0
                end
                juice_card_until(self, eval, true)
            end

            -- If first hand is single card, upgrade
            if G.GAME.current_round.hands_played == 0 then
                if context.before then
                    if #context.full_hand == self.ability.extra.req then
                        for _, card in ipairs(context.scoring_hand) do

                            G.E_MANAGER:add_event(Event({
                                delay = 0.5,
                                func = function()
                                    card:juice_up(0.3, 0.5)
                                    return true
                                end
                            }))

                            if card.ability.effect ~= "m_glass" and not card.debuff then
                                card:set_ability("m_glass", nil, true)
                                -- Return message
                                card_eval_status_text(self, "extra", nil, nil, nil, {
                                    message = localize("k_upgrade_ex")
                                })
                            end
                        end
                    end
                end
            end

        end

        
    end

    if config.AntimaterialJoker then
        local AntimaterialJoker = {
            loc = {
                name = "Antimaterial Joker",
                text = {
                    "After {C:attention}#2#{} rounds, sell this card",
                    "to get {C:attention}+1 Joker slot{}",
                    "{C:inactive}(Currently {C:attention}#1#/#2#{}){C:inactive}",
                }
            },
            ability_name = "ARTM Antimaterial Joker",
            ability_set = "Joker",
            slug = "j_artm_antimaterialjoker",
            ability = {
                extra = {
                    req = 3,
                    count = 0,
                }
            },
            rarity = 3,
            cost = 7,
            unlocked = true,
            discovered = true,
            blueprint_compat = false,
            eternal_compat = true,
        }

        init_joker(AntimaterialJoker)

        function SMODS.Jokers.j_artm_antimaterialjoker.loc_def(card)
            return {card.ability.extra.count, card.ability.extra.req }
        end

        SMODS.Jokers.j_artm_antimaterialjoker.calculate = function(self, context)
            if context.individual then

            elseif context.end_of_round and not context.repetition and not context.blueprint then
                self.ability.extra.count = self.ability.extra.count + 1
                if self.ability.extra.req == self.ability.extra.count then
                    local eval = function(card) return not card.REMOVED end
                    juice_card_until(self, eval, true)
                end
                return {
                    message = (self.ability.extra.count < self.ability.extra.req) and (self.ability.extra.count..'/'..self.ability.extra.req) or localize('k_active_ex'),
                    colour = G.C.FILTER
                }
            end

            if context.selling_self and (self.ability.extra.count >= self.ability.extra.req) and not context.blueprint then
                self.ability.extra.count = 0
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end

        
    end

    if config.DeMorraJoker then
        local DeMorra = {
            loc = {
                name = "De Morra",
                text = {
                    "Each played card gives a {X:mult,C:white}X1.1{} mult,",
                    "each played card increases ", 
                    " this mult by {X:mult,C:white}X#3#{}",
                }
            },
            ability_name = "ARTM De Morra",
            ability_set = "Joker",
            slug = "j_artm_demorra",
            ability = {
                extra = {
                    start_mult = 1,
                    Xmult = 1,
                    mult_mod = 0.1,
                }
            },
            rarity = 4,
            cost = 20,
            unlocked = true,
            discovered = true,
            blueprint_compat = true,
            eternal_compat = true,
            soul_pos = { x = 1, y = 0 },
        }

        init_joker(DeMorra)

        function SMODS.Jokers.j_artm_demorra.loc_def(card)
            return {card.ability.extra.Xmult, card.ability.extra.start_mult, card.ability.extra.mult_mod }
        end

        SMODS.Jokers.j_artm_demorra.calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                self.ability.extra.Xmult = self.ability.extra.Xmult + self.ability.extra.mult_mod
                return {
                    message = localize {
                        type = "variable",
                        key = "a_xmult",
                        vars = { self.ability.extra.Xmult }
                    },
                    x_mult = self.ability.extra.Xmult,
                    card = self
                }
            end

            if SMODS.end_calculate_context(context) then
                self.ability.extra.Xmult = self.ability.extra.start_mult
            end
        end     
    end


end


----------------------------------------------
------------MOD CODE END----------------------

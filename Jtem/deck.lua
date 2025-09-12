local jtemdatlas = SMODS.Atlas {
    path = "Jtem/Decks.png",
    key = "jtemdatlas",
    px = 71,
    py = 95
}

local shader = SMODS.Shader {
    key = "jtem_deckshader",
    path = "deck.fs"
}

local deck = SMODS.Back {
    key = "domn",
    atlas = "jtemdatlas",
    shader = "jtem_deckshader",
    apply = function (self)
        -- Team Name's Addition  Starting deck cards has a random sticker
            G.GAME.modifiers.hpot_all_sticker = true
        -- end
    end,
    calculate = function (self, back, context)
        --Horsechicot Addition  Cards give 0.05 bitcoins when triggered
        if context.post_trigger then
            ease_cryptocurrency(0.05)
        end
    end
}

-- gives the deck a shader (stolen from TMD teehee :3)
SMODS.DrawStep {
    key = 'jtemedition_deck',
    order = 5,
    func = function(self)
        if self.children.back then
			local cback = self.params.galdur_back or (not self.params.viewed_back and G.GAME.selected_back) or ( self.params.viewed_back and G.GAME.viewed_back) 
			if cback then
				local shader = nil
				if cback.effect.center.shader then shader =  cback.effect.center.shader end

			-- back has shader
			if (shader 
			-- if this is a sleeve, ignore it
			and (self.config.center.set ~= "Sleeve"))
			-- not the stake select from galdur or the stake chips
			and((self.area and  not self.area.config.stake_select and not self.area.config.stake_chips)or not self.area) then
				local t =( self.area and self.area.config.type == "deck") or self.config.center.set == "Back" 
				if t and not self.states.drag.is then self.ARGS.send_to_shader = {1.0,self.ARGS.send_to_shader[2]} end
			
			self.children.back:draw_shader(shader, nil, self.ARGS.send_to_shader, t, self.children.center, 0,0)
			
		end
        end
	end
    end,
    conditions = { vortex = false, facing = 'back' },
}

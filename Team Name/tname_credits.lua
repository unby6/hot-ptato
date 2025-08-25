
function G.UIDEF.tname_credits()
    local save = G.PROFILES[G.SETTINGS.profile]
    save.TNameCredits = (save.TNameCredits or 0)
    return {n = G.UIT.ROOT, config = {
					colour = G.C.CLEAR
				}, nodes = {
					{n = G.UIT.ROOT, config = {r = 0.1, minw = 8, minh = 6, align = "tm", padding = 0.2, colour = G.C.BLACK}, nodes = {
                        {n = G.UIT.C, config = {r = 0.1, minw = 8, minh = 6, align = "cm", colour = G.C.CLEAR}, nodes = {
                            {n = G.UIT.R, config = {r = 0.1,minw = 1,align = "cm", padding = 0.2, colour = G.C.GREY}, nodes = {
                               {n=G.UIT.T, config={text = "You have:", scale = 0.6, colour = G.C.WHITE, shadow = true}},
                               {n=G.UIT.T, config={text = "c."..G.PROFILES[G.SETTINGS.profile]["TNameCredits"], scale = 0.6, colour = G.C.PURPLE, shadow = true}},
                               {n=G.UIT.T, config={text = ".", scale = 0.6, colour = G.C.WHITE, shadow = true}},
                            }}}
                        }
				}}
            }}
end
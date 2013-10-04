--[[
Valeurs par défaut

]]
local sc = 3

default = {
	scale = sc;
	tilesize = {x=math.floor(162/sc), y=math.floor(126/sc)},		-- Taille des cases
	maxsize = {x=100, y=100}, 		-- Taille "maximum" d'un niveau
	tileset = "default",			-- Collection des graphismes du niveau
	loop = true,					-- Bouclage des niveaux
	tilt = 0.75						-- Multiplicateur d'inclination de la vue
}

return default
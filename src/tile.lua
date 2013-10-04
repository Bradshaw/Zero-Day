tile = {}
local tile_mt = {}



-- Les cases sont définies dans le sous-dossier tiles, ils comportent un fichier .lua qui décrit leurs attributs et peuvent éventuellement indiquer un fichier image par nom.
function tile.new(typ, number)
	local self = setmetatable({},{__index=tile_mt})
	self.typ = typ or "wall"
	self.collide = tile.elem[self.typ].collide
	self.number = number or 0
	return self
end

function tile.getTilesets()
	return love.filesystem.enumerate("tiles")
end

function tile.setTileset(tileset)
	local isin = false
	for k,v in pairs(tile.getTilesets()) do
		if v==tileset then
			isin = true
		end
	end
	if isin then
		tile.tileset = tileset
		tile.elem={}
		for k,v in pairs(love.filesystem.enumerate("tiles/"..tileset)) do
			tile.elem[v] = require("tiles/"..tileset.."/"..v.."/init")
		end
	end
	for k,v in pairs(tile.elem) do
		--print(k,v)
	end
end


function tile.draw(typ,x,y,env,pass2)
	tile.elem[typ.typ].draw(x,y,env,pass2)
	--[[
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setColor(0,0,0)
	love.graphics.print(typ,x*default.tilesize.x,y*default.tilesize.y)
	love.graphics.setColor(r,g,b,a)
	]]
end

tile.setTileset("default")
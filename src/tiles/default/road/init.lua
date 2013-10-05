local t = {}

require("useful")

local alt = love.graphics.newImage("tiles/default/road/texturestart.png")
local tex = love.graphics.newImage("tiles/default/road/texture.png")

function t.draw(x,y,env)
	local r,g,b,a = love.graphics.getColor()
	local sx,sy,sxs,sys = love.graphics.getScissor()
	local m = love.graphics.getBlendMode()

	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode("alpha")
	local bin = useful.getBin(env)
	local s = 0
	for i=1,4 do
		if bin[i] then
			s = s+1
		end
	end
	if s==2 then
		love.graphics.draw(tex,useful.getq(env),x*default.tilesize.x,y*default.tilesize.y)
	else
		love.graphics.draw(alt,useful.getq(env),x*default.tilesize.x,y*default.tilesize.y)
	end
	love.graphics.setColor(255,255,255,128)
	--love.graphics.drawq(img,useful.getq(env),x*default.tilesize.x,y*default.tilesize.y)
	love.graphics.setColor(r,g,b,a)
	love.graphics.setBlendMode(m)
	if sx then
		love.graphics.setScissor(sx,sy,sxs,sys)
	else
		love.graphics.setScissor()
	end
	--love.graphics.rectangle("line",x*default.tilesize.x+1, y*default.tilesize.y+2, default.tilesize.x-2, default.tilesize.y-3)
end

t.collide = false

return t

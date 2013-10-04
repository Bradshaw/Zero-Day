local t = {}

require("useful")

local pub = love.graphics.newImage("images/pub.png")
local tex = love.graphics.newImage("tiles/default/wall/facade.png")
local blind = love.graphics.newImage("tiles/default/wall/blind.png")

texbatch = love.graphics.newSpriteBatch(tex)

function t.draw(x,y,env,pass2)
	--[[]]
	local r,g,b,a = love.graphics.getColor()
	local sx,sy,sxs,sys = love.graphics.getScissor()
	local m = love.graphics.getBlendMode()
	local bin = useful.getBin(env)

	love.graphics.setColor(255,255,255)
	love.graphics.setBlendMode("alpha")
	--love.graphics.setScissor(x*default.tilesize.x, y*default.tilesize.y, default.tilesize.x, default.tilesize.y)
	love.graphics.draw(blind,(x+1)*default.tilesize.x-((c[f].x-((0.5+x)*default.tilesize.x))/13),(y)*default.tilesize.y-10,0,1,1,default.tilesize.x,0)
	if not pass2 then
		if not bin[4] then
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill",x*default.tilesize.x-((c[f].x-((0.5+x)*default.tilesize.x))/12), y*default.tilesize.y, default.tilesize.x, 12)
			love.graphics.setColor(255,255,255)
			texbatch:add((x+1)*default.tilesize.x,(y+1)*default.tilesize.y,0,1,1,default.tilesize.x,30)
			texbatch:add((x+1)*default.tilesize.x,(y+1)*default.tilesize.y,0,1,1,default.tilesize.x,30,(c[f].x-((0.5+x)*default.tilesize.x))/300)
		else
			love.graphics.setColor(0,0,0)
			love.graphics.rectangle("fill",x*default.tilesize.x-((c[f].x-((0.5+x)*default.tilesize.x))/10), y*default.tilesize.y, default.tilesize.x, default.tilesize.y+12)
		end
	else
		love.graphics.setColor(0,0,0)
		if bin[4] then
			love.graphics.rectangle("fill",x*default.tilesize.x-((c[f].x-((0.5+x)*default.tilesize.x))/10), y*default.tilesize.y, default.tilesize.x, default.tilesize.y)

		else
			love.graphics.rectangle("fill",x*default.tilesize.x-((c[f].x-((0.5+x)*default.tilesize.x))/10), y*default.tilesize.y, default.tilesize.x, default.tilesize.y-30)
			--love.graphics.setColor(255,255,255)
			--texbatch:add((x+1)*default.tilesize.x,(y+1)*default.tilesize.y,0,1,1,default.tilesize.x,30,(c[f].x-((0.5+x)*default.tilesize.x))/300)
		end
	end
	if not bin[2] and bin[1] and (((x)*default.tilesize.x)-c[f].x)>0 and not pass2 then
		love.graphics.setColor(255,255,255)
		texbatch:add(
		-- x
			(x)*default.tilesize.x,
		-- y
			(y)*default.tilesize.y,
		-- r
			math.pi/2,
		-- sx
			default.tilesize.y/default.tilesize.x,
		-- sy
			(((x)*default.tilesize.x)-c[f].x)/400,
		-- ox
			0,
		-- oy
			30,
		-- kx	
			1.5,
		-- ky
			0)
		--[[]]
		texbatch:add(
		-- x
			(x)*default.tilesize.x,
		-- y
			(y)*default.tilesize.y,
		-- r
			math.pi/2,
		-- sx
			default.tilesize.y/default.tilesize.x,
		-- sy
			(((x)*default.tilesize.x)-c[f].x)/300,
		-- ox
			0,
		-- oy
			30,
		-- kx	
			(c[f].y-((-7+y)*default.tilesize.y))/300,
		-- ky
			0)
		--]]
	--[[]]
	end
	if not bin[3] and bin[1] and (((1+x)*default.tilesize.x)-c[f].x)<0 and not pass2 then
		love.graphics.setColor(255,255,255)
		texbatch:add(
		-- x
			(1+x)*default.tilesize.x,
		-- y
			(y)*default.tilesize.y,
		-- r
			math.pi/2,
		-- sx
			default.tilesize.y/default.tilesize.x,
		-- sy
			(((1+x)*default.tilesize.x)-c[f].x)/400,
		-- ox
			0,
		-- oy
			30,
		-- kx	
			1.5,
		-- ky
			0)
		--[[]]
		texbatch:add(
		-- x
			(1+x)*default.tilesize.x,
		-- y
			(y)*default.tilesize.y,
		-- r
			math.pi/2,
		-- sx
			default.tilesize.y/default.tilesize.x,
		-- sy
			(((1+x)*default.tilesize.x)-c[f].x)/300,
		-- ox
			0,
		-- oy
			30,
		-- kx	
			(c[f].y-((-7+y)*default.tilesize.y))/300,
		-- ky
			0)
		--]]
	--[[]]
	end
	love.graphics.setColor(r,g,b,a)
	love.graphics.setBlendMode(m)
	if sx then
		love.graphics.setScissor(sx,sy,sxs,sys)
	else
		love.graphics.setScissor()
	end
	--]]
	if not bin[4] and bin[1] and (x+y)%3==0 then
		love.graphics.draw(pub,(x+1)*default.tilesize.x,(y+1)*default.tilesize.y,0,1,0.75,default.tilesize.x,90,(c[f].x-((0.5+x)*default.tilesize.x))/600)
	end
end

t.collide = true

return t

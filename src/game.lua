local state = gstate.new()


function state:init()
end



function state:enter()
end


function state:focus()

end


function state:mousepressed(x, y, btn)

end


function state:mousereleased(x, y, btn)
	
end


function state:joystickpressed(joystick, button)
	
end


function state:joystickreleased(joystick, button)
	
end


function state:quit()
	
end


function state:keypressed(key, uni)
	if useful.isIn(key,"escape","j","l") then
		gstate.switch(pause)
	end
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	countdown = countdown-dt
	if levelend then
		gstate.switch(endscreen)
	end
	--c[1].hitpoints = 1
	if true then --lasthit>0 and streak>=10 then
		--slowdown = 0.2
		--table.insert(splatable,splatter.newEmitter(c[1].x,c[1].y,"spray"))
	end
	for i,v in ipairs(splatable) do
		--v:update(dt)
	end
	fade = math.max(fade - dt/2,(1-c[1].hitpoints/100)^2)
	cheeky:setVolume((1-fade)*0.6)
	cheekyfade:setVolume((fade)*0.6)
	slowdown = math.max(slowdown-(dt/4), 0)
	local dt = dt*(1-slowdown)
	--c[1].hitpoints = math.min(100,c[1].hitpoints+dt*(streak/10))
	engine:setPitch(math.max(math.pow(c[1].speed/800,2),0.5)*(1-slowdown))
	cheeky:setPitch(1-slowdown)
	past = (past or 0) + dt
	
	updategame(dt)

	if (not c[1].wreck and c[1].hitpoints <= 0) or past>100 then
		print("Died")
		c[1] = wreck.new(c[1].x,c[1].y,c[1].angle,c[1].speed)
		gstate.switch(deadscreen)
	end
	shake = math.min(1,math.max(shake-(dt), 0))
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	gameoverlay()
	love.graphics.setCanvas(overlay)
	if math.floor(countdown)>-1 then
		csc = 12+((countdown-math.floor(countdown))^2)*11
		love.graphics.print("Go!",midx-6*csc,midy-4*csc,0,csc,csc)
	end
	love.graphics.setCanvas()
	drawgame()
	love.graphics.setColor(r,g,b,a)
	--]]
end

return state

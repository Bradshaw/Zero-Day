local state = gstate.new()


function state:init()
end



function state:enter()
	scoot = -1
	capture = true
	love.mouse.setGrabbed(true)
	flashor = 0
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
	initflyby()
	gstate.switch(flybyscreen)
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	if levelend then
		initflyby()
		gstate.switch(flybyscreen)
	end
	--c[1].hitpoints = 1
	if lasthit>0 and streak>=10 then
		--slowdown = math.max(slowdown,0.25)
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
	if scoot==-1 and ((not c[1].wreck and c[1].hitpoints <= 0) or past>45) then
		c[1] = wreck.new(c[1].x,c[1].y,c[1].angle,c[1].speed)
		scoot = 0
	end
	if scoot>-1 then
		scoot = (scoot) + dt
	end
	if scoot>3 then
		scoot = 0
		initflyby()
		gstate.switch(flybyscreen)
	end
	shake = math.min(1,math.max(shake-(dt), 0))
	flashor = flashor + dt
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setCanvas(overlay)
	if flashor%1<0.5 then
		love.graphics.print("Ins<rez une pi>ce",midx-font:getWidth("Ins<rez une pi>ce")/2,60)
	end
	gameoverlay()

	love.graphics.setCanvas()

	drawgame()
	--]]
end

return state

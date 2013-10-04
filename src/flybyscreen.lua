local state = gstate.new()


function state:init()
end



function state:enter()
	capture = false
	moved = false
	if darkness:isLooping() then
		darkness:setLooping(false)
		moved = true
	end
	love.mouse.setGrab(false)
	flymenu = menupopper.new({
		{text="Nouvelle partie",
		func=function() resetgame() initgame() gstate.switch(roundstart) end},
		{text="Meilleurs scores",
		func=function() gstate.switch(hiscorescreen) end},
		{text="Revoir intro",
		func=function() initflyby() darkness:rewind() darkness:play() gstate.switch(intro) end},
		{text="Quitter",
		func=function() love.event.push("quit") end}
		})
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
	moved = true
	if key=="escape" then
		love.event.push("quit")
	end
	flymenu:doKey(key)
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	if darkness:isStopped() then
		if not moved then
			resetgame()
			initdemo()
			gstate.switch(demo)
			moved = false
		else
			darkness:play()
			moved = false
		end
	end
	--c[1].hitpoints = math.min(100,c[1].hitpoints+dt*(streak/10))
	past = (past or 0) + dt
	
	updategame(dt)

	shake = math.min(1,math.max(shake-(dt), 0))
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setCanvas(overlay)
	love.graphics.draw(title,midx,0,0,1,1,itguy:getWidth())
	love.graphics.draw(itguy,midx*2,midy*2,0,1,1,itguy:getWidth(),itguy:getHeight())
	love.graphics.draw(tgslogo,20,midy*2-20,0,1,1,0,tgslogo:getHeight())
	--love.graphics.draw(zombieguy,-30,midy*2,0,-1,1,zombieguy:getWidth(),zombieguy:getHeight())
	love.graphics.draw(tdrive,midx*2-100,midy*2,0,1,1,tdrive:getWidth(),tdrive:getHeight())
	flymenu:draw(midx,midy+30)
	love.graphics.setCanvas()
	drawgame()
	--]]
end

return state

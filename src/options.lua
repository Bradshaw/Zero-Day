local state = gstate.new()


function state:init()
end


function state:enter()
	local done = {text="Scores <ffac<s...",
		func=function() end}
	local sure = {text="Etes vous s$r?",
		func=function()
			if love.filesystem.exists("tableauscore.lua") then
				love.filesystem.remove("tableauscore.lua")
			end
			optmenu.entries[3]=done
		end}
	local eff = {text="Effacer scores",
		func=function()
			optmenu.entries[3]=sure
		end}

	capture = false
	moved = false
	love.mouse.setGrab(false)
	optmenu = menupopper.new({
		{text="Retour au menu",
		func=function() gstate.switch(flybyscreen) end},
		{text="Resolution: "..love.graphics.getWidth().."x"..love.graphics.getHeight(),
		func=function() cycleres() optmenu.entries[2].text = "Resolution: "..love.graphics.getWidth().."x"..love.graphics.getHeight() end},
		eff,
		
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
		gstate.switch(flybyscreen)
	end
	optmenu:doKey(key)
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	if darkness:isStopped() then
		if not moved then
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
	love.graphics.draw(zombieguy,-30,midy*2,0,-1,1,zombieguy:getWidth(),zombieguy:getHeight())
	love.graphics.draw(zombieguy2,midx*2-zombieguy2:getWidth()+30,midy*2,0,-1,1,zombieguy2:getWidth(),zombieguy2:getHeight())
	love.graphics.draw(title,midx,0,0,1,1,itguy:getWidth())
	optmenu:draw(midx,midy+30)
	love.graphics.setCanvas()
	drawgame()
	--]]
end

return state

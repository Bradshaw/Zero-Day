local state = gstate.new()


function state:init()
end



function state:enter()
	pausemenu = menupopper.new({
		{text="Reprendre",
		func=function() gstate.switch(game) end},
		{text="Retour au menu",
		func=function() resetgame() initflyby() gstate.switch(flybyscreen) end},
		{text="Quitter",
		func=function() love.event.push("quit") end}
		})
	engine:stop()
	capture = false
	love.mouse.setGrab(false)
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
		gstate.switch(game)
	end
	pausemenu:doKey(key)
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	fade = math.min(fade + dt,1)
	cheeky:setVolume((1-fade)*0.6)
	cheekyfade:setVolume((fade)*0.6)
	shake = 0
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setCanvas(overlay)
	love.graphics.setColor(0,0,0,192)
	love.graphics.rectangle("fill",0,0,midx*2,midy*2)
	love.graphics.setColor(255,255,255)
	pausemenu:draw(midx,midy-20)
	love.graphics.setCanvas()
	drawgame()
	--]]
end

return state

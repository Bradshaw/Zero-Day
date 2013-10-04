local state = gstate.new()


function state:init()
end



function state:enter()
	countdown = 4.5
	oldcsc = math.huge
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
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	engine:setPitch(math.max(math.pow(c[1].speed/800,2),0.5)*(1-slowdown))
	cheeky:setVolume((1-fade)*0.6)
	cheekyfade:setVolume((fade)*0.6)
	past = 0
	countdown = countdown-dt
	
	--updategame(dt)
	fade=math.max(0,math.min(1,(countdown-1)/3))
	if countdown<=1 then
		gstate.switch(game)
	end
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	gameoverlay()
	oldcsc = csc or math.huge
	csc = 8+((countdown-math.floor(countdown))^2)*7
	if csc>oldcsc then
		sounder.play("music/boom2.ogg",1+math.random()/10,1)
	end
	love.graphics.setCanvas(overlay)
	local rnd = "Round "..diff
	love.graphics.print(rnd,midx-font:getWidth(rnd),midy+40,0,2,2)
	if math.floor(countdown)<4 then
		love.graphics.print(math.floor(countdown),midx-2*csc,midy-4*csc-20,0,csc,csc)
	end
	love.graphics.setCanvas()
	drawgame()
	love.graphics.setColor(r,g,b,a)
	--]]
end

return state

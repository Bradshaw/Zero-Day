local state = gstate.new()


function state:init()
	if not getthread then
		sendthread= love.thread.newThread("send", "threadenvoie.lua")
		getthread= love.thread.newThread("get", "threadreception.lua")
		sendthread:start()
		getthread:start()
	end
end



function state:enter()
	capture = false
	moved = false
	tableau = charger()
	love.mouse.setGrab(false)
	page = 1
	scoremenu = menupopper.new({
		{text="Retour au menu",
		func=function() gstate.switch(flybyscreen) end},
		{text="Page suivante",
		func=function() page = math.min(math.floor(#tableau/10)+1,page+1) end},
		{text="Page pr<c<dente",
		func=function() page = math.max(1,page-1) end}
		})
end


function state:focus()

end


function state:mousepressed(x, y, btn)
love.graphics.setCanvas(overlay)
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
	if key=="right" then
		page = math.min(math.floor(#tableau/10)+1,page+1)
	end
	if key=="left" then
		page = math.max(1,page-1)
	end
	scoremenu:doKey(key)
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
	if getthread:get("finie") then
		page = 1
		tableau = {}
		local message = getthread:get("message")
		loadstring(message)()
		scoremenu.entries[4].text = "Voir scores locaux"
		scoremenu.entries[4].func =
		function()
			tableau = {}
			page = 1
			tableau = charger()
			scoremenu.entries[4].text = "Voir scores en ligne"
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
	local popup = midy/2+10
	love.graphics.draw(zombieguy,-30,midy*2,0,-1,1,zombieguy:getWidth(),zombieguy:getHeight())
	love.graphics.draw(miliguy,midx*2-miliguy:getWidth(),midy*2,0,-1,1,miliguy:getWidth(),miliguy:getHeight())
	scoremenu:draw(midx,popup-40)
	if tableau then
		for i=1+(page-1)*10,10+(page-1)*10 do
			if tableau[i] then
				local v=tableau[i]
				local p = i - (page-1) * 10
				if v.pseudo then
					love.graphics.print(i..": "..v.pseudo,midx-75-font:getWidth(i..": "),popup+p*10)
				else
					love.graphics.print(i..": "..v.speudo,midx-75-font:getWidth(i..": "),popup+p*10)
				end
				love.graphics.print(v.score,midx+75-font:getWidth(v.score),popup+p*10)
			else
				local p = i - (page-1) * 10
				love.graphics.print(i..": ...",midx-75-font:getWidth(i..": "),popup+p*10)
			end
		end
	end
	love.graphics.setCanvas()
	drawgame()
	--]]
end

return state

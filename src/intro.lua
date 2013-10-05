local state = gstate.new()


function state:init()

end



function state:enter()
	introtext=
						"La population n'<tait pas pr&te\n"..
						"  La maladie s'est propag<e rapidement\n"..
						"mettant le pays # genoux\n\n"..
						"  Mais en secret, les militaires avaient\n"..
						"pr<vu le coup.\n"..
						"  Les bombes auto-guid<es ont fait rage,\n"..
						"ciblant avec pr<cision les infect<s.\n"..
						"  En quelques heures seulement, aucun\n"..
						"zombie ne pouvait faire plus de trois\n"..
						"m>tres avant d'&tre d<truit par le\n"..
						"syst>me de d<fense automatique.\n"..
						"Le plan <tait sans faille...\n\n"..
						"          Ou presque...\n\n"..
						"  Comme tout syst>me, il suffit d'un\n"..
						"point faible qui ne soit pas connu, et\n"..
						"on risque de tout perdre.\n\n"..
						"  Un soldat, responsable d'un poste de\n"..
						"controle de missiles, ouvre un e-mail...\n"..
						"  Ce message lui proposait des services\n"..
						"d'am<lioration de son anatomie. Intrigu<,\n"..
						"et inconscient, il lib>re un virus sur\n"..
						"le r<seau.\n"..
						"  Les missiles commencent à tomber au\n"..
						"hasard, causant un chaos pire que ce que\n"..
						"le syst>me <tait cens< <viter.\n\n"..
						"Un informaticien, arm< d'une cl< USB\n"..
						"bourr<e d'anti-virus, prend le volant de\n"..
						"sa voiture et part pour l'intervention\n"..
						"qui marquera la gloire, et la fin, de sa\n"..
						"courte carri>re.\n\n"..
						"           Bienvenus, dans"

	capture = false
	moved = true
	love.mouse.setGrabbed(false)
	intromask = 0
	itguymask = 0
	miliguymask = 0
	zombieguymask = 0
	past = 0
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
	darkness:setLooping(true)
	gstate.switch(flybyscreen)
end


function state:keyreleased(key, uni)
	
end


function state:update(dt)
	--c[1].hitpoints = math.min(100,c[1].hitpoints+dt*(streak/10))
	past = (past or 0) + (dt)
	intromask = math.max(0,math.min(1,18-past))
	itguymask = math.max(0,math.min(1,33-past))-math.max(0,math.min(1,22-past))
	miliguymask = math.max(0,math.min(1,22-past))-math.max(0,math.min(1,14-past))
	zombieguymask = math.max(0,math.min(1,12-past))-math.max(0,math.min(1,6-past))
	
	updategame(dt)

	if past>42 then
		darkness:setLooping(true)
		gstate.switch(flybyscreen)
	end

	shake = math.min(1,math.max(shake-(dt), 0))
end

local maxZombies = 0
function state:draw()
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setCanvas(overlay)
	love.graphics.setColor(0,0,0,255*intromask)
	love.graphics.rectangle("fill",0,0,midx*2,midy*2)
	love.graphics.setColor(255,255,255)
	love.graphics.print(introtext,midx-110,midy*2-past*15)
	love.graphics.draw(title,midx,(math.max(0,(((midy*2)/15)+22-past)*15)),0,1,1,itguy:getWidth())
	--love.graphics.print(math.floor(past*100)/100,10,10,0,2,2)
	love.graphics.setColor(255,255,255,255*(itguymask))
	love.graphics.draw(itguy,midx*2+20,midy*2,0,1,1,itguy:getWidth(),itguy:getHeight())
	love.graphics.draw(tdrive,midx*2-80,midy*2,0,1,1,tdrive:getWidth(),tdrive:getHeight())
	love.graphics.setColor(255,255,255,255*(miliguymask))
	love.graphics.draw(miliguy,-20,midy*2+30,0,1,1,0,miliguy:getHeight())

	love.graphics.setColor(255,255,255,255*(zombieguymask))
	love.graphics.draw(zombieguy,midx*2+30,midy*2+30,0,1,1,zombieguy:getWidth(),zombieguy:getHeight())
	love.graphics.setCanvas()
	drawgame()
	--]]
end

return state

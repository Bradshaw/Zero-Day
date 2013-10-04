local state = gstate.new()


function state:init()
end



function state:enter()
	introtext=
						"              Zero Day\n\n"..
						"D<velopp< pour le concours:\n"..
						"        Game # niaque 2012\n"..
						"Nous sommes: \"define true false\"\n\n"..
						"     Kevin \"Gaeel\" Bradshaw\n"..
						"     Florian \"Flower Power\" Pinier\n\n"..
						"Technologies utilis<es:\n"..
						"     Framework: Love2D\n"..
						"     Langage: Lua\n"..
						"     Edition d'images: The GIMP\n"..
						"     Musique: Renoise\n"..
						"     Bruitages: BFXR\n"..
						"                PureData\n"..
						"                Renoise\n\n"..
						"Code de jeu sous licence:\n"..
						"     WTFPL pour le code ZeroDay\n"..
						"     zlib/libpng pour Love2D\n"..
						"     MIT pour gamestate.lua\n"..
						"     Creative Commons pour:\n"..
						"        L'image du Soldat\n"..
						"        La police GruntReaper\n"..
						"     Les images du jeu et l'univers sont\n"..
						"        propri<t< de Kevin Bradshaw et \n"..
						"        Florian Pinier\n"..
						"     Le logo TGS est propri<t< de:\n"..
						"        TGS EVENEMENTS\n\n"..
						"Merci d'avoir jou<, et merci au TGS pour\n"..
						"ce concours qui s'est av<r< plein de surprises\n\n"..
						"Bonne chance aux autres participants, et\n"..
						"courage au jury!\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"..
						"T<l<chargez ce jeu et consultez les scores:\n"..
						"           http://zeroday.xi.gd"
	capture = false
	moved = true
	love.mouse.setGrab(false)
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

	if past>49 then
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
	love.graphics.draw(title,midx,((((midy*2)/15)+22-past)*15),0,1,1,itguy:getWidth())
	--love.graphics.print(math.floor(past*100)/100,10,10,0,2,2)
	--love.graphics.print(midy*2-past*15,10,10,0,2,2)
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

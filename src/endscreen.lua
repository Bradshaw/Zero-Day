local state = gstate.new()


function state:init()
	--c[1] = wreck.new(c[1].x,c[1].y,c[1].angle,c[1].speed)
end


function state:enter()
	scoreinfo = ""
	timeout = 0
	truc = ""
	engine:stop()
	dispbase = false
	disptemps = false
	dispdegats = false
	dispzombie = false
	dispfinal = false
	inscore = score
	score_mt.fin()
	if awesomehitpoints then
		awesometext = "PERFECTION +"..500*diff.."\n"
	else
		awesometext = ""
	end
	if survivorhitpoints then
		awesometext = "SURVIVANT +"..100*diff.."\n"
	end

	hp = c[1].hitpoints
	c[1].flyby = true
	c[1].speed = 300
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
	if key=="return" or key==" " or key=="escape" then
		dispbase = true
		disptemps = true
		dispdegats = true
		dispzombie = true
		truc = ""
		timeout = 0
		scoreinfo =
			awesometext..
			"Score accu: "..scorepartie.."\nScore de la course: "..inscore..
			"\nTemps +"..bonustemps.."% - "..math.floor(bonustemps*(inscore/100))..
			"\nVie +"..bonusdegat.."% - "..math.floor(bonusdegat*(inscore/100))..
			"\nZombies +"..bonuszombie.."% - "..math.floor(bonuszombie*(inscore/100))
	end
end


function state:keyreleased(key, uni)
	
end

--[[
print("Score de base: "..score)
print("Bonus temps: "..bonustemps)
print("Bonus degats: "..bonusdegat)
print("Bonus zombie: "..bonuszombie)
print("Score final: "..score)
]]

function state:update(dt)
	fade = math.min(fade + dt,1)
	cheeky:setVolume((1-fade)*0.6)
	cheekyfade:setVolume((fade)*0.6)
	if timeout<0 then
		if not dispbase then
			scoreinfo = awesometext..scoreinfo.."Score accu: "..scorepartie.."\nScore de la course: "..inscore
			dispbase = true
			timeout = 1
			sounder.play("music/boom2.ogg",1+math.random()/10,1)
			comptage = 0
		elseif not disptemps then
			if comptage<bonustemps then
				comptage = comptage+1
				truc = "\nTemps +"..comptage.."% - "..math.floor(comptage*(inscore/100))
				sounder.play("music/Pickup_Coin"..math.random(1,4)..".wav",2,0.5)
			else
				disptemps = true
				scoreinfo=scoreinfo..truc
				truc = ""
				timeout = 1
				sounder.play("music/boom2.ogg",1+math.random()/10,1)
				comptage = 0
			end
		
		elseif not dispdegats then
			if comptage<bonusdegat then
				comptage = comptage+1
				truc = "\nVie +"..comptage.."% - "..math.floor(comptage*(inscore/100))
				sounder.play("music/Pickup_Coin"..math.random(1,4)..".wav",2,0.5)
			else
				dispdegats = true
				scoreinfo=scoreinfo..truc
				truc = ""
				timeout = 1
				sounder.play("music/boom2.ogg",1+math.random()/10,1)
				comptage = 0
			end
		elseif not dispzombie then
			if comptage<bonuszombie then
				comptage = comptage+1
				truc = "\nZombies +"..comptage.."% - "..math.floor(comptage*(inscore/100))
				sounder.play("music/Pickup_Coin"..math.random(1,4)..".wav",2,0.5)
			else
				dispzombie = true
				scoreinfo=scoreinfo..truc
				truc = ""
				timeout = 1
				sounder.play("music/boom2.ogg",1+math.random()/10,1)
				comptage = 0
			end
		elseif not dispfinal then
			dispfinal = true
			scoreinfo=scoreinfo.."\nScore final: "..score.."\n   Total: "..scorepartie+score
			timeout = 3
			sounder.play("music/boom2.ogg",1+math.random()/10,1)
		else
			score_mt.new()
			initgame()
			gstate.switch(roundstart)
		end
	else
		timeout = timeout-dt
	end
	updategame(dt)
end

function state:draw()
	love.graphics.setCanvas(overlay)
	love.graphics.setColor(255,255,255,255)
	love.graphics.print(scoreinfo..truc,midx-75,midy-40)
	love.graphics.setCanvas()
	drawgame()
end

return state

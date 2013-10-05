function resetgame()
	bonusmilitaire = 0
	bonuszombie = 0
	bonusdegat = 0
	bonustemps = 0
	totalkills = 0
	maxstreak = 0
	score=0
	scorepartie=0
	temps = 0
	diff = 0
	fade = 1
	past = 0
end

mess = {}
messnum = 0

function messages(s)
	table.insert(mess, {text=s,time=love.timer.getTime()})
	while #mess>3 do
		table.remove(mess, 1)
	end
end

function messagesupdate(dt)
	while mess[1] and mess[1].time+1<love.timer.getTime() do
			table.remove(mess, 1)
	end
	messnum = messnum + (#mess-messnum)*dt*5
end

function gameoverlay()
	love.graphics.setCanvas(overlay)
	love.graphics.setColor(255,255,255,255)
	--love.graphics.print("FPS: "..love.timer.getFPS(),10,10)
	
	love.graphics.print("Temps: "..100-math.floor(past*100)/100,20,10,0,2,2)
	
	local sc = "Score: "..score
	love.graphics.print(sc,midx-font:getWidth(sc),midy*2-20,0,2,2)
	for i,v in ipairs(mess) do
		love.graphics.print(v.text,midx-font:getWidth(v.text),midy*2-(i+messnum)*20,0,2,2)
	end
	if streak>=3 and lasthit>=0 then
		love.graphics.print("Combo x"..streak,midx-font:getWidth("Combo x"..streak),35,0,2,2)
	end
	local mc = "Max combo: "..maxstreak
	love.graphics.print(mc,midx*2-font:getWidth(mc)*2-20,10,0,2,2)
	local ts, di = "Score accumul<: "..scorepartie, "Round "..diff
	love.graphics.print(ts,midx*2-font:getWidth(ts)-10,midy*2-10)
	love.graphics.print(di,midx*2-font:getWidth(di)-10,midy*2-20)
	love.graphics.setCanvas()
end

function initflyby()
	levelend = false
	volmult = 0
	if past then
		temps = temps + past
	end
	past = 0
	prj = {}
	prjimpact = {}
	bombimpact = {}
	pointparts = {}
	permpart = {}
	splatable = {}
	bombs = {}
	bombdrop = 0
	lastrand = 0
	kills = 0
	streak = 0
	topscore = 0
	slowdown = 0
	lasthit = 0
	shake = 0
	hurt = 0
	firetime = 0
	zombies = {}
	zombiecases = {}
	grunts = {}
	cur = level.new()
	c = {}
	diff = 3
	cur:build(100)
	cur:set(50,50,"road")
	diff = 1
	c[1] = flyby.new(50.5*default.tilesize.x,50.5*default.tilesize.y,"ai")
	if hp then c[1].hitpoints = 100 end
	players = 1
	for i = 2,players do
		c[i] = aicart.new(c[1].x+math.random(-20,20),c[1].y+math.random(-20,20),"ai")
		c[i].name = "other"
	end
	--[[ Décommenter la ligne suivante pour jouer à deux... ]]
	--c[2] = cart.new(50.5*default.tilesize.x,50.5*default.tilesize.y,"point")
	--c[2].keys = {up={"z"},down={"s"},left={"q"},right={"d"}}
	--print(#zombies)
	x,y=0,0
	fade = 1
	cheekyfade:setVolume(0.6)
	cheeky:setVolume(0)
	cheeky:stop()
	darkness:play()
	cheekyfade:stop()
	engine:stop()
end

function initdemo()
	levelend = false
	volmult = 1
	if past then
		temps = temps + past
	end
	past = 0
	prj = {}
	prjimpact = {}
	bombimpact = {}
	pointparts = {}
	permpart = {}
	splatable = {}
	bombs = {}
	bombdrop = 0
	lastrand = 0
	kills = 0
	streak = 0
	topscore = 0
	slowdown = 0
	lasthit = 0
	shake = 0
	hurt = 0
	firetime = 0
	zombies = {}
	zombiecases = {}
	grunts = {}
	cur = level.new()
	c = {}
	diff = 8
	cur:build(100)
	cur:set(50,50,"road")
	c[1] = aicart.new(50.5*default.tilesize.x,50.5*default.tilesize.y,"ai")
	if hp then c[1].hitpoints = 100 end
	players = 1
	for i = 2,players do
		c[i] = aicart.new(c[1].x+math.random(-20,20),c[1].y+math.random(-20,20),"ai")
		c[i].name = "other"
	end
	--[[ Décommenter la ligne suivante pour jouer à deux... ]]
	--c[2] = cart.new(50.5*default.tilesize.x,50.5*default.tilesize.y,"point")
	--c[2].keys = {up={"z"},down={"s"},left={"q"},right={"d"}}
	--print(#zombies)
	x,y=0,0
	fade = 1
	cheekyfade:setVolume(0.6)
	cheeky:setVolume(0)
	cheeky:play()
	darkness:stop()
	cheekyfade:play()
	engine:play()
end

function initgame()
	if not (sendthread or getthread) then
		--sendthread= love.thread.newThread("send", "threadenvoie.lua")
		--getthread= love.thread.newThread("get", "threadreception.lua")
		--sendthread:start()
		--getthread:start()
	end
	--getthread:set("go",true)
	levelend = false
	if past then
		temps = temps + past
	end
	past = 0
	prj = {}
	prjimpact = {}
	bombimpact = {}
	pointparts = {}
	permpart = {}
	splatable = {}
	bombs = {}
	bombdrop = 0
	lastrand = 0
	kills = 0
	streak = 0
	topscore = 0
	slowdown = 0
	lasthit = 0
	shake = 0
	hurt = 0
	firetime = 0
	zombies = {}
	zombiecases = {}
	grunts = {}
	cur = level.new()
	c = {}
	cur:build(100)
	cur:set(50,50,"road")
	c[1] = cart.new(50.5*default.tilesize.x,50.5*default.tilesize.y,"ai")
	if hp then c[1].hitpoints = 100 end
	players = 1
	for i = 2,players do
		c[i] = aicart.new(c[1].x+math.random(-20,20),c[1].y+math.random(-20,20),"ai")
		c[i].name = "other"
	end
	--[[ Décommenter la ligne suivante pour jouer à deux... ]]
	--c[2] = cart.new(50.5*default.tilesize.x,50.5*default.tilesize.y,"point")
	--c[2].keys = {up={"z"},down={"s"},left={"q"},right={"d"}}
	diff = diff + 1
	--print(#zombies)
	x,y=0,0
	fade = 1
	volmult = 1
	cheekyfade:setVolume(0.6)
	cheeky:setVolume(0)
	cheeky:play()
	darkness:stop()
	cheekyfade:play()
	engine:play()
end

function updategame(dt)
	messagesupdate(dt)
	lasthit = math.max(lasthit-(dt*2), 0)
	if lasthit<=0 and streak>=3 then
		local before = score
		score_mt.endstreak()
		local after = score
		messages("Bonus +"..after-before)
		streak = 0
	end
	hurt = math.max(hurt-(dt), 0)
	for i,v in ipairs(prj) do
		v:update(dt)
	end
	zombiecases = {}
	for i,v in ipairs(zombies) do
		if not v.purge and cur.camera:check(v.x,v.y) then
			v:update(dt)
			local zx,zy = useful.getTile(v.x,v.y)
			local n = cur:get(zx,zy).number
			if zombiecases[n] then
				table.insert(zombiecases[n],v)
			else
				zombiecases[n]={}
				table.insert(zombiecases[n],v)
			end
		end
	end

	gruntcases = {}
	for i,v in ipairs(grunts) do
		if cur.camera:check(v.x,v.y) then
			--v:update(dt/2)
			local zx,zy = useful.getTile(v.x,v.y)
			local n = cur:get(zx,zy).number
			if gruntcases[n] then
				table.insert(gruntcases[n],v)
			else
				gruntcases[n]={}
				table.insert(gruntcases[n],v)
			end
		end
	end

	for k,u in pairs(gruntcases) do
		for i,v in ipairs(u) do
			v:update(dt)
		end
	end
	for i,v in ipairs(c) do
		v:update(dt*0.9)
	end
	bombdrop = bombdrop-dt
	if bombdrop<=0 then
		bombdrop = (2+math.random())/diff
		local px,py = useful.getTile(c[1].x,c[1].y)
		local playernum = cur:get(px,py).number
		--local tx1,ty1,tx2,ty2 = cur.camera:getTileBounds()
		local tx1,ty1,tx2,ty2 = px-3,py-3,px+3,py+3
		local potentials = {}
		for i=tx1,tx2 do
			for j=ty1,ty2 do
				if math.random()>0.9 or (cur:get(i,j).number>3 and cur:get(i,j).number>playernum-3 and cur:get(i,j).number<playernum+5) then
					table.insert(potentials,{x=i,y=j})
				end
			end
		end
		if #potentials>=1 then
			local t = math.random(1,#potentials)
			table.insert(bombs,bomb.new((potentials[t].x+math.random())*default.tilesize.x,(potentials[t].y+math.random())*default.tilesize.y))
		end
	end
	for i,v in ipairs(bombs) do
		v:update(dt)
	end
	cur:update(dt)
	splatter.update(dt, prjimpact, 250)
	splatter.update(dt, bombimpact, 250)
	splatter.update(dt, pointparts, 30)
	for i=1,#permpart-100 do
		table.remove(permpart,1)
	end
	useful.purge()
end

function drawgame()
	love.graphics.setColor(255,255,255,255)
	local z = 0
	local players = 1
	i = i or 1
	for n,v in ipairs(c) do
		if cur:get(math.floor(v.x/default.tilesize.x),math.floor(v.y/default.tilesize.y)).number > cur:get(math.floor(c[i].x/default.tilesize.x),math.floor(c[i].y/default.tilesize.y)).number then
			i = n


		end
	end
	f = i
	love.graphics.push()
	love.graphics.setCanvas(screenbox)
	love.graphics.setColor(0,0,0)
	love.graphics.rectangle("fill",0,0,1024,1024)
	love.graphics.setColor(255,255,255)
	useful.setMultiScreen(i, players)
	love.graphics.translate(math.floor(-c[i].x+love.graphics.getWidth()/(2*players))-(love.graphics.getWidth()/(default.scale)),math.floor((-c[i].y+love.graphics.getHeight()/2))-(love.graphics.getHeight()/(default.scale)))
	cur.camera:pointAt(useful.roundTo(c[i].x,default.scale),useful.roundTo(c[i].y,default.scale))
	local bx,by = cur.camera:getBounds()
	love.graphics.setBlendMode("alpha")
	cur:draw()
	splatter.draw(permpart, 1)
	love.graphics.setColor(255,255,255)
	local r,g,b,a = love.graphics.getColor()
	--love.graphics.setColor(64,190,64)
	zombimbatch:clear()
	zombackbatch:clear()
	for i,v in ipairs(zombies) do
		--love.graphics.setBlendMode("additive")
		if cur.camera:check(v.x,v.y) then
			v:draw()
			z=z+1
		end
	end
	love.graphics.draw(zombimbatch)
	love.graphics.draw(zombackbatch)
	for i,v in ipairs(grunts) do
		if cur.camera:check(v.x,v.y) then
			v:draw()
		end
	end
	love.graphics.setColor(r,g,b,a)
	local q = true
	local rem = 0
	for i,v in ipairs(c) do
		if cur.camera:check(v.x,v.y) then
			if i==1 then
				--love.graphics.setBlendMode("subtractive")
			else
				--love.graphics.setBlendMode("additive")
			end
			v:draw()
		else
			v.x = c[f].x+math.random(-3,3)
			v.y = c[f].y+math.random(-3,3)
			v.angle = c[f].angle
			v.speed = c[f].speed*0.75
		end
		if cur:get(math.floor(v.x/default.tilesize.x),math.floor(v.y/default.tilesize.y)).number == cur.last and not v.time then
			v.time = past or 0
		end
		if not v.time then
			q = false
			rem = rem + 1
		else
			
		end
	end
	if q then
		for i,v in ipairs(c) do
			if cur.camera:check(v.x,v.y) then
				--print(i, math.floor(v.time*100)/100)
			end
		end
		levelend = true
	end
	love.graphics.setColor(255,255,0,64)
	love.graphics.setBlendMode("additive")
	for i,v in ipairs(prj) do
		if cur.camera:check(v.x,v.y) then
			v:draw()
		end
	end
	for i,v in ipairs(bombs) do
		v:draw()
	end
	love.graphics.setBlendMode("alpha")
	splatter.draw(prjimpact)
	--print(#pointparts)
	splatter.draw(pointparts)
	love.graphics.setColor(255,255,255)
	cur:draw(true)
	splatter.draw(bombimpact)
	love.graphics.setBlendMode("alpha")
	love.graphics.setScissor()
	love.graphics.pop()
	love.graphics.setColor(255*(1-c[1].hitpoints/100),0,0,255)
	local scale = math.max(love.graphics.getWidth(),love.graphics.getHeight())/(512*default.scale)
	love.graphics.setBlendMode("additive")
	love.graphics.draw(bigvig,love.graphics.getWidth()/(default.scale*2),love.graphics.getHeight()/(default.scale*2),0,scale,scale,256,256)
	love.graphics.setColor(255,0,0,255*(1-c[1].hitpoints/100))
	love.graphics.draw(bigpain,love.graphics.getWidth()/(default.scale*2),love.graphics.getHeight()/(default.scale*2),0,scale,scale,256,256)
	love.graphics.setBlendMode("alpha")
	love.graphics.setCanvas()
	love.graphics.push()
	love.graphics.setColor(255,255,255,255)
	love.graphics.setCanvas(otherbox)
	--love.graphics.setBlendMode("additive")
	local val = math.max(lasthit,slowdown,shake)
	local offx,offy= math.random(-100,100),math.random(-100,100)
	lastrand = (lastrand+(math.random(-30,30)))/20
	love.graphics.translate(offx+(love.graphics.getWidth()/(default.scale*2)),offy+(love.graphics.getHeight()/(default.scale*2)))
	love.graphics.rotate(val*lastrand/(100))
	love.graphics.translate(-(offx)-(love.graphics.getWidth()/(default.scale*2)),-(offy)-(love.graphics.getHeight()/(default.scale*2)))
	love.graphics.draw(screenbox,0,0)
	love.graphics.pop()
	love.graphics.setCanvas()
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(otherbox,0,0,0,default.scale,default.scale)
	love.graphics.setColor(255,255,255,255)
	love.graphics.draw(overlay,0,0,0,default.scale,default.scale)
	love.graphics.setColor(255,255,255,255)
	love.graphics.setBlendMode("alpha")
	--love.graphics.setScissor(0,0,0,0)

	--love.graphics.scale(1,1)
	local r,g,b,a = love.graphics.getColor()
	love.graphics.setBlendMode("alpha")
	love.graphics.setColor(0,0,0,255)
	scale = math.max(love.graphics.getWidth(),love.graphics.getHeight())/512
	love.graphics.draw(bigvig,love.graphics.getWidth()/(2),love.graphics.getHeight()/(2),0,scale,scale,256,256)
	love.graphics.setBlendMode("additive")
	love.graphics.setColor(255*hurt/2,127*slowdown,0,255)
	love.graphics.draw(bigvig,love.graphics.getWidth()/(2),love.graphics.getHeight()/(2),0,scale,scale,256,256)
	--love.graphics.setColor(255*(1-c[1].hitpoints/100),0,0,255)
	--love.graphics.draw(bigpain,love.graphics.getWidth()/(2),love.graphics.getHeight()/(2),0,scale,scale,256,256)
	--love.graphics.point(love.graphics.getWidth()/(2),love.graphics.getHeight()/(2))
	love.graphics.setBlendMode("alpha")
	overlay:clear()
	love.graphics.setColor(255,255,255,255)
end

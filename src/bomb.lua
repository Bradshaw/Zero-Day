local bomb_mt = {}
bomb = {}

bombim = love.graphics.newImage("images/missile.png")

function bomb.new(x,y)
	local self = setmetatable({},{__index=bomb_mt})
	self.x = x
	self.y = y
	self.drop = 150
	self.off = math.random(-30,30)
	self.angle=math.sin(self.off/150)
	local tx,ty = useful.getTile(self.x,self.y)
	if cur:get(tx,ty).typ=="road" and not c[1].flyby then
		sounder.play("music/beep.ogg",1.5,0.3)
	end
	return self
end

function bomb_mt.update(self,dt)
	self.drop = math.max(0,self.drop-dt*150)
	splatter.addJet(self.x+(self.drop/100)*self.off,self.y-self.drop*3,self.angle+math.pi/2,bombimpact)
	if not self.purge and self.drop<=0 then
		for i=1,30 do
			splatter.add(splatter.newExplodeFire(self.x+math.random()*5,self.y+math.random()*5,-math.pi/2,math.random()*500),bombimpact)
			splatter.add(splatter.newDarkSmoke(self.x,self.y,math.random()*math.pi*2),bombimpact)
		end
		for i=1,30 do
			table.insert(prj,projectile.new(self.x,self.y,(i/30)*math.pi*2,true))
		end
		for i=1,10 do
			splatter.add(splatter.newExplodeFire(self.x+math.random()*5,self.y+math.random()*5,math.random()*math.pi*2,math.random()*300),bombimpact)
		end
		if cur.camera:check(self.x,self.y) then
			sounder.play("music/Explosion"..math.random(3,8)..".wav",1+math.random()/10,1)
			sounder.play("music/boom2.ogg",1+math.random()/10,1)
			--sounder.play("music/boom.ogg",0.3,0.6)
		else
			sounder.play("music/Explosion"..math.random(3,8)..".wav",1+math.random()/10,0.6)
			--sounder.play("music/boom.ogg",0.3,0.6)
			--sounder.play("music/boom.ogg",0.3,0.3)
		end
		self.purge = true
	end
end

function bomb_mt.draw(self)
	if not self.purge then
		
		local tx,ty = useful.getTile(self.x,self.y)
		if cur:get(tx,ty).typ=="road" then
			love.graphics.setColor(255,0,0,255*(1-self.drop/150))
			if math.floor(self.drop/5)%2==0 then
				love.graphics.circle("line",self.x,self.y,math.pow(self.drop/10,1.5))
			else
				love.graphics.circle("fill",self.x,self.y,math.pow(self.drop/10,1))
			end
		end
		love.graphics.setColor(255,255,255)
		--love.graphics.rectangle("fill",self.x-5,self.y-5-self.drop*3,10,10)
		love.graphics.draw(bombim,self.x-3+(self.drop/100)*self.off,self.y-5-self.drop*3,self.angle)
	end
end

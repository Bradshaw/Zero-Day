local splatter_mt = {}
local splatarray = {}
splatter = {}

function splatter.newParticle(x,y,angle,speed,life)
	local self = setmetatable({},{__index=splatter_mt})
	self.x = x
	self.y = y
	self.angle = angle
	self.speed = speed
	self.life = life
	return self
end

function splatter.newPoints(text)
	local self = splatter.newParticle(c[1].x,c[1].y,-math.pi/2+math.random()*2-1,math.random()*600+200,0.5)
	self.text = text
	self.fx, self.fy = self.x, self.y
	--print(self.text, self.x, self.y, self.angle)
	function self:draw()
		--print(self.x,self.y)
		love.graphics.setColor(255,255,255)
		love.graphics.print(self.text, c[1].x+self.x-10-self.fx,c[1].y+self.y-20-self.fy)
	end
	function self:update(dt)
		if not self.purge then
			self.speed = self.speed - self.speed*dt*10
			self.life = self.life-dt
			if self.life>0 then
				local x, y = useful.polarToCartesian(self.angle, self.speed*dt)
				self.x = self.x+x
				self.y = self.y+y
			else
				self.purge=true
			end
		end
	end
	return self
end

function splatter.newGib(x,y,angle,piece)
	local self = splatter.newParticle(x,y,-angle,20,3)
	self.alt = -5
	self.piece = piece
	self.acc = -(10+math.random()*20)
	self.rot = math.random()*10-5
	self.spin = 0
	self.splurt = 0
	self.tex = animated.new("images/gibs.png",1,3)
	--print("Test?")
	function self:draw()
		love.graphics.setColor(180,90,90)
		self.tex:draw(self.x,self.y+self.alt,self.spin,1,self.piece)
	end
	function self:update(dt)
		if not self.purge then
			self.life = self.life-dt
			self.spin = self.spin + dt*self.rot
			self.acc = self.acc + 100*dt
			self.alt = self.alt + self.acc*dt
			self.splurt = self.splurt - dt
			if self.splurt<=0 and self.life>1.5 then
				self.splurt = 0.1+math.random()
				splatter.add(splatter.newBlood(self.x,self.y,math.pi/2),prjimpact)
			end
			if self.alt>=0 then
				self.alt = -self.alt
				self.acc = -self.acc*0.3
				self.rot = self.rot*0.3
				self.speed = self.speed*0.3
			end
			if self.life>0 then
				local x, y = useful.polarToCartesian(self.angle, self.speed*dt)
				self.x = self.x+x
				self.y = self.y+y
			else
				self.purge = true
				table.insert(permpart,self)
			end
		end
	end
	return self
end

function splatter.newBlood(x,y,angle)
	local self = splatter.newParticle(x,y-5,angle+math.random()-0.5,math.random()*25,0.3)
	self.alt = -5
	self.acc = 0
	self.fullife = self.life
	self.r = 50+math.random()*100
	self.rot = math.random()*math.pi*2
	self.tex = animated.new("images/splat.png",8,1)
	function self:draw()
		love.graphics.setColor(self.r,0,0,180)
		self.tex:draw(self.x,self.y,self.rot,math.floor((1-self.life/(self.fullife))*8),1)
		--love.graphics.point(self.x,self.y)
	end
	function self:update(dt)
		if not self.purge then
			self.life = self.life-dt
			self.acc = self.acc + 100*dt
			self.alt = self.alt + self.acc*dt
			if self.alt>=0 then
				self.alt = 0
				self.acc = 0
				self.speed = 0
			end
			if self.life>0 then
				local x, y = useful.polarToCartesian(self.angle, self.speed*dt)
				self.x = self.x+x
				self.y = self.y+y
			else
				self.purge=true
				self.life = 0.01
				table.insert(permpart,self)
			end
		end
	end
	return self
end

function splatter.newMuzzle(x,y,angle)
	local self = splatter.newParticle(x,y,angle,math.random()*100,math.random()/10)
	function self:draw()
		if not self.purge then
			love.graphics.setColor(255,150+math.random()*100,0)
			love.graphics.point(self.x,self.y)
		end
	end
	return self
end

function splatter.newCasing(x,y,angle)
	local self = splatter.newParticle(x,y,-angle,1,3)
	self.alt = -5
	self.acc = -(10+math.random()*20)
	self.g = 75+math.random()*25
	self.rot = math.random()*5
	self.spin = math.random(1,8)
	self.tex = animated.new("images/casing.png",8,1)
	function self:draw()
		love.graphics.setColor(100,self.g,0)
		self.tex:draw(math.floor(self.x),math.floor(self.y+self.alt),0,math.floor(self.spin),1)
	end
	function self:update(dt)
		if not self.purge then
			self.life = self.life-dt
			self.spin = self.spin + dt*self.rot
			self.acc = self.acc + 100*dt
			self.alt = self.alt + self.acc*dt
			if self.alt>=0 then
				self.alt = -self.alt
				self.acc = -self.acc*0.75
				self.rot = self.rot*0.75
				self.speed = self.speed*0.75
			end
			if self.life>0 then
				local x, y = useful.polarToCartesian(self.angle, self.speed*dt)
				self.x = self.x+x
				self.y = self.y+y
			else
				self.purge = true
				table.insert(permpart,self)
			end
		end
	end
	return self
end

function splatter.newMuzzleSmoke(x,y,angle)
	local self = splatter.newParticle(x,y,angle+math.random()-0.5,math.random()*30,math.random()/3)
	self.tex = animated.new("images/splat.png",8,1)
	self.fullife = self.life
	self.g = math.random()*255
	self.g = math.random()*100
	self.rot = math.random()*math.pi*2
	function self:draw()
		if not self.purge then
			love.graphics.setColor(self.g,self.g,self.g,64)
			self.tex:draw(self.x,self.y,self.rot,math.floor((1-self.life/(self.fullife))*8),1)
		end
	end
	return self
end

function splatter.newDarkSmoke(x,y,angle)
	local self = splatter.newParticle(x,y,angle+math.random()-0.5,math.random()*30,math.random())
	self.tex = animated.new("images/splat.png",8,1)
	self.fullife = self.life
	self.rot = math.random()*math.pi*2
	self.g = math.random()*100
	function self:draw()
		if not self.purge then
			love.graphics.setColor(self.g,self.g,self.g,64)
			self.tex:draw(self.x,self.y,self.rot,math.floor((1-self.life/(self.fullife))*8),1)
		end
	end
	return self
end

function splatter.newFire(x,y,angle)
	local self = splatter.newParticle(x,y,angle+math.random()-0.5,math.random()*30,math.random()/2)
	self.tex = animated.new("images/splat.png",8,1)
	self.fullife = self.life
	self.g = 50+math.random()*150
	self.rot = math.random()*math.pi*2
	function self:draw()
		if not self.purge then
			love.graphics.setColor(255,self.g,0,255)
			self.tex:draw(self.x,self.y,self.rot,math.floor((1-self.life/(self.fullife))*8),1)
		end
	end
	return self
end

function splatter.newExplodeFire(x,y,angle,speed)
	local self = splatter.newParticle(x,y,angle+math.random()-0.5,speed,math.random()/2)
	self.tex = animated.new("images/splat.png",8,1)
	self.fullife = self.life
	self.rot = math.random()*math.pi*2
	self.g = 50+math.random()*150
	function self:draw()
		if not self.purge then
			if self.life>0.8*self.fullife then
				love.graphics.setColor(255,255,255)
				love.graphics.circle("fill",self.x,self.y,5)	
			end
			love.graphics.setColor(255,self.g,0,255)
			self.tex:draw(self.x,self.y,self.rot,math.floor((1-self.life/(self.fullife))*8),1)
		end
	end
	function self:update(dt)
		if not self.purge then
			self.life = self.life-dt
			self.speed = self.speed - self.speed*dt*10
			if self.life>0 then
				if math.random()>0.5 then
					--splatter.add(splatter.newMuzzleSmoke(self.x,self.y,math.random()*math.pi*2), prjimpact)
				end
				local x, y = useful.polarToCartesian(self.angle, self.speed*dt)
				self.x = self.x+x
				self.y = self.y+y
			else
				self.purge=true
			end
		end
	end
	return self
end

function splatter.addBloodsplosion(x,y,array)
	for i=1,1 do
		splatter.add(splatter.newBlood(x,y,math.pi/2),array)
	end
	for i=1,3 do
		splatter.add(splatter.newGib(x,5+y-i*3,math.random()*math.pi*2,i),array)
		splatter.add(splatter.newBlood(x,y,math.random()*math.pi*2),array)
	end
end

function splatter.addBlood(x,y,angle,array)
	for i=1,1 do
		splatter.add(splatter.newBlood(x+math.random()*2-1,y+math.random()*2-1,angle),array)
	end
	for i=1,1 do
		splatter.add(splatter.newBlood(x+math.random()*2-1,y+math.random()*2-1,angle+math.pi),array)
	end
end

function splatter.addMuzzle(x,y,angle,array)
	for i=1,7 do
		splatter.add(splatter.newMuzzleSmoke(x+math.random()*2-1,y+math.random()*2-1,angle),array)
	end
	for i=1,15 do
		splatter.add(splatter.newMuzzle(x+math.random()*2-1,y+math.random()*2-1,angle),array)
	end
	if math.random()>0.5 then
		splatter.add(splatter.newCasing(x,y,math.random()*math.pi*2),array)
	end
end

function splatter.addJet(x,y,angle,array)
	for i=1,7 do
		splatter.add(splatter.newMuzzleSmoke(x+math.random()*2-1,y+math.random()*2-1,angle),array)
	end
	for i=1,15 do
		splatter.add(splatter.newMuzzle(x+math.random()*2-1,y+math.random()*2-1,angle),array)
	end
end

function splatter.add(particle, array)
	local t = array or splatarray
	table.insert(t, particle)
end

function splatter.update(dt, array, max)
	local t = array or splatarray
	for i,v in ipairs(t) do
		if cur.camera:check(v.x,v.y) then
			if not v.purge then
				v:update(dt)
			end
		else
			v.purge = true
		end
	end
	for i=#t,1,-1 do
		if t[i].purge then
			table.remove(t, i)
		end
	end
	if max and #t>max then
		for _=1,#t-max do
			table.remove(t, 1)	
		end
	end
end

function splatter.draw(array, ignorepurge)
	local t = array or splatarray
	for i,v in ipairs(t) do
		if v.text or cur.camera:check(v.x,v.y) then
			if not v.purge or ignorepurge then
				v:draw()
			end
		end
	end
end



function splatter_mt.update(self, dt)
	if not self.purge then
		self.life = self.life-dt
		if self.life>0 then
			local x, y = useful.polarToCartesian(self.angle, self.speed*dt)
			self.x = self.x+x
			self.y = self.y+y
		else
			self.purge=true
		end
	end
end

function splatter_mt.draw(self)
	if not self.purge then
		love.graphics.point(self.x,self.y)
	end
end
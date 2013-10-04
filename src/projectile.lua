local projectile_mt={}
projectile={}

function projectile.new(x,y,d,b)
	local self = setmetatable({},{__index=projectile_mt})
	self.x = x
	self.y = y
	self.bomb = b
	self.xold = x
	self.yold = y
	self.d = d
	if self.bomb then
		self.time = math.random()/15
		self.speed = math.random()*400+200
	else
		self.time = 0.4
		self.speed = 400
	end
	return self
end

function projectile_mt.update(self,dt)
	if not self.purge then
		self.time=math.max(0,self.time-dt)
		local tx,ty = useful.getTile(self.x,self.y)
		if self.time>0 and not cur:get(tx,ty).collide then
			for i = #zombies,1,-1 do
				local dx,dy = self.x-zombies[i].x,self.y-zombies[i].y
				if not zombies[i].purge and math.sqrt(dx*dx+dy*dy)<5 then
					splatter.addBlood(self.x,self.y,self.d,prjimpact)
					self.purge = not self.bomb
					if self.bomb then
						zombies[i].hitpoints = zombies[i].hitpoints - 40
					else
						zombies[i].hitpoints = zombies[i].hitpoints - 10
					end
				end
			end
			for i = #c,1,-1 do
				local dx,dy = self.x-c[i].x,self.y-c[i].y
				if not c[i].purge and math.sqrt(dx*dx+dy*dy)<20 then
					if self.bomb and not c[1].wreck and not c[1].flyby then
						for i=1,10 do
							splatter.add(splatter.newParticle(self.x,self.y,math.random()*math.pi*2,250,0.02),prjimpact)
						end
						sounder.play("music/Pain"..math.random(1,6)..".wav",1,1)
						self.purge = not self.bomb
						c[i].hitpoints = c[i].hitpoints - 1
						shake = shake + 1
						hurt = 1
					end
				end
			end
			for i = #grunts,1,-1 do
				local dx,dy = self.x-grunts[i].x,self.y-grunts[i].y
				if self.time<0.1 and not grunts[i].purge and math.sqrt(dx*dx+dy*dy)<5 then
					for i=1,10 do
						splatter.add(splatter.newParticle(self.x,self.y,math.random()*math.pi*2,250,0.02),prjimpact)
					end
					self.purge = not self.bomb
					--grunts[i].hitpoints = grunts[i].hitpoints - 10
				end
			end
			self.xold = self.x
			self.yold = self.y
			local a,d = useful.cartesianToPolar(self.x,self.y)
			local x, y = useful.polarToCartesian(self.d, self.speed*dt)
			self.x = self.x+x
			self.y = self.y+y
		else
			self.purge = true
		end
	end
end

function projectile_mt.draw(self)
	if not self.purge then
		love.graphics.line(self.x,self.y-4,self.xold,self.yold-4)
		love.graphics.line(self.x,self.y-4,(self.xold+self.x)*0.5,(self.yold+self.y)*0.5-4)
	end
end
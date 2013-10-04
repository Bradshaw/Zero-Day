zombie={}
local zombie_mt=setmetatable({},{__index=entity_mt})

zombim = love.graphics.newImage("images/char.png")
zomback = love.graphics.newImage("images/charback.png")
zombimbatch = love.graphics.newSpriteBatch(zombim,1000)
zombackbatch = love.graphics.newSpriteBatch(zomback,1000)

function zombie.new(x,y)
	local self = setmetatable(entity.new(x,y,"huntai"),{__index=zombie_mt})	
	self.power = math.random(100,150)
	self.off = math.random()*math.pi*2
	self.braking = 100
	self.rot = 12
	self.hitpoints = 100
	self.angle = math.random()*math.pi*2
	self.bumped = 0
	
	return self
end

function zombie_mt.intention(self, dt)
	-- Je détermine l'intention du zombie
	local px,py = useful.getTile(c[1].x,c[1].y)
	local playernum = cur:get(px,py).number
	local tx1,ty1,tx2,ty2 = self.collideCam:getTileBounds()
	local cx = tx1+1
	local cy = ty1+1
	local nx,ny = cx,cy
	local go = 0
	local behind = 1
	if playernum>cur:get(cx,cy).number and playernum<=cur:get(cx,cy).number+5 then
		go = 1
	elseif playernum<cur:get(cx,cy).number and playernum>=cur:get(cx,cy).number-5 then
		go = -1
	elseif playernum~=cur:get(cx,cy).number and not c[1].flyby then
		self.hitpoints = 100
	end
	local head = playernum - cur:get(cx,cy).number
	local targetx, targety = cx,cy
	for i=tx1,tx2 do
		for j=ty1,ty2 do
			
			if cur:get(i,j).number==cur:get(nx,ny).number+go then
				
				targetx = i
				targety = j
			end
		end	
	end
	local xv = targetx-cx
	local yv = targety-cy
	local dir=false
	if yv == -1 then
		dir = 2-xv
	elseif yv==1 then
		dir = 6+xv
	else
		if xv==-1 then
			dir=4
		elseif xv==1 then
			dir=0
		end
	end
	if playernum==cur:get(cx,cy).number then
		local pangle = math.atan2(c[1].y-self.y,c[1].x-self.x)-math.pi/2
		dir = (math.floor((-pangle/(math.pi*2))*8-1)%8)
	end
	local curd = (math.floor((-self.angle/(math.pi*2))*8-1)%8)

	-- Si le zombie peut choisir une direction alors s'y diriger
		-- dir vaut false si le joueur est sur la même case que le zombie
		-- sinon dir est un nombre qui indique vers quelle case se diriger.
		-- curd est la direction actuelle du zombie
	if dir and not c[1].flyby then
		local m = (curd-dir)%8
		if m>=2.5 and m<=5.5 then
			self:brake(dt)
		else
			self:accelerate(dt*behind)
		end
		if m>0 and m<=4 then
			self:steer("right",dt)
		else
			self:steer("left",dt)
		end
	else
		self:accelerate(dt/2)
		if math.sin(self.off+past)>0 then
			self:steer("left",dt/10)
		else
			self:steer("right",dt/10)
		end
	end
end

function zombie_mt.update(self,dt)
	self.bumped = self.bumped-dt
	-- Si le zombie est visible par la camera alors
	if cur.camera:check(self.x,self.y) and not self.purge and self.hitpoints>0 then

		self:intention(dt)
		-- Gestion des collisions
		self.speed = self.speed-self.speed*dt*2
		self.nudgex = self.nudgex-self.nudgex*dt*2
		self.nudgey = self.nudgey-self.nudgey*dt*2
		for k,v in pairs(c) do
			if self~=v and self.collideCam:check(v.x,v.y) then
				local dx = self.x-v.x
				local dy = self.y-v.y
				local dist = math.sqrt(dx*dx+dy*dy)
				if dist<10 and not c[1].flyby then
					if dx~=0 and dy~=0 then
						if v.speed>500 then
							if lasthit>0 then
								streak = streak + 1
								laststreak = streak.."-kill streak! +"..math.floor(streak*math.log(streak)).." points"
							else
								disp = 1
								laststreak = streak.."-kill streak! +"..math.floor(streak*math.log(streak)).." points"
								score_mt.endstreak()
								streak = 1
							end
							v.speed=v.speed*0.915
							self.hitpoints = 0
							shake = shake + 1
							kills = kills + 1
							splatter.addBloodsplosion(self.x,self.y,prjimpact)
							sounder.play("music/Hurt"..math.random(1,3)..".wav",1,1)
							sounder.play("music/Pickup_Coin"..math.random(1,4)..".wav",1,1)
							local sb = score
							score_mt.kill()
							splatter.add(splatter.newPoints("+"..score-sb),bombimpact)
							if streak==10 then
								--splatter.add(splatter.newPoints("BULLET TIME!"),pointparts)
							end
							self.purge = true
							lasthit = 1
						else
							
							if self.bumped<=0 then
								v.speed=v.speed*0.9
								shake = shake + 1
								hurt = 1
								if v.speed<350 and not c[1].wreck then
									v.hitpoints = v.hitpoints-math.random(1,5)
									sounder.play("music/Pain"..math.random(1,6)..".wav",1,1)
								end
								self.bumped=0.3
							end
				
						end
						self.nudgex = ((dx/math.abs(dx)) * 50-dist)
						self.nudgey = ((dy/math.abs(dy)) * 50-dist)
					end
				end
			end
		end
		local bindangle = math.floor((0.5+self.angle)/(math.pi/4))*(math.pi/4)
		local px = self.x + self.speed * math.sin(-bindangle) * dt +self.nudgex * dt
		local py = self.y + self.speed * math.cos(-bindangle) * dt * default.tilt + self.nudgey * dt * default.tilt
		local thisx = math.floor(self.x/default.tilesize.x)
		local thisy = math.floor(self.y/default.tilesize.y)
		local nextx = math.floor(px/default.tilesize.x)
		local nexty = math.floor(py/default.tilesize.y)
		if cur:get(nextx,nexty).collide or cur:get(thisx,nexty).collide or cur:get(nextx,thisy).collide then
			self.speed=self.speed*0.8


			if  not cur:get(thisx,nexty).collide then
				self.y = py
				off = ((self.angle/(math.pi*2))*2)%1
				if thisx>nextx then
					self.nudgex = 50
				else
					self.nudgex = -50
				end
				if off>0.5 then
					
					self.angle = self.angle+0.5
					
				elseif off<0.5 then
					
					self.angle = self.angle-0.5
					
				else
				end
			end
			if not cur:get(nextx,thisy).collide then
				self.x = px
				off = (((math.pi/2+self.angle)/(math.pi*2))*2)%1
				if thisy>nexty then
					self.nudgey = 50
				else
					self.nudgey = -50
				end
				if off>0.5 then
					self.angle = self.angle+0.5
				elseif off<0.5 then
					self.angle = self.angle-0.5
				else
					--self.speed = -self.speed
				end
			end
		else
			self.x = px
			self.y = py
		end

			
		self.collideCam:pointAt(self.x,self.y)
	elseif self.hitpoints<0 and not self.purge then
		splatter.addBloodsplosion(self.x,self.y,prjimpact)
		sounder.play("music/Hurt"..math.random(1,3)..".wav",1,1)
		self.purge = true
	end
end

function zombie_mt.steer(self,direction,dt)
	if direction=="left" then
		self.angle=self.angle - dt*self.rot
	elseif direction=="right" then
		self.angle=self.angle + dt*self.rot
	end
end

function zombie_mt.draw(self)
	local qu = math.floor(((-self.angle+math.pi/8)/math.pi)*8+3.5)%16+1
	local r,g,b,a = love.graphics.getColor()
	local bindangle = math.floor((0.4+self.angle)/(math.pi/4))*(math.pi/4)
	if (bindangle+math.pi/2)%(math.pi*2)>math.pi/2 and (bindangle+math.pi/2)%(math.pi*2)<3*math.pi/2 then
		if (bindangle)%(math.pi*2)>math.pi/2 and (bindangle)%(math.pi*2)<3*math.pi/2 then
		--love.graphics.draw(zomback,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,-1,1,3,9)
		zombackbatch:add(useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,-1,1,3,9)
		else
			--love.graphics.draw(zombim,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,-1,1,3,9)
			zombimbatch:add(useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,-1,1,3,9)
		end
	else
		if (bindangle)%(math.pi*2)>math.pi/2 and (bindangle)%(math.pi*2)<3*math.pi/2 then
		--love.graphics.draw(zomback,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,3,9)
		zombackbatch:add(useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,3,9)
		else
			--love.graphics.draw(zombim,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,3,9)
			zombimbatch:add(useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,3,9)
		end
	end
	local dx,dy = useful.polarToCartesian(self.angle+math.pi/2,10)
	--love.graphics.line(self.x,self.y,useful.roundTo(self.x+dx,default.scale),useful.roundTo(self.y+dy,default.scale))
	love.graphics.setColor(r,g,b,a)
end
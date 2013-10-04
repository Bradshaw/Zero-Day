--[[
military : Un connard qui tir de partout

]]

military={}
local military_mt = setmetatable({},{__index=entity_mt})

milim = love.graphics.newImage("images/mili.png")
milback = love.graphics.newImage("images/miliback.png")

shots = 0
function military.new(x,y,cmode)
	local self = setmetatable(entity.new(x,y,cmode),{__index=military_mt})
	self.power = 200
	self.braking = 100
	self.off = math.random()*math.pi*2
	self.rot = 12
	self.angle = math.random()*math.pi*2
	self.firetime=0
	self.bindangle = math.floor((0.4+self.angle)/(math.pi/4))*(math.pi/4)
	return self
end

function military_mt.intention(self,dt)
	local px,py = useful.getTile(self.x,self.y)
	local macase = cur:get(px,py).number
	self.firetime = self.firetime-dt
	if self.firetime<-1 then
		self.bindangle = math.floor((0.4+self.angle)/(math.pi/4))*(math.pi/4)+math.pi*2
	end
	if(zombiecases[macase]) and self.firetime<=0 then
		--print(zombiecases[macase][1].x,zombiecases[macase][1].y,zombiecases[macase][1].angle+math.pi/2+math.random(-100,100)/3000)
		local anglez=math.atan2(zombiecases[macase][1].y-self.y,zombiecases[macase][1].x-self.x)
		table.insert(prj,projectile.new(self.x,self.y,anglez+math.random(-100,100)/1000))
		self.firetime = 0.20+math.random()/30
		shots = shots+1
		sounder.play("music/Laser_Shoot"..math.random(1,6)..".wav",1,0.3)
		splatter.addMuzzle(self.x,self.y-5,anglez,prjimpact)
		self.bindangle = math.floor((0.4+anglez-math.pi/2)/(math.pi/4))*(math.pi/4)+math.pi*2
	end
	if(zombiecases[macase+1]) and self.firetime<=0 then
		local anglez=math.atan2(zombiecases[macase+1][1].y-self.y,zombiecases[macase+1][1].x-self.x)
		table.insert(prj,projectile.new(self.x,self.y,anglez+math.random(-100,100)/1000))
		self.firetime = 0.20+math.random()/30
		shots = shots+1
		sounder.play("music/Laser_Shoot"..math.random(1,6)..".wav",1,0.3)
		splatter.addMuzzle(self.x,self.y-5,anglez,prjimpact)
		self.bindangle = math.floor((0.4+anglez-math.pi/2)/(math.pi/4))*(math.pi/4)+math.pi*2
	end
	if(zombiecases[macase-1]) and self.firetime<=0 then
		local anglez=math.atan2(zombiecases[macase-1][1].y-self.y,zombiecases[macase-1][1].x-self.x)
		table.insert(prj,projectile.new(self.x,self.y,anglez+math.random(-100,100)/1000))
		self.firetime = 0.20+math.random()/30
		shots = shots+1
		sounder.play("music/Laser_Shoot"..math.random(1,6)..".wav",1,0.3)
		splatter.addMuzzle(self.x,self.y-5,anglez,prjimpact)
		self.bindangle = math.floor((0.4+anglez-math.pi/2)/(math.pi/4))*(math.pi/4)+math.pi*2
	end

	self:accelerate(dt)
	if math.sin(self.off+past)>0 then
		self:steer("left",dt/10)
	else
		self:steer("right",dt/10)
	end
end

function military_mt.draw(self)
	local qu = math.floor(((-self.angle+math.pi/8)/math.pi)*8+3.5)%16+1
	local r,g,b,a = love.graphics.getColor()
	if self.purge then
		love.graphics.setColor(255,0,0)
	else
		--love.graphics.draw(milim,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,5,1)
	end
	local bindangle = self.bindangle
	if (bindangle+math.pi/2)%(math.pi*2)>math.pi/2 and (bindangle+math.pi/2)%(math.pi*2)<3*math.pi/2 then
		if (bindangle)%(math.pi*2)>math.pi/2 and (bindangle)%(math.pi*2)<3*math.pi/2 then
		love.graphics.draw(milback,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,-1,1,3,9)
		else
			love.graphics.draw(milim,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,-1,1,3,9)
		end
	else
		if (bindangle)%(math.pi*2)>math.pi/2 and (bindangle)%(math.pi*2)<3*math.pi/2 then
		love.graphics.draw(milback,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,3,9)
		else
			love.graphics.draw(milim,useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,3,9)
		end
	end
	local dx,dy = useful.polarToCartesian(self.bindangle+math.pi/2,10)
	--love.graphics.line(self.x,self.y,useful.roundTo(self.x+dx,default.scale),useful.roundTo(self.y+dy,default.scale))
	love.graphics.setColor(r,g,b,a)
end

function military_mt.steer(self,direction,dt)
	if direction=="left" then
		self.angle=self.angle - dt*self.rot
	elseif direction=="right" then
		self.angle=self.angle + dt*self.rot
	end
end
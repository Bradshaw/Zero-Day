--[[
wreck : Une voiture qui peut être pilotée

]]

wreck={}
local wreck_mt = setmetatable({},{__index=entity_mt})

function wreck.new(x,y,angle,speed,cmode)
	local self = setmetatable(entity.new(x,y,cmode),{__index=wreck_mt})
	engine:stop()
	self.angle = angle
	self.speed = speed
	slowdown = 0
	self.rot = 2
	self.blow = math.random(1,5)
	self.blowdown = math.random()/3
	self.hitpoints = 0
	self.wreck = true
	self.flyby = true
	self.splat = 0
	if math.random()>0.5 then
		self.veer = "left"
	else
		self.veer = "right"
	end
	--print(self.angle,self.speed)
	return self
end

function wreck_mt.boom(self)
	sounder.play("music/boom.ogg",0.3,0.6)
	sounder.play("music/boom2.ogg",1+math.random()/10,1)
	for i=1,30 do
		splatter.add(splatter.newExplodeFire(self.x+math.random()*5,self.y+math.random()*5,-math.pi/2,math.random()*500),prjimpact)
		splatter.add(splatter.newDarkSmoke(self.x,self.y,math.random()*math.pi*2),prjimpact)
	end
	for i=1,30 do
		table.insert(prj,projectile.new(self.x,self.y,(i/30)*math.pi*2,true))
	end
	for i=1,10 do
		splatter.add(splatter.newExplodeFire(self.x+math.random()*5,self.y+math.random()*5,math.random()*math.pi*2,math.random()*300),prjimpact)
	end
end

function wreck_mt.intention(self,dt)
	self.splat = self.splat-dt
	self.blowdown = self.blowdown-dt
	if self.blowdown<=0 and self.blow>0 then
		self:boom()
		self.blow = self.blow-1
		self.blowdown = math.random()
	end
	if self.splat<=0 then
		local x,y = useful.rotate(-3,-8,self.x,self.y,self.angle)
		x,y = useful.rotate(0,8,self.x,self.y,self.angle)
		for i=1,5 do
			splatter.add(splatter.newFire(x,y,-math.pi/2),prjimpact)
			splatter.add(splatter.newDarkSmoke(x,y,-math.pi/2),prjimpact)
			splatter.add(splatter.newDarkSmoke(x,y,-math.pi/2),prjimpact)
			splatter.add(splatter.newDarkSmoke(x,y,-math.pi/2),prjimpact)
		end
		self.splat = 0.1
	end
	self.hitpoints = 0
	self:steer(self.veer,dt)
end

function wreck_mt.draw(self)
	love.graphics.setColor(16,16,16)
	entity_mt.draw(self)
end
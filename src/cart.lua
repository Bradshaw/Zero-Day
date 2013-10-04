--[[
cart : Une voiture qui peut être pilotée

]]

cart={}
local cart_mt = setmetatable({},{__index=entity_mt})

function cart.new(x,y,cmode)
	local self = setmetatable(entity.new(x,y,cmode),{__index=cart_mt})
	self.rot = 6
	self.hitpoints = 100
	self.splat = 0
	self.skidding = false
	--self.emit = splatter.newEmitter(self.x,self.y,spray)
	return self
end

function cart_mt.intention(self,dt)
	local dt = dt
	--self.emit:update(dt)
	self.splat = self.splat-dt
	if self.splat<=0 then
		for i=1,lasthit*2 do
			splatter.add(splatter.newBlood(5+self.x-math.random()*10,15+self.y-math.random()*10,self.angle+math.pi/2),prjimpact)
		end
		local x,y = useful.rotate(-3,-8,self.x,self.y,self.angle)
		for i=1,1+self.speed/200 do
			splatter.add(splatter.newMuzzleSmoke(x,y,math.random()*math.pi*2),prjimpact)
		end
		x,y = useful.rotate(0,8,self.x,self.y,self.angle)
		for i=1,5-self.hitpoints/10 do
			splatter.add(splatter.newFire(x,y,math.random()*math.pi*2),prjimpact)
			splatter.add(splatter.newDarkSmoke(x,y,math.random()*math.pi*2),prjimpact)
		end
		self.splat = 0.02
	end
	local l,r,u,d = self:checkArrows()
	local xv = r-l
	local yv = d-u
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
	local curd = (math.floor((-self.angle/(math.pi*2))*8-1)%8)
	if dir then
		local m = (curd-dir)%8
		if m>=2.5 and m<=5.5 then
			self:brake(dt)
		else
			self:accelerate(dt)
		end
		if m>0 and m<=4 then
			self:steer("right",dt)
		else
			self:steer("left",dt)
		end
	end
end

function cart_mt.draw(self)
	entity_mt.draw(self)
	splatter.draw(pointparts)
end
--[[
aicart : Une voiture qui peut être pilotée

]]

aicart={}
local aicart_mt = setmetatable({},{__index=entity_mt})

function aicart.new(x,y,cmode)
	local self = setmetatable(entity.new(x,y,cmode),{__index=aicart_mt})
	self.rot = 6
	self.splat = 0
	self.hitpoints = 100
	--self.emit = splatter.newEmitter(self.x,self.y,spray)
	return self
end

function aicart_mt.intention(self,dt)
	--local px,py = useful.getTile(c[1].x,c[1].y)
	--local playernum = cur:get(px,py).number

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
	local tx1,ty1,tx2,ty2 = self.collideCam:getTileBounds()
	local cx = tx1+1
	local cy = ty1+1
	local nx,ny = cx,cy
	local go = 1
	--local head = playernum - cur:get(cx,cy).number
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
	local curd = (math.floor((-self.angle/(math.pi*2))*8-1)%8)
	local err = (((-self.angle/(math.pi*2))*8-1)%8) -curd
	--print(err)
	-- Si le zombie peut choisir une direction alors s'y diriger
		-- dir vaut false si le joueur est sur la même case que le zombie
		-- sinon dir est un nombre qui indique vers quelle case se diriger.
		-- curd est la direction actuelle du zombie
	if not dir then
		self:accelerate(dt)
	end
	if dir then
		local m = (curd-dir)%8
		if m>=2.5 and m<=5.5 then
			self:brake(dt)
		else
			self:accelerate(dt)
		end
		if true or err>0.2 or err<0.8 then
			--print(err)
			if m>0 and m<=4 then
				self:steer("right",dt)
			else
				self:steer("left",dt)
			end
		end
	end
end

function aicart_mt.draw(self)
	entity_mt.draw(self)
	--self.emit:draw()
end
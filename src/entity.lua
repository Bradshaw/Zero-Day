--[[
Classe en construction
Représente une entité joueur, NPC ou objet placé.
]]

entity_mt={}
entity={}
entityim = {}
for i=1,16 do
	entityim[i]=love.graphics.newImage("images/proto/"..string.format("%04d",i)..".png")
end

--[[
Pour des entity controlés par les joueurs, vérifie quelles touches sont enfoncées parmi la collection de touches "self.keys.(up|down|left|right)".

Renvoie l,r,u,d des entiers valant 0 ou 1 en fonction des touches enfoncées
0 si la touche n'est pas enfoncée
1 si la touche est enfoncée
l -- left, gauche
r -- right, droite
u -- up, haut
d -- down, bas
]]
function entity_mt.checkArrows(self)
	if not self.flyby then
		local l,r,u,d = 0,0,0,0
		for _,v in ipairs(self.keys.up) do
			if love.keyboard.isDown(v) then
				u=1
			end
		end
		for _,v in ipairs(self.keys.down) do
			if love.keyboard.isDown(v) then
				d=1
			end
		end
		for _,v in ipairs(self.keys.left) do
			if love.keyboard.isDown(v) then
				l=1
			end
		end
		for _,v in ipairs(self.keys.right) do
			if love.keyboard.isDown(v) then
				r=1
			end
		end
		return l,r,u,d
	else
		return 0,0,0,0
	end
end

function entity_mt.intention(self, dt)
		local px,py = math.floor(c[1].x/default.tilesize.x),math.floor(c[1].y/default.tilesize.y)
		local playernum = cur:get(px,py).number
		local tx1,ty1,tx2,ty2 = self.collideCam:getTileBounds()
		local cx = tx1+1
		local cy = ty1+1
		local nx,ny = cx,cy
		local head = playernum - cur:get(cx,cy).number-1
		self:accelerate(dt*(math.min(12,math.max(0,head)))/12)
		local targetx, targety = cx,cy
		for i=tx1,tx2 do
			for j=ty1,ty2 do
				if cur:get(i,j).number==cur:get(nx,ny).number+1 then
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

function entity_mt.update(self,dt)
	if not self.purge then
		local dt = dt
		local l,r,u,d = self:checkArrows()
		self:intention(dt)
		self.speed = self.speed-self.speed*dt*2
		self.nudgex = self.nudgex-self.nudgex*dt*2
		self.nudgey = self.nudgey-self.nudgey*dt*2
		for k,v in pairs(c) do
			if self~=v and self.collideCam:check(v.x,v.y) then
				local dx = self.x-v.x
				local dy = self.y-v.y
				local dist = math.sqrt(dx*dx+dy*dy)
				if dist<10 then
					if dx~=0 and dy~=0 then
						self.nudgex = ((dx/math.abs(dx)) * 50-dist)
						self.nudgey = ((dy/math.abs(dy)) * 50-dist)
					end
				end
			end
		end
		local px = self.x + (self.speed * math.sin(-self.angle) * dt +self.nudgex * dt)/default.scale
		local py = self.y + (self.speed * math.cos(-self.angle) * dt * default.tilt + self.nudgey * dt * default.tilt)/default.scale
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
	end
end


--[[
Fait tourner l'entité, dans le sens horaire quand direction vaut "right" et dans le sens anti-horaire quand direction vaut "left"

Ici une implémentation orienté "voiture"
]]
function entity_mt.steer(self,direction,dt)
	self.lastdir = self.lastdir or "none"
	self.lastdirt = self.lastdirt or 0
	if direction=="left" then
		self.angle=self.angle - dt*self.rot*math.min(1,math.abs(self.speed/500))
	elseif direction=="right" then
		self.angle=self.angle + dt*self.rot*math.min(1,math.abs(self.speed/500))
	end
	if direction==self.lastdir and (direction=="left" or direction=="left") then
		self.lastdirt = self.lastdirt+dt

		self.speed = self.speed-self.speed*(dt)*math.max(self.lastdirt,1)
	else
		self.lastdir = direction
		self.lastdirt = 0
	end
end


function entity.new(x,y,cmode)
	local self = setmetatable({},{__index=entity_mt})
	self.x = x or 0
	self.y = y or 0
	self.rot = 7
	self.power = 1800
	self.braking = 500
	self.angle = math.pi
	self.speed = 0
	self.nudgex = 0
	self.nudgey = 0
	self.name = "Lolilol"
	self.keys = {}
	self.keys.up = {"up","z","w"}
	self.keys.down = {"down","s"}
	self.keys.left = {"left","q","a"}
	self.keys.right = {"right","d"}
	self.controlMode = cmode or "point"
	self.collideCam = camera.new(self.x,self.y,default.tilesize.x*2,default.tilesize.y*2)
	return self
end

--[[
Fait accelerer l'entité
]]
function entity_mt.accelerate(self,dt)
	self.speed = self.speed+dt*self.power
end

--[[
Fait ralentir l'entité
]]
function entity_mt.brake(self, dt)
	self.speed = self.speed-dt*self.braking
end

function entity_mt.draw(self)
	local qu = math.floor(((-self.angle+math.pi/8)/math.pi)*8+3.5)%16+1
	love.graphics.draw(entityim[qu],useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale),0,1,1,14,11)
	love.graphics.setColor(255,0,0)
	--love.graphics.point(useful.roundTo(self.x,default.scale),useful.roundTo(self.y,default.scale))
end

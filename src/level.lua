level = {}
local level_mt = {}

--[[
	5|1|6
	2| |3
	7|4|8

]]
-- Constructeurs de level

-- Constructeur "vide" permettant de créer simplement un niveau vide
function level.new()
	local self = setmetatable({},{__index=level_mt})

	-- Camera sert à faire des optimisations de dessin, on ne dessinera que la portion de level qui est visible par la camera
	self.camera=camera.new(
		(love.graphics.getWidth()/2)/default.scale,
		(love.graphics.getHeight()/2)/default.scale,
		love.graphics.getWidth()/default.scale,
		love.graphics.getHeight()/default.scale+1*default.tilesize.y
		
	)

	-- tilesize c'est la taille des cases de terrain, ça utilise les valeur par défaut au dessus.
	self.tilesize = {}
	self.tilesize.x = default.tilesize.x
	self.tilesize.y = default.tilesize.y

	-- Taille maximum de la map les cases de la map seront toujours entre 1 et maxsize
	self.maxsize = {}
	self.maxsize.x = default.maxsize.x
	self.maxsize.y = default.maxsize.y

	-- Booléen, si vrai, boucler sur les bords de la map, si faux, tout ce qui en dehors de la map sera du "vide"
	self.loop = default.loop


	-- Contenu d'une case non-initialisée
	self.empty = tile.new()

	-- data contient le contenu de la map
	self.data = {}
	--tiles est un tableau indexé de tableaux indexés une case aura une valeur par défaut si elle n'est pas initialisée (voir fonctions level_mt.get() et level_mt.set())
	self.data.tiles = {}

	return self
end

-- Constructeur qui charge un niveau stocké sur le disque
function level.fromFile(filename)
	return level.new():fromFile(filename)
end




-- Méthodes
function level_mt.fromFile(self, filename)
	print("Chargement du niveau "..filename)
	return self
end

function level_mt.update(self, dt)

end

function level_mt.draw(self, pass2)
	texbatch:clear()
	local r,g,b,a =love.graphics.getColor()
	local tx1,ty1,tx2,ty2 = self.camera:getTileBounds()
	if not pass2 then
		for i=tx1,tx2 do
			for j=ty1,ty2 do
				if not self:get(i,j).collide then
					env = self:env(i,j)
					tile.draw(self:get(i,j),i,j,env)
				end
				
				--love.graphics.print(self:get(i,j),i*default.tilesize.x,j*default.tilesize.y)
				--love.graphics.setColor(63,0,15)
				--love.graphics.rectangle("fill",i*default.tilesize.x,j*default.tilesize.y,default.tilesize.x-5,default.tilesize.y-5)
				--love.graphics.setColor(255,255,255)
				--love.graphics.print(i.." "..j,i*default.tilesize.x,j*default.tilesize.y)
			end
		end
		for i=tx1,tx2 do
			for j=ty1,ty2 do
				if self:get(i,j).collide then
					env = self:env(i,j)
					tile.draw(self:get(i,j),i,j,env)
				end
				
				--love.graphics.print(self:get(i,j),i*default.tilesize.x,j*default.tilesize.y)
				--love.graphics.setColor(63,0,15)
				--love.graphics.rectangle("fill",i*default.tilesize.x,j*default.tilesize.y,default.tilesize.x-5,default.tilesize.y-5)
				--love.graphics.setColor(255,255,255)
				--love.graphics.print(i.." "..j,i*default.tilesize.x,j*default.tilesize.y)
			end
		end
	else
		for i=tx1,tx2 do
			for j=ty1,ty2 do
				if self:get(i,j).collide then
					env = self:env(i,j)
					tile.draw(self:get(i,j),i,j,env,pass2)
				end
				
				--love.graphics.print(self:get(i,j),i*default.tilesize.x,j*default.tilesize.y)
				--love.graphics.setColor(63,0,15)
				--love.graphics.rectangle("fill",i*default.tilesize.x,j*default.tilesize.y,default.tilesize.x-5,default.tilesize.y-5)
				--love.graphics.setColor(255,255,255)
				--love.graphics.print(i.." "..j,i*default.tilesize.x,j*default.tilesize.y)
			end
		end
	end
	love.graphics.draw(texbatch)
	love.graphics.setColor(r,g,b,a)

end

function level_mt.env(self,x,y)
	env=0
	if self:get(x-1,y-1).typ==self:get(x,y).typ then
		env=env+16
	end
	if self:get(x-1,y).typ==self:get(x,y).typ then
		env=env+2
	end
	if self:get(x-1,y+1).typ==self:get(x,y).typ then
		env=env+64
	end
	if self:get(x,y-1).typ==self:get(x,y).typ then
		env=env+1
	end
	if self:get(x,y+1).typ==self:get(x,y).typ then
		env=env+8
	end
	if self:get(x+1,y-1).typ==self:get(x,y).typ then
		env=env+32
	end
	if self:get(x+1,y).typ==self:get(x,y).typ then
		env=env+4
	end
	if self:get(x+1,y+1).typ==self:get(x,y).typ then
		env=env+128
	end
	return env
end

function level_mt.get(self, x, y)
	if x < 1 or x > self.maxsize.x then -- La case est hors de la map
		if self.loop then 				-- Mais on boucle
			x = (x%self.maxsize.x) 	-- Alors on va pointer une case dans le niveau
		else
			return self.empty			-- Sinon renvoyer la case vide
		end
	end
	if y < 1 or y > self.maxsize.y then	-- Meme chose que pour x au-dessus
		if self.loop then
			y = (y%self.maxsize.y)
		else
			return self.empty
		end
	end
	if not self.data.tiles[x] then -- Vérifie que la case est initialisée
		return self.empty			-- Sinon renvoyer la case vide
	end
	if self.data.tiles[x] and self.data.tiles[x][y] then
		return self.data.tiles[x][y]	-- On renvoie les données de la map
	else
		return self.empty
	end
	
end

function level_mt.set(self, x, y, t, n)
	if x < 1 or x > self.maxsize.x then -- La case est hors de la map
		if self.loop then				-- Mais on boucle
			x = (x%self.maxsize.x) 	-- Alors on va pointer une case dans le niveau
		else
			return 1, "Case invalide"	-- Sinon renvoyer erreur, on tente de modifier une case qui n'existe pas
		end
	end
	if y < 1 or y > self.maxsize.y then	-- Meme chose que pour x au-dessus
		if self.loop then
			y = (y%self.maxsize.y)
		else
			return 1, "Case invalide"
		end
	end
	if not self.data.tiles[x] then -- Vérifie que la case est initialisée
		self.data.tiles[x] = {}		-- Sinon initialiser la case
	end
	if self.data.tiles[x] then
		self.data.tiles[x][y] = tile.new(t, n) 	-- Et on écrit notre objet tile à sa place
	else
		self.data.tiles[x]={}
		self.data.tiles[x][y] = tile.new(t, n)	-- Et on écrit notre objet tile à sa place
	end

	return 0
end

function level_mt.build(self, n)
	local numba = 5
	placed = 0
	--lastx,lasty = 0,0
	--lastpx,lastpy = 0,0
	local function go(x,y)
		self:set(x,y,"road",numba)
		lastpx=x
		lastpy=y
		numba = numba+1
		local min, max = 0,1+diff
		for _ = 1,math.random(min,max) do
			table.insert(zombies, zombie.new((x+math.random())*default.tilesize.x,(y+math.random())*default.tilesize.y))
		end
		for _ = 1,math.random(0,1) do
			table.insert(grunts, military.new((x+math.random())*default.tilesize.x,(y+math.random())*default.tilesize.y))
		end
		local d={}
		d[1] = {x=0,y=-1,d=self:get(x,y-2).typ}
		d[2] = {x=0,y=1,d=self:get(x,y+2).typ}
		d[3] = {x=-1,y=0,d=self:get(x-2,y).typ}
		d[4] = {x=1,y=0,d=self:get(x+2,y).typ}
		local vals = 0
		for i,v in ipairs(d) do
			if v.d=="wall" then
				vals = vals+1
			end
		end
		if placed<n and vals>=1 then
			local done = false
			while not done do
				local i = math.random(1,4)
				if d[i].d=="wall" then
					self:set(x+d[i].x,y+d[i].y,"road",numba)
					lastpx=x+d[i].x
					lastpy=y+d[i].y
					lastx, lasty = x+d[i].x,y+d[i].y
					numba=numba+1
					for _ = 1,math.random(min,max) do
						table.insert(zombies, zombie.new((x+d[i].x+math.random())*default.tilesize.x,(y+d[i].y+math.random())*default.tilesize.y))
					end
					for _ = 1,math.random(0,1) do
						table.insert(grunts, military.new((x+math.random())*default.tilesize.x,(y+math.random())*default.tilesize.y))
					end
					if math.random()>0.8 then
						--players = players+1
						--table.insert(c,cart.new((x+0.5)*default.tilesize.x,(y+0.5)*default.tilesize.y,"huntai"))
					end
					placed = placed+1
					go(x+d[i].x*2,y+d[i].y*2)
					done = true
				end
			end
		end
	end
	self:set(50,50,"road",1)
	table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(50+math.random())*default.tilesize.y))
	self:set(50,49,"road",2)
	table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(49+math.random())*default.tilesize.y))
	self:set(50,48,"road",3)
	table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(48+math.random())*default.tilesize.y))
	self:set(50,47,"road",4)
	table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(47+math.random())*default.tilesize.y))
	go(50,46)
	t = 0
	local function good()
		if placed<n then return false
		else return not self:get(lastpx,lastpy+1).collide
		end 
	end
	--print(self:get(lastpx,lastpy+1).collide)
	while not good() do
		--print("Nawt good, "..placed.." and "..self:get(lastpx,lastpy+1).typ)
		t=t+1
		numba = 5
		self.data = {}
		self.data.tiles = {}
		zombies = {}
		grunts = {}
		placed = 0
		self:set(50,50,"road",1)
		table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(50+math.random())*default.tilesize.y))
		self:set(50,49,"road",2)
		table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(49+math.random())*default.tilesize.y))
		self:set(50,48,"road",3)
		table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(48+math.random())*default.tilesize.y))
		self:set(50,47,"road",4)
		table.insert(grunts, military.new((50+math.random())*default.tilesize.x,(47+math.random())*default.tilesize.y))
		go(50,46)
	end
	--print("Good, "..placed.." and "..self:get(lastx,lasty).typ)
	print(self:get(lastx,lasty+1).typ)
	numzombies = #zombies
	self.last = numba-1
	--print(placed,t)

	--[[
	for i=0,self.maxsize.x do
		for j=0,self.maxsize.y do
			if math.random()>0.2 then
				self:set(i,j,"road")
			end
		end
	end
	]]
end
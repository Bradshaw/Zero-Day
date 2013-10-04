--[[
Collection de fonctions utiles
La plupart de ces fonctions ne font que convertir des valeurs, mais dans quelques cas peuvent modifier l'état du programme.

Dans le cas où une fonction a un effet de bord, cet effet de bord sera décrit avec les précautions à prendre pour éviter les problèmes.

]]
useful = {}


function cycleres()
	if love.filesystem.exists("config.lua") then
    	local opt = filer.fromFile("config.lua")
    	opt.res = opt.res+1
    	if opt.res>#restab then
    		opt.res = 1
    	end
    	love.graphics.setMode(restab[opt.res].width,restab[opt.res].height,false,false,0)
    	filer.toFile("config.lua",opt)
    	midx = (love.graphics.getWidth()/default.scale)/2
		midy = (love.graphics.getHeight()/default.scale)/2
		if cur then
			cur.camera=camera.new(
				(love.graphics.getWidth()/2)/default.scale,
				(love.graphics.getHeight()/2)/default.scale,
				love.graphics.getWidth()/default.scale,
				love.graphics.getHeight()/default.scale+1*default.tilesize.y
				
			)
		end
    else
    	local opt = {res=2}
    	love.graphics.setMode(restab[opt.res].width,restab[opt.res].height,false,false,0)
    	filer.toFile("config.lua",opt)
    end
end

--[[
Redéfinition de fonctions trigonometriques en simple regard dans table. WOO CA VA PLUS VITE!
]]
local sintab = {}
local costab = {}
local trigP = 8*(10)  -- Toujours un multiple de 8 pour que les 8 directions de la voiture soient correctes

for i=0,trigP do
	sintab[i]=math.sin(i*(math.pi/(trigP/2)))
	costab[i]=math.cos(i*(math.pi/(trigP/2)))
end

--[[]]
math.fin = math.sin
math.cof = math.cos

function math.sin(r)
	if not frig then
		return math.fin(r)
	else
		return sintab[ math.floor((r/(math.pi/(trigP/2)))+0.5)%trigP ]
	end
end

function math.cos(r)
	if not frig then
		return math.cof(r)
	else
		return costab[ math.floor((r/(math.pi/(trigP/2)))+0.5)%trigP ]
	end
end

local tested = {}
local ats = 0

for i=-trigP*10,trigP*10 do
	for j=-trigP,trigP do
		--print("Doing",i,j)
		if j~=0 then
			if tested[math.floor((i/math.abs(j))*100)] then
				--print("Got",i,j)
			else
				--print("Adding",i,j,math.floor((i/j)*100))
				ats = ats+1
				tested[math.floor((i/math.abs(j))*100)] = math.atan2(j,i)
			end
		else
			--print("Divide by 0")
		end
	end
end

math.afan2 = math.atan2

function math.atan3(y,x)
	if not tested[math.floor((x/y)*100)] then
		tested[math.floor((x/y)*100)] = math.afan2(y,x)
		print("Didn't have",x,y)
	end
	if y>0 then
		return tested[math.floor((x/y)*100)]
	else
		return -tested[math.floor((x/y)*100)]
	end
end

for i=1,1000 do
	local x,y = (math.random()-0.5)*100,(math.random()-0.5)*100
	math.atan2(y,x)
	if (math.atan2(y,x)-math.afan2(y,x))>1 then
		print("---")
		print(math.atan2(y,x), math.afan2(y,x))
		print(math.atan2(-y,x), math.afan2(-y,x))
	end
end
--]]


--[[
Fonction:
Simule un écran par joueur pour faire un effet écran splitté

Cas d'utilisation:
for i,v in pairs(players) do 				--> Cycle sur tous les joueurs

	love.graphics.push()					--> Place les transformations
											--    courantes sur la pile

	useful.setMultiScreen(i, #players)		--> Tranforme et coupe l'écran
											--    pour le joueur i

	v:draw()								--> Dessine v

	love.graphics.setScissor()				--> Annule la coupe de l'écran

	love.graphics.pop()						--> Retourne aux transformations
											--    qui ont été empilés

end

Effets de bord:
Cause une transformation des coordonnées de dessin love, et coupe la zone de dessin.
Avant d'appeller cette fonction, faire un "love.graphics.push()" pour sauvegarder l'état de transformation courante. Après les dessins appeller "love.graphics.setScissor()" ! SANS PARAMETRES ! pour annuler la coupe de l'écran, et "love.graphics.pop()" pour annuler les transformations.

Paramètres:
pid 			-- ID du joueur, entier de 1 à nombre de joueurs
totalplayers 	-- Nombre de joueurs
]]
function useful.setMultiScreen(pid, totalplayers)
	if totalplayers == 1 then

	elseif totalplayers == 2 then
		love.graphics.setScissor((pid-1)*love.graphics.getWidth()/2,0,love.graphics.getWidth()/2,love.graphics.getHeight())
		love.graphics.translate((pid-1)*love.graphics.getWidth()/2,0)

	end
end


--[[
Fonction: Teste si une variable éxiste dans une liste d'éléments.

Utilisation:
bool = useful.isIn(5, 1, 2, 4, {6, 7, 8}, {"hello", function() end})
Teste si 5 est dans la liste contenant les éléments [1, 2, 4, 6, 7, 8, "hello", function() end] et renvoie false parce que 5 n'y est pas.

A noter, cette fonction peut prendre n'importe quel nombre de paramètres >= 1
Si un seul paramètre est donné, la fonction renvoie faux (un élément n'est pas dans la liste vide...)
Si un paramètre est une table, la table est explorée pour trouver un élément égal à l'élément recherché.

Paramètres:
a 		-- L'élémént recherché
b 		-- Le premier élément à tester
... 	-- Les autres éléments à tester

Retourne:
Un booléen, vrai si a est dans la liste [b, ...], faux sinon
]]
function useful.isIn(a, b, ...)
	if b and type(b)==type(a) then
		return a==b or useful.isIn(a, ...)
	elseif type(b)== table then
		for _,v in pairs(b) do
			useful.isIn(a,v)
		end
	else
		return false
	end
end

--[[
Fonction: Transforme des coordonnées en position "écran" (une unité vaut un pixel) en coordonnées "case" (une unité vaut une case)

Utilisation:
tx, ty = useful.getTile( obj.x, obj.y) -- Va chercher la case contenant l'objet obj

Paramètres:
x, y 	-- Coordonnées "écran" en number

Retourne:
tx, ty 		-- Coordonnées "case" entières
errx, erry	-- Flottant entre 0 et 1, position sur la case ([0.5,0.5] si l'objet est au centre de la case.)

Note: pour obtenir les coordonnées "flottantes" faire:
tx,ty, errx,erry = useful.getTile(x,y)
tx = tx+errx
ty = ty+erry
	-- Maintenant [tx,ty] pointe la position de [x,y] en "case", mais ne peuvent plus servir à indexer une case de niveau.
]]
function useful.getTile(x,y)
	local tx,ty = x/default.tilesize.x, y/default.tilesize.y
	local errx, erry = tx-math.floor(tx),ty-math.floor(ty)
	return math.floor(tx), math.floor(ty), errx, erry
end

--[[
Fonction: Convertit des coordonnées polaires en coordonnées cartésiennes.

(Unité de distance arbitraire signifie unité de distance choisie par l'utilisateur, cette fonction conserve la grandeur de l'unité. On peut donc utiliser cette fonction en pixels, cases, centimètres, pouces, etc...)

Paramètres:
angle 		-- Angle en radians
distance 	-- Distance en unité de distance arbitraire

Retourne:
x, y 		-- Coordonnées en unité de distance arbitraire

]]
function useful.polarToCartesian(angle, distance)
	local x = distance * math.cos(angle)
	local y = distance * math.sin(angle)
	return x,y
end


--[[
Fonction: Convertit des coordonnées cartésiennes en coordonnées polaires.

(Unité de distance arbitraire signifie unité de distance choisie par l'utilisateur, cette fonction conserve la grandeur de l'unité. On peut donc utiliser cette fonction en pixels, cases, centimètres, pouces, etc...)

Paramètres:
x, y 		-- Coordonnées en unité de distance arbitraire

Retourne:
angle 		-- Angle en radians
distance 	-- Distance en unité de distance arbitraire

]]
function useful.cartesianToPolar(x, y)
	local distance = math.sqrt(x*x+y*y)
	local angle = math.atan2(y,x)
	return angle, distance
end

--[[
Fonction: Tourne un point x,d de r radians autour d'un centre xc,yc

Paramètres:
x,y 		-- Coordonnées du point à déplacer
xc,yc 		-- Coordonnées du centre de rotation
r 			-- Angle de rotation en radians

Retourne:
x, y 		-- Nouvelles coordonnées du point après rotation



]]
function useful.rotate(x,y,xc,yc,r)
	local xd = x
	local yd = y
	local a,d = useful.cartesianToPolar(xd,yd)
	xd,yd = useful.polarToCartesian(a+r,d)
	return xc+xd, yc+yd
end


function useful.getBin(env)
	local bin = {}
	for i=8,1,-1 do
		if env>=math.pow(2,i-1) then
			bin[i]=true
			env = env - math.pow(2,i-1)
		else
			bin[i]=false
		end
	end
	return bin
end


--[[
Fonctions de quadination

]]
local qtl = love.graphics.newQuad(0,0,default.tilesize.x/2,default.tilesize.y/2,default.tilesize.x/2,default.tilesize.y/2)
local qt = love.graphics.newQuad(default.tilesize.x/2,0,default.tilesize.x/2,default.tilesize.y/2,default.tilesize.x/2,default.tilesize.y/2)
local ql = love.graphics.newQuad(0,default.tilesize.y/2,default.tilesize.x/2,default.tilesize.y/2,default.tilesize.x/2,default.tilesize.y/2)
local qntl = love.graphics.newQuad(default.tilesize.x/2,default.tilesize.y/2,default.tilesize.x/2,default.tilesize.y/2,default.tilesize.x/2,default.tilesize.y/2)

function useful.getq(env)
	local bin = useful.getBin(env)
	local shift = 0
	if bin[2] then
		if bin[1] then
			shift=2
		elseif bin[4] then
			shift=5
		end
	elseif bin[1] then
		if bin[4] then
			shift = 1
		else
			shift = 3
		end
	else
		shift = 4
	end

	return love.graphics.newQuad((shift)*default.tilesize.x,0,default.tilesize.x,default.tilesize.y,default.tilesize.x*6,default.tilesize.y)
end


function useful.roundTo(x,n)
	return math.floor(x)
end

function useful.purge()
	--[[]]
	for i=#prj,1,-1 do
		if prj[i].purge then
			table.remove(prj, i)
		end
	end
	for i=#zombies,1,-1 do
		if zombies[i].purge then
			table.remove(zombies, i)
		end
	end
	for i=#bombs,1,-1 do
		if bombs[i].purge then
			table.remove(bombs, i)
		end
	end
	for i=#grunts,1,-1 do
		if grunts[i].purge then
			--table.remove(grunts, i)
		end
	end
	--]]
end


function useful.getInputs(key, uni)
	if (uni>=48 and uni<=57) or (uni>=65 and uni<=90) or (uni>=97 and uni<=122) then
		return string.char(uni)
	end
end

function useful.buildString(key, uni, s)
	if useful.getInputs(key, uni) then
		s = s..useful.getInputs(key, uni)
	end
	if key == "backspace" then
		s = s:sub(1,s:len()-1)
	end



	return s
end
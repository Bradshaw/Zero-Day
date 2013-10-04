--[[
camera : Une caméra virtuelle qui permet de limiter les éléments "visibles" pour optimiser tests et dessin des objets et tuiles près du joueur.

]]

camera = {}
local camera_mt = {}


--[[
Utilisation: maCamera = camera.new(15,60,400,300)
Crée une nouvelle camera, qui vise le pixel aux coordonnées (15,60) et a une taille de 400 par 300

Paramètres:
x : Position en X, par défault, le milieu de l'écran
y : Position en Y, par défault, le milieu de l'écran
w : Largeur de la zone visée, par défaut la largeur de l'écran
h : Hauteur de la zone visée, par défaut égal à la largeur
]]
function camera.new(x,y,w,h)
	self = setmetatable({},{__index=camera_mt})
	self.x= x or (love.graphics.getWidth()/2)/default.scale
	self.y= y or (love.graphics.getHeight()/2)/default.scale
	self.w= w or love.graphics.getWidth()/default.scale
	self.h= h or self.w
	return self
end

--[[
Utilisation: maCamera:pointAt(40, 23)
maCamera vise maintenant le pixel aux coordonnées (40,23)

Paramètres:
x : Nouvelle position en X
y : Nouvelle position en Y
]]
function camera_mt.pointAt(self,x,y)
	self.x = math.floor(x)
	self.y = math.floor(y)
end


--[[
Utilisation: maCamera:setSize(800,600)
maCamera a désormais une taille de 800 par 600

Paramètres:
width: Nouvelle largeur
height: Nouvelle hauteur, par défaut égal à la largeur
]]
function camera_mt.setSize(width,height)
	self.w = width
	self.h = height or self.w
end

--[[
Utilisation:
local x1,y1,x2,y2 = maCamera:getBounds() 

Obtenient la zone visible

Retour:
x1 : Bord de gauche
y1 : Bord du haut
x2 : Bord de droite
y2 : Bord du bas

]]
function camera_mt.getBounds(self)
	return self.x-self.w/2, self.y-self.h/2, self.x+self.w/2, self.y+self.h/2
end


--[[
Utilisation:
if maCamera:check( obj:getX(), obj:getY() ) then
	obj:draw()
end

Appelle obj:draw() si obj est visible par maCamera

Retour:
booléen : les coordonnées (x,y) sont visibles par maCamera
]]
function camera_mt.check(self,x,y)
	local x1,y1,x2,y2 = self:getBounds()
	--print(x1,y1,x2,y2,x,y)
	if x>=x1 and x<=x2 and y>=y1 and y<=y2 then
		return true
	else
		return false
	end
end


--[[
Utilisation:
local tx1,ty1,tx2,ty2 = maCamera:getTileBounds()
for i=tx1,tx2 do
	for j=ty1,ty2 do
		print("Case "..i.." "..j)
	end
end

Imprime des chaînes comme "Case 45 21" pour chaque case (tuile) visible par maCamera
]]
function camera_mt.getTileBounds(self)
	local x1,y1,x2,y2 = self:getBounds()
	local tx1 = math.floor(x1/default.tilesize.x)
	local ty1 = math.floor(y1/default.tilesize.y)
	local tx2 = math.floor(x2/default.tilesize.x)
	local ty2 = math.floor(y2/default.tilesize.y)
	return tx1,ty1,tx2,ty2

end


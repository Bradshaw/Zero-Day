local animated_mt = {}
local loaded = {}
animated = {}

function animated.new(image, frames, variations)
	if not loaded[image..frames..variations] then
		local self = setmetatable({},{__index=animated_mt})
		if type(image)=="string" then
			if loaded[image] then
				self.image = loaded[image]
			else
				loaded[image] = love.graphics.newImage(image)
				self.image = loaded[image]
			end
		else
			self.image = image
		end
		self.frames = frames or 16
		self.variations = variations or 1
		self.xsize = self.image:getWidth()/self.frames
		self.ysize = self.image:getHeight()/self.variations
		self.ox = (self.image:getWidth()/self.frames)/2
		self.oy = (self.image:getHeight()/self.variations)/2
		self.quads = {}
		for i=0,self.frames+1 do
			self.quads[i]={}
			for j=0,self.variations+1 do
				self.quads[i][j]=love.graphics.newQuad((i%self.frames)*self.xsize,(j%self.variations)*self.ysize,self.xsize,self.ysize,self.image:getWidth(),self.image:getHeight())
			end
		end
		loaded[image..frames..variations] = self
		return self
	else
		return loaded[image..frames..variations]
	end
end

function animated_mt.draw(self, x, y, r, frame, var)
	--print(frame,var,#self.quads)
	love.graphics.draw(
		self.image,
		self.quads[(frame or 1)%self.frames][(var or 1)%self.variations],
		x,y,r,1,1,
		self.ox,
		self.oy
		)
end
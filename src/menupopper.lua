local menupopper_mt = {}
menupopper = {}
local sel = love.graphics.newImage("images/selected.png")

function menupopper.new(entries)
	local self = setmetatable({},{__index=menupopper_mt})
	self.entries=entries
	self.selected = 1
	return self
end

function menupopper_mt.up(self)
	self.selected=((self.selected-2)%#self.entries)+1
end

function menupopper_mt.down(self)
	self.selected=((self.selected)%#self.entries)+1
end

function menupopper_mt.select(self)
	self.entries[self.selected].func()
end

function menupopper_mt.doKey(self, key)
	if useful.isIn(key, "up", "w") then
		self:up()
	elseif useful.isIn(key, "down") then
		self:down()
	elseif useful.isIn(key, "return", "space", "d", "q", "a", "s", "z") then
		self:select()
	end
end

function menupopper_mt.draw(self,x,y)
	local m = 0
	for i,v in ipairs(self.entries) do
		m = math.max(m, font:getWidth(v.text))
	end
	for i,v in ipairs(self.entries) do
		love.graphics.print(v.text,x-m/2,y+(i-1)*10)
	end
	love.graphics.draw(sel,x-m/2-5,1+y+(self.selected-1)*10)
end
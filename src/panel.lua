local stuff_mt = {}
local panel_mt = {}
panel = {}

function panel.newPanel(x,y,w,h)
	local self = setmetatable({},{__index=panel_mt})
	self.x = x
	self.y = y
	self.w = w
	self.h = h
	self.stuff = {}
	return self
end

function panel.newElement()

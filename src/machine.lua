local state_mt = {}
local machine = {}


function machine.newState(name,default,enter,exit)
	local self = setmetatable({},{__index=state_mt})
	self.name = name or "null"
	self.enter = enter or function() end
	self.exit = exit or function() end
	--self.enter("f","f")
	self.default = default or self
	self.transitions = {}
	self.tfuncs = {}
	return self
end

function state_mt.inject(self,symbol)
	if self.transitions[symbol] then
		self.exit(self,symbol)
		if self.tfuncs[symbol] then
			self.tfuncs[symbol](self)
		end
		self.transitions[symbol].enter(self,symbol)
		return self.transitions[symbol]
	else
		self.exit(self,symbol)
		if self.tfuncs[symbol] then
			self.tfuncs[symbol](self)
		end
		self.default.enter(self,symbol)
		return self.default
	end
end

function state_mt.pushString(self,str)
	local l = str:len()
	for i=1,l do
		self = self:inject(str:sub(i,i))
	end
	return self
end

function state_mt.newTransition(self,state,symbol,...)
	if symbol then
		if type(symbol)=="table" then
			for _,v in pairs(symbol) do
				self:newTransition(state,v)
			end
			self:newTransition(state,...)
		else
			self.transitions[symbol] = state
			self:newTransition(state,...)
		end
	end
end

function state_mt.addTFunction(self, func, symbol, ...)
	if symbol then
		if type(symbol)=="table" then
			for s,_ in pairs(symbol) do
				self:addTFunction(func,s)
			end
			self:addTFunction(func,...)
		else
			self.tfuncs[symbol] = func
			self:addTFunction(func,...)
		end
	end
end

return machine


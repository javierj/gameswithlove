Counter = {}


-- Create attributes and set initial values
function Counter:new(init, limit, inc)
	entity = {}

	entity.init = init or 1
	entity.counter = init
	entity.limit = limit or 2
	entity.inc = inc or 1

	setmetatable(entity, self)
	self.__index = self
	return entity
end


function Counter:add(inc)
	inc = inc or 1
	self.counter = self.counter + inc
	local b = false
	if self.counter == self.limit then
		self.counter = self.init
		b = true
	end
	return b
end

function Counter:restart()
		self.counter = self.init
end

function Counter:val()
	return self.counter
end

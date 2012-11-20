

BlockGroup = {}


-- Create attributes and set initial values
function BlockGroup:new()
	entity = {}

	entity.cell = {}
	entity.minimumcell = {}
	entity.border = {80, 120, 200}
	entity.fill = {60, 100, 140}
	entity.style = 0

	setmetatable(entity, self)
	self.__index = self
	return entity
end


-- Deprecated. Remove
function BlockGroup:addCell(px, py)
	table.insert(self.cell, {x = px, y = py})
end

function BlockGroup:addMatrix(m, style)
	self.cell = m
	local minY = (-1) * enviroment.MaxY
	for _, c in pairs(m) do
		minY = c.y > minY and c.y or minY
	end
	for _, c in pairs(m) do
		if c.y == minY then
		 table.insert(self.minimumcell, c)
		end
	end
	
	style = style and style or 1
	self.style = style
end


-- Load external resources
function BlockGroup.load()
end


--[[ Checks are done in BlockBucket ]]
function BlockGroup:update(dt)
	for _, cell in pairs(self.cell) do
		cell.y = cell.y + 1
		-- cell.y = cell.y < blockbucket.N and cell.y +1
	end
end


function BlockGroup:draw()
end


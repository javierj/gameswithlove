
blockbucket = {}

blockbucket.ScreenX = 400
blockbucket.ScreenY = 500
blockbucket.M = 20
blockbucket.N = 25

NOBLOCK = -1


function blockbucket.load()
	blockbucket.sizeX = blockbucket.ScreenX / blockbucket.M -- 20
	blockbucket.sizeY = blockbucket.ScreenY / blockbucket.N -- 20
	blockbucket.background = {20, 20, 20, 150}
	
	blockbucket.start()

end

function blockbucket.start()
	blockbucket.segsToMoveTheBlocks={counter = 0, limit = 0.4}

	blockbucket.groups = {}
	blockbucket.matrix ={}
	blockbucket.createMatrix()
end

-- Refactor: change name
function blockbucket.createMatrix()
	
	for j = 1, blockbucket.N do
		blockbucket.matrix[j] = {}
		for i = 1, blockbucket.M do
			blockbucket.matrix[j][i] = NOBLOCK
		end
	end 
	blockbucket.groups = {}
end



function blockbucket.getMinX()
	return blockbucket.sizeX
end

function blockbucket.getMaxX()
	return blockbucket.ScreenX + blockbucket.sizeX
end

function blockbucket.getMaxY()
	return blockbucket.ScreenY + blockbucket.sizeY
end


function blockbucket.addMatrix3x3(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py}, {x=px+2, y = py},
				{x=px, y = py-1}, {x=px+1, y = py-1}, {x=px+2, y = py-1},
				{x=px, y = py-2}, {x=px+1, y = py-2}, {x=px+2, y = py-2}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end

function blockbucket.addMatrix4x4(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py}, {x=px+2, y = py},{x=px+3, y = py},
				{x=px, y = py-1}, {x=px+1, y = py-1}, {x=px+2, y = py-1},{x=px+3, y = py-1},
				{x=px, y = py-2}, {x=px+1, y = py-2}, {x=px+2, y = py-2},{x=px+3, y = py-2}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end



function blockbucket.addMatrix3x2(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py}, {x=px+2, y = py},
				{x=px, y = py-1}, {x=px+1, y = py-1}, {x=px+2, y = py-1}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end

function blockbucket.addMatrix1x5(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, 
				{x=px, y = py-1}, 
				{x=px, y = py-2}, 
				{x=px, y = py-3}, 
				{x=px, y = py-4}
}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end

function blockbucket.addMatrix3x1(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py}, {x=px+2, y = py}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end

function blockbucket.addTrap4x3(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py}, {x=px+2, y = py}, {x=px+3, y = py},
				{x=px, y = py-1},						 {x=px+3, y = py-1}, 
				{x=px, y = py-2}, 						{x=px+3, y = py-2}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end


function blockbucket.addHouse4x3(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py-2}, {x=px+2, y = py-2}, {x=px+3, y = py},
				{x=px, y = py-1}, {x=px+3, y = py-1}, 
				{x=px, y = py-2}, {x=px+3, y = py-2}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end


function blockbucket.addMatrix1x1(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py} }

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end

function blockbucket.addT3x3(px, py, style)
	local group = BlockGroup:new()
	local m = { {x=px, y = py}, {x=px+1, y = py}, {x=px+2, y = py},
				 {x=px+1, y = py-1},
				 {x=px+1, y = py-2}
	}

	group:addMatrix(m, style)
	table.insert(blockbucket.groups, group)
end


---------------------------------------------------------------


function blockbucket.draw()
	local style
	for j = 1, blockbucket.N do
		for i = 1, blockbucket.M do
			--if blockbucket.matrix[i][j] then
			if blockbucket.hasBlockIn(i,j) then
				style = blockbucket.matrix[i][j]
				love.graphics.setColor({255, 255, 255, 255});
				love.graphics.draw(game.imgs[style], (i*blockbucket.sizeX), (j*blockbucket.sizeY))
				--love.graphics.rectangle( "fill", (i*blockbucket.sizeX), (j*blockbucket.sizeY), blockbucket.sizeX, blockbucket.sizeY )

			else
				love.graphics.setColor(blockbucket.background);
				love.graphics.rectangle( "fill", (i*blockbucket.sizeX), (j*blockbucket.sizeY), blockbucket.sizeX, blockbucket.sizeY )
			end

		end
	end 



end

-- remove. Use enviroment
-- deprecated
function blockbucket.deprecated(block)
	local now = love.timer.getTime()
	local time = now - block.counter
	if time < block.limit then
		return false
	end
	block.counter = now
	return true

end


function blockbucket.update(dt)

	if enviroment.isTimeFor(blockbucket.segsToMoveTheBlocks) == false then
		return
	end

	for i = #blockbucket.groups, 1, -1 do
		g  = blockbucket.groups[i]

		blockbucket.removeGroupFromMatrix(g)
		-- checks if collides
		if blockbucket.touchFloor(g) then
			--blockbucket.addGroupIntoMatrix(g)
			table.remove(blockbucket.groups, i)
		else
			g:update(dt)
		end
		blockbucket.addGroupIntoMatrix(g)
	end
end

-- Checks if teh group touch any element in the matrix
function blockbucket.touchFloor(group)
	for _, c in pairs(group.minimumcell) do
		--if blockbucket.matrix[c.x][c.y+1]  or (c.y+1) > blockbucket.N then
		if blockbucket.hasBlockIn(c.x,c.y+1)  or (c.y+1) > blockbucket.N then
			return true
		end
	end
	return false
end


function blockbucket.addGroupIntoMatrix(group)
	for _, c in pairs(group.cell) do
		if c.y > 0 and c.x > 0 then
			blockbucket.matrix[c.x][c.y] = group.style
		end
	end
end

function blockbucket.removeGroupFromMatrix(group)
	for _, c in pairs(group.cell) do
		if c.y > 0 and c.x > 0 then
			blockbucket.matrix[c.x][c.y] = NOBLOCK -- -1
		end
	end
end


function blockbucket.getMatrixIndexesFromPoint(point)
	local i = math.floor(point.x / blockbucket.sizeX)
	local j = math.floor(point.y / blockbucket.sizeY)
	return i, j 
end

-- There are blocks outside the matrix
function blockbucket.hasBlockIn(i, j)
	if i > blockbucket.M or j > blockbucket. N then	
		return true
	end
	if i < 1 then
		return false
	end
	return blockbucket.matrix[i][j] ~= NOBLOCK and blockbucket.matrix[i][j] ~= nil
end

function blockbucket.isEmptyIn(i, j)
	return blockbucket.matrix[i][j] == NOBLOCK or blockbucket.matrix[i][j] == nil
end

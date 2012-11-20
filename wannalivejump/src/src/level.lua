

Level = {}


function Level.new()
	entity = {}

	entity.segsToCreateBlocks={counter = 0, limit = 1.6}
	entity.blocks = 0
	
	-- Methods
	entity.update = Level.update
	entity.draw = Level.draw
	entity.load = Level.load
	entity.getImageNames = Level.getImageNames
	entity.checkEndOfLevel = Level.checkEndOfLevel
	entity.endOfLevel = Level.endOfLevel()
	

	entity.exitPos = {x = (blockbucket.sizeX*2) , 
					  y = blockbucket.sizeY*2,
						sizeX = blockbucket.sizeX,
						sizeY = blockbucket.sizeY,}
	
	entity.exitSize = 20

	--entity.endColor = {200, 200, 0, 160}
	entity.endColor = {230, 230, 0, 255} 
	
	return entity
end

--------------------------------------------------------

function Level.newDemoLevel()
	local level = Level.new()
	--level.segsToCreateBlocks.limit = 1.2

	
	level.x = 1
	

	level.demoLevel = Counter:new(1, 4)

	-- Methods overrided
	level.update = Level.updateSequence 
	level.endOfLevel = Level.demoEndOfLevel
	
	level.MaxStyle = 3
	level.style = Counter:new(1, level.MaxStyle)
	

	return level
end

-- Demo level
function Level.demoEndOfLevel(self)
	self.x = 1
	self.blocks = 0
	game.newLevel()

	if self.demoLevel:add() then
		game.changeLevelObject(game.DemoLevelName)
	end
end

-- Demo level
function Level.updateSequence(self, dt)
	if enviroment.isTimeFor(self.segsToCreateBlocks) then
		
		if self.demoLevel:val() == 1 then
			--blockbucket.addMatrix3x2(self.x, -1, self.style:val())
			Level.updateStairLevel(self)
		elseif self.demoLevel:val() == 2 then
			--blockbucket.addMatrix1x5(self.x, -1, self.style:val())
			--self.x = (self.x > (blockbucket.M+3)) and 1 or self.x+3
			Level.updateColumnLevel(self)
		else
			if self.style == 1 then 
				blockbucket.addMatrix3x2(self.x, -1, self.style:val())
			else
				blockbucket.addMatrix1x5(self.x, -1, self.style:val())
			end
			self.x = (self.x > (blockbucket.M+3)) and 1 or self.x+3
		end

		
		--self.style = (self.style == self.MaxStyle) and 1 or self.style+1
		-- Change others


			self.blocks = self.blocks +1
			if self.blocks == (blockbucket.M * blockbucket. N) then
				self.segsToCreateBlocks.limit = -0.5
			end

			
		self.style:add()
	end
end

function Level.updateStairLevel(self)
	if self.x <= blockbucket.M then
		blockbucket.addMatrix3x1(blockbucket.M - self.x, -1, self.style:val())
		self.x = self.x +1
	end

end

function Level.updateColumnLevel(self)
	if self.blocks < 8 then
		blockbucket.addMatrix4x4(self.x, -1, self.style:val())
		blockbucket.addMatrix4x4(self.x +12, -1, self.style:val())
	--blockbucket.addMatrix4x4(self.x +14, -1, self.style:val())
--[[
	if self.x == 1 then
		self.x = 4
	else
		self.x = 1 
	end
	]]
		self.x = (self.x == 1) and 4 or 1
		
	end
end

-- Load external resources
function Level.getImageNames()
	--self.imgNames = {R.blocks.b01. R.blocks.b02}
	return {"/assets/imgs/bloque01.png", "/assets/imgs/bloque02.png"}
end


function Level.draw(self)
	-- Draws the sun
	love.graphics.setColor(self.endColor);
	--love.graphics.rectangle( "fill", self.exitPos.x, self.exitPos.y, self.exitPos.sizeX, self.exitPos.sizeY)
	love.graphics.draw( game.sunimg, self.exitPos.x, self.exitPos.y)

end

function Level.update(self, dt)
	-- Have I to call Blockbucket for a new block ?
	-- Change this dependency
	if blockbucket.isTimeFor(self.segsToCreateBlocks) then
		blockbucket.addMatrix3x3(math.random(blockbucket.M-2), -1)
	end
end




function Level.checkEndOfLevel(self, player)
	if Level.collides(self.exitPos, player) then
		self.endOfLevel(self)
	end

end

-- Call game by defauls
function Level.endOfLevel(self)
	
end

----------------------------------------------------------

function Level.newRandomLevel()
	local level = Level.new()
	level.segsToCreateBlocks.limit = 1.5
	
	level.blocks = 0
	--level.demoLevel = 0
	level.demoLevel = Counter:new(1, 5)

	-- Methods overrided
	level.update = Level.updateRandomLevel 
	level.endOfLevel = Level.randomEndOfLevel
	
	level.MaxStyle = 2

	level.generators = {blockbucket.addMatrix3x3,
						blockbucket.addMatrix3x2,
						blockbucket.addMatrix1x5,
						blockbucket.addTrap4x3,
						blockbucket.addHouse4x3,
						blockbucket.addT3x3}
	return level
end


function Level.updateRandomLevel(self, dt)
	if enviroment.isTimeFor(self.segsToCreateBlocks) then
		local randomBlock = math.random(1, #self.generators)
		local blockX = math.random(1, blockbucket.M)
		local style = math.random(1, self.MaxStyle)
		self.generators[randomBlock](blockX, -1, style)
		self.blocks = self.blocks + 1
	end
end


function Level.randomEndOfLevel(self)
	if 	self.segsToCreateBlocks.limit > 0.5 then
		self.segsToCreateBlocks.limit = self.segsToCreateBlocks.limit - 0.5
	else
		if blockbucket.segsToMoveTheBlocks.limit > 0.1 then
			blockbucket.segsToMoveTheBlocks.limit = blockbucket.segsToMoveTheBlocks.limit -0.1
		end
	end

	
	game.newLevel()

	if self.demoLevel:add() then
		game.changeLevelObject(game.RandomLevelName )
	end
end



-----------------------------------------------

function Level.newLoneBlocksLevel()
	local level = Level.new()
	level.segsToCreateBlocks.limit = 1
	
	level.blocks = 0
	--level.demoLevel = 0
	level.MaxStyle = 2

	-- Methods overrided
	level.update = Level.updateLoneBlockLevel 
	level.endOfLevel = Level.endOfLoneBlockLevel
	

	level.blocksInARow = 2 
	level.levelsCounter = Counter:new(1, 5)

	return level
end


function Level.updateLoneBlockLevel(self, dt)
	if blockbucket.isTimeFor(self.segsToCreateBlocks) then
		local blockX
		local style

		for i = 1, self.blocksInARow do
			blockX = math.random(1, blockbucket.M)
			style = math.random(1, self.MaxStyle)
			blockbucket.addMatrix1x1(blockX, -1, style)
			self.blocks = self.blocks + 1
		end
	end
end


function Level.endOfLoneBlockLevel(self)
	self.blocksInARow = self.blocksInARow + 1
	
	self.x = 1
	self.blocks = 0
	game.newLevel()

	if self.levelsCounter:add() then
		game.changeLevelObject(game.LoneBlockLevelName)
	end
end



-----------------------------------------------


function Level.collides(a, b)	
	local l1 = a.x
	local t1 = a.y
	local w1 , h1 = a.sizeX, a.sizeY
	
	local l2,t2
	
	l2 = b.x
	t2 = b.y

	local w2,h2 = b.sizeX, b.sizeY

	return l1 < l2+w2 and l1+w1 > l2 and t1 < t2+h2 and t1+h1 > t2 
end




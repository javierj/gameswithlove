require("src/player")
require("src/blockbucket")
require("src/blockgroup")
require("src/level")
require("src/sounds")
require("src/powerbar")
require("libs/counter")

game = {}


function game.load()

	player.load()
	blockbucket.load()
	sounds.load()

	sounds.playMusicLoop()
	
	-- Set player limits
	player.MinX = blockbucket.getMinX()
	player.MaxX = blockbucket.getMaxX()
	player.MaxY = blockbucket.getMaxY()


	game.DemoLevelName = "DemoLevel"
	game.RandomLevelName = "RandomLevel"
	game.LoneBlockLevelName = "LoneBlockLevel"
	game.EndGameLevelName = "EndGame"
	game.levelSequence = {[game.DemoLevelName] = game.RandomLevelName,
			[game.RandomLevelName] = game.LoneBlockLevelName,
			[game.LoneBlockLevelName] = game.EndGameLevelName} 

	
	game.backgroundimg = love.graphics.newImage(R.g.background)
	game.shinyimg = love.graphics.newImage(R.g.shiny)
	game.sunimg = love.graphics.newImage(R.g.sun)
	game.endGameImg = love.graphics.newImage(R.g.endGame)
	game.gameOverImg = love.graphics.newImage(R.g.gameOver)


	game.imgs = game.getImagesFromLevel()

	game.GAME = "play the game"
	game.ENDOFLEVEL = "show an image to the next level"
	game.ENDOFGAME = "show an image and goes to the main screen"
	game.GAMEOVER = "player has been killed"
	

	game.BLOCKMOVE = "Blocks are falling down"
	game.BLOCKQUITE = "Blocks are quite"
	
	game.start()

end


function game.getImagesFromLevel()
	local imgs = {}
	-- No diferent images for level
	--for _, n in pairs(game.l.getImageNames()) do
	for _, n in pairs(Level.getImageNames()) do
		table.insert(imgs, love.graphics.newImage(n))
	end
	return imgs
end


function game.start()

	player.setInitialPos()

	--game.isOver = false

	game.loadLevel(game.DemoLevelName)

	game.blockstate = game.BLOCKMOVE

	game.deathscounter = Counter:new(0, 5)
	game.waitingameover = Counter:new(0, 4)
	game.state = game.GAME

	blockbucket.start()
	powerbar.load()
end

function game.loadLevel(newLevel)

--	game.l = Level.newDemoLevel()
--	game.l = Level.newRandomLevel()
	if newLevel == game.DemoLevelName then
		game.l = Level.newDemoLevel()
	end
	if newLevel == game.RandomLevelName then
		game.l = Level.newRandomLevel()
	end
	if newLevel == game.LoneBlockLevelName then
		game.l = Level.newLoneBlocksLevel()
	end

end


function game.draw()
	love.graphics.setColor(255,255,255);
	love.graphics.draw(game.backgroundimg,0,0)

	--if game.isOver then
		--love.graphics.setColor(100,255,240);
		--love.graphics.print("Game over.....", 50, enviroment.MaxY - 30);
	--end


	blockbucket.draw()
	game.l.draw(game.l)

	game.drawPowerBar()
	player.draw()

	if game.state == game.ENDOFLEVEL then
		love.graphics.setColor(255,255,255, 200)
		love.graphics.draw(game.shinyimg,80,80)
		return
	end
	if game.state == game.ENDOFGAME then
		love.graphics.setColor(255,255,255, 240)
		love.graphics.draw(game.endGameImg,0,10)
		return
	end
	if game.state == game.GAMEOVER then
		love.graphics.setColor(255,255,255, 240)
		love.graphics.draw(game.gameOverImg,40,20)
		return
	end
	
	

end

function game.drawPowerBar()
	local inc = 15
	local dec = 0
	local lines = 10 

	local xBase = blockbucket.ScreenX + (blockbucket.sizeX * 3)
	local yBase = blockbucket.ScreenY + blockbucket.sizeX
	local space = (yBase - blockbucket.sizeY) / powerbar.limit
	local yEnd = yBase - (space * powerbar.count)

	for i = 1, lines do
		local barColor = {255 - dec, 0, 0}
		love.graphics.setColor(barColor);
		love.graphics.line(xBase+i, yBase, xBase+i, yEnd)
		dec = dec + inc
	end
end




function game.update(dt)
	if game.state ~= game.GAME then
		return
	end

	game.collisions(dt)

	powerbar.update(dt)

	player.update(dt)
	
	if game.blockstate == game.BLOCKMOVE then
		game.l.update(game.l, dt)
		blockbucket.update(dt)
	end
end


function game.keypressed(key)
--	player.keypressed(key)
	if game.state == game.ENDOFGAME or game.state == game.GAMEOVER then
		--if game.waitingameover.add() then
			game.start()
			main.changeState(main.SPLASH)
		--end
	end
	game.state = game.GAME
end

--[[
function game.collisions(dt)

	game.l.checkEndOfLevel(game.l, player)


	
	local b = game.checkCollisionUp()
	if b then
		return
	end


	if player.isJumpingUp() == false then
		game.checkFallingDown()
	--else
		--game.checkCollisionUp()
	end

	game.chekLeftRight()

end
]]


-- Now collisions methods return true of farlse and this method
--takes a decision
function game.collisions(dt)

	game.l.checkEndOfLevel(game.l, player)

	
	local colInfo = game.checkCollisionUpAndDown()


	--if colInfo.colUp and colInfo.colDown and game.isCollisionLeftRight() == false then
	if colInfo.colUp and colInfo.colDown and game.isCollisionLeftRight() == false then
		game.gameOver()
		return
	end
	if colInfo.colUp then
		player.startToFallDown((colInfo.jUp * blockbucket.sizeY)+blockbucket.sizeY+1)
	end
	if colInfo.colDown then
		if 	player.isFalling() then	
			player.stopFalling(colInfo.jDown * blockbucket.sizeY)
		end
	else
		if player.isJumpingUp() == false then
			player.startToFallDown()
		end
	end

	game.chekLeftRight()

--	local b = game.checkCollisionUp()
--	if b then
--		return
--	end


--	if player.isJumpingUp() == false then
--		game.checkFallingDown()
	--else
		--game.checkCollisionUp()
--	end

	

end


-- Merge with next function
function game.isCollisionLeftRight()
	local i, j = blockbucket.getMatrixIndexesFromPoint(player.getRCPUp())

	--if blockbucket.matrix[i][j] then
	if blockbucket.hasBlockIn(i,j) then
		return true
	end

	i, j = blockbucket.getMatrixIndexesFromPoint(player.getLCPUp())
	if i == 0 or j == 0 then
		return false
	end

	--if blockbucket.matrix[i][j] then
	if blockbucket.hasBlockIn(i,j) then
		return true 
	end	

	return false
end

function game.chekLeftRight()
	local i, j = blockbucket.getMatrixIndexesFromPoint(player.getRCPUp())

	--if blockbucket.matrix[i][j] then
	if blockbucket.hasBlockIn(i,j) then
		player.stopMovingRight(i * blockbucket.sizeX)
	end

	i, j = blockbucket.getMatrixIndexesFromPoint(player.getLCPUp())
	if i == 0 or j == 0 then
		return
	end

	--if blockbucket.matrix[i][j] then
	if blockbucket.hasBlockIn(i,j) then
		player.stopMovingLeft((i+1) * blockbucket.sizeX) 
	end	

end

function game.checkFallingDown()
	local i1, j1 = blockbucket.getMatrixIndexesFromPoint(player.getLCPLeft())

	if i1 == 0 or j1 == 0 then
		return
	end


	--if blockbucket.matrix[i1][j1] then
	if blockbucket.hasBlockIn(i1,j1) then
		player.stopFalling(j1 * blockbucket.sizeY)
		return true
	end

	local i2, j2 = blockbucket.getMatrixIndexesFromPoint(player.getLCPRight())

	--if blockbucket.matrix[i2][j2] then
	if blockbucket.hasBlockIn(i2,j2) then
		player.stopFalling(j2 * blockbucket.sizeY)
		return true
	end
	if player.isFalling() == false and player.isOnTheGround() == false then
		player.startToFallDown()
		return true
	end
	
	return false
end


function game.checkCollisionUpAndDown()

	local cUp = false

	local i1, j1 = blockbucket.getMatrixIndexesFromPoint(player.getUCPLeft())
	local i2, j2 = blockbucket.getMatrixIndexesFromPoint(player.getUCPRight())
	local ljUp

	if blockbucket.hasBlockIn(i1,j1) then
		ljUp = j1
		cUp = true
	end
	if blockbucket.hasBlockIn(i2,j2) then
		ljUp = j2
		cUp = true
	end
	--[[ 
	for _, g in pairs(blockbucket.groups) do
		for _, c in pairs(g.minimumcell) do
			if (c.x == i1 and c.y == j1) 
			  or (c.x == i2 and c.y == j2) then
				cUp = true			
			end
		end
	end
]]
	local cDown = false
	local lj
	i1, j1 = blockbucket.getMatrixIndexesFromPoint(player.getLCPLeft())
i2, j2 = blockbucket.getMatrixIndexesFromPoint(player.getLCPRight())

	--if i1 > blockbucket.M and j1 > blockbucket.N then
	--	cDown = true
	--else
	-- Refactor. Use a loop
		if i1 ~= 0 or j1 ~= 0 then
			if blockbucket.hasBlockIn(i1,j1) then
				cDown = true
				lj = j1
			end
			if blockbucket.hasBlockIn(i2,j2) then
				cDown = true
				lj = j2
			end
			--cDown = blockbucket.hasBlockIn(i1,j1) or blockbucket.hasBlockIn(i2,j2)

		end
	--end
--[[
	--if blockbucket.matrix[i1][j1] then
	if blockbucket.hasBlockIn(i1,j1) then
		player.stopFalling(j1 * blockbucket.sizeY)
		return true
	end

	

	--if blockbucket.matrix[i2][j2] then
	if blockbucket.hasBlockIn(i2,j2) then
		player.stopFalling(j2 * blockbucket.sizeY)
		return true
	end
]]
	return {colUp = cUp, colDown = cDown, jDown = lj, jUp = ljUp}
end


function game.checkCollisionUp()
	local i1, j1 = blockbucket.getMatrixIndexesFromPoint(player.getUCPLeft())
	local i2, j2 = blockbucket.getMatrixIndexesFromPoint(player.getUCPRight())

	for _, g in pairs(blockbucket.groups) do
		for _, c in pairs(g.minimumcell) do
			if (c.x == i1 and c.y == j1) 
			  or (c.x == i2 and c.y == j2) then
				
			  	if player.isJumpingUp() == false then
					game.gameOver()

				else
					player.startToFallDown((c.y * blockbucket.sizeY)+blockbucket.sizeY+1)
				end
				return true
			end
		end
	end
	return false
end


-- Called when the game is over
function game.gameOver()
	--if game.deathscounter:add() then
		sounds.playDieSound()
		--game.isOver = true
		game.state = game.GAMEOVER

		love.event.clear()
	--end
end


function game.newLevel()
	game.state = game.ENDOFLEVEL
	game.deathscounter:restart()
	-- creal blockbucket
	--blockbucket.createMatrix()
	blockbucket.start()
	-- set player in initial pos
	player.setInitialPos()
end

function game.changeLevelObject(oldLevel)
	local newLevel = game.levelSequence[oldLevel]
	if newLevel == game.EndGameLevelName then
		--game.isOver = true
		game.state = game.ENDOFGAME
		return
	end
	game.loadLevel(newLevel)
end

-- Called when no more blocks
function game.stopTime()
	game.blockstate = game.BLOCKQUITE
end

function game.startTime()
	game.blockstate = game.BLOCKMOVE
end

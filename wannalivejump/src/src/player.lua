player = {}

function player.load()
	player.img = love.graphics.newImage(R.player.img)


	player.MinX = 0
	player.MaxX = enviroment.MaxX
	player.MaxY = enviroment.MaxY

	--player.sizeX = 10
	--player.sizeY = 10
	player.color = {255, 0, 0}

	player.sizeX = player.img:getWidth()
	player.sizeY = player.img:getHeight()

	player.velX = 0
	player.velY = 0
	
	player.velYCte = -300
	player.velXCte = 150
	player.velFalling = 200

	--player.lastdt = 0

	player.moveRight = true
	player.moveLeft = true
	
	-- Mas pequeña, mas salta
	gravity = 350

	player.setInitialPos()
end


function player.update(dt)
	--player.lastdt = dt
	player.pollkeyboard(dt)
	player.updatePlayerPosition(dt)
end


function player.draw()
	--love.graphics.setColor(player.color);
	--love.graphics.rectangle( "fill", player.x, player.y, player.sizeX, player.sizeY )
	love.graphics.setColor({255, 255, 255})
	love.graphics.draw(player.img, player.x, player.y)
end

--function player.keypressed(key)
--end


function player.setInitialPos()
	player.x = enviroment.MaxX / 2
	player.y = enviroment.MaxY / 2
end

--[[ Change the speed ]]
function player.pollkeyboard(dt) 
	
	-- kill yourself
	if enviroment.keyPressed("q") then
		game.gameOver()
		return
	end


	-- Up & Down

	if enviroment.keyPressed("up") or enviroment.keyPressed(" ") then
    	 if player.isJumping() == false then -- we're probably on the ground, let's jump
    	 	sounds.playJumpSound()
            player.velY = player.velYCte
        end
    elseif love.keyboard.isDown("down") then
       --player.y = player.y + (player.velY *dt) 
    end 

	-- Left & right
	if love.keyboard.isDown("left") and player.moveLeft then
         player.velX = (-1) * player.velXCte
    elseif love.keyboard.isDown("right") and player.moveRight then
       --player.x = player.x + (player.velX *dt) 
    	player.velX = player.velXCte
    end 
	
	player.moveRight = true
	player.moveLeft = true
   
end

--[[ Move the player using the speed ]]
function player.updatePlayerPosition(dt)
	player.updateX(dt)

 	if player.velY ~= 0 then -- we're probably jumping
        player.y = player.y + player.velY * dt -- dt means we wont move at
        -- different speeds if the game lags
        player.velY = player.velY + gravity * dt

        -- ProbablyI can delete this statement
        if player.isOnTheGround() then -- we hit the ground again
            player.velY = 0
            player.y = player.MaxY - player.sizeY
        end

    end
    player.velX = 0
end

--[[ Checks if x position is inside the screen
]]
function player.updateX(dt)
	if player.x <= player.MinX and player.velX < 0 then
		player.x = player.MinX
	elseif (player.x + player.sizeX) >= player.MaxX and player.velX > 0 then
		player.x = player.MaxX - player.sizeX
	else
		player.x = player.x + (player.velX *dt)   
	end
end

function player.isOnTheGround()
	return (player.y+player.sizeY) >= player.MaxY
end

function player.startToFallDown(newY)
		player.velY = player.velFalling
	if newY ~= nil then
		player.y = newY
	end
end

function player.isFalling()
	return player.velY > 0
end


function player.isJumping()
	return player.velY ~= 0
end

function player.isJumpingUp()
	return player.velY < 0
end


function player.stopFalling(newY)
	player.velY = 0
	player.y = newY - player.sizeY
end

function player.stopMovingRight(newX)
	player.x = newX - player.sizeX -1
	player.moveRight = false
end

function player.stopMovingLeft(newX)
	player.x = newX +1
	player.moveLeft = false
	--	player.velX = 0
end



-- Collision points

function player.getLCPLeft()
	return {x=player.x +1, y=player.y + player.sizeY + 1}
end

function player.getLCPRight()
	return {x=player.x + player.sizeX-1, y=player.y + player.sizeY + 1}
end

function player.getRCPDown()
	return {x=player.x + player.sizeX+1, y=player.y + player.sizeY}
end

function player.getRCPUp()
	return {x=player.x + player.sizeX+1, y=player.y}
end

function player.getLCPUp()
	return {x=player.x -1, y=player.y}
end



function player.getUCPLeft()
	return {x=player.x +1, y=player.y -1}
end

function player.getUCPRight()
	return {x=player.x + player.sizeX-1, y=player.y -1}
end

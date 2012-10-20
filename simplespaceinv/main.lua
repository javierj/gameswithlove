-- TDD Demo. Space Invaders
-------------------------------------------------

function love.load()

	-- init constants
	X = love.graphics.getWidth()
	Y = love.graphics.getHeight()
	PlayerSize = 20
	EnemySize = 30
	ShootSize = 5
	BgColor = {0,0,0}
	PlayerSpeed = 160
	EnemySpeed = 120
	ShootSpeed = 300

	-- Init global variables
	enemyRight = true
	shoots = {}
	shootLimit = 0.25
	shootCount = 0
	endOfGame = false
	
	-- Init player
	player = {}
	player.x = (X/2) - (PlayerSize /2)
	player.y = Y -PlayerSize - 20
	player.color = {255,0,0}
	
	-- Init enemies
	enemies = {}
	local _x = 10
	local _y = 10
	for i = 1, 40 do
		enemy = {x = _x, y= _y}
		table.insert(enemies,enemy)
		_x = _x+EnemySize + (EnemySize/2)
		if _x > ((40*8)+10) then
			_x = 10
			_y = _y+EnemySize + (EnemySize/2)
		end
	end
	
	
end

function love.update(dt) 
	-- Update Player reading keyboard
	if love.keyboard.isDown("left") and player.x > 0 then
        player.x = player.x - (PlayerSpeed * dt) 
    end 
	if love.keyboard.isDown("right") and player.x < (X-PlayerSize) then
        player.x = player.x + (PlayerSpeed * dt)  
    end 

	-- Create new shoot
	shootCount = shootCount + dt
	if love.keyboard.isDown("up") and shootCount >= shootLimit then
		shootCount = 0
		local shoot={x = player.x + (PlayerSize /2), y = player.y}
		table.insert(shoots, shoot)
    end 
	if shootCount > 100 then
		shootCount = 0
	end
	
	-- Check Collisions
	for eI = #enemies, 1, -1 do
		e = enemies[eI]
		for sI = #shoots, 1, -1 do
			s = shoots[sI]
			if collide(e, s) then
				table.remove(enemies, eI)
				table.remove(shoots, sI)
				break
			end
		end
	end
	
	
	-- Update enemies
	local inc = -1
	if enemyRight then
		inc = 1
	end	
	local bigX = -1
	local smallX  = Y
	local bigY = 0
	for _,e in pairs(enemies) do	
		e.x = e.x + (inc * EnemySpeed * dt)
		if e.x > bigX then
			bigX = e.x
		end
		if e.x < smallX then
			smallX = e.x
		end
		-- For the end of game
		if bigY < e.y then
			bigY = e.y
		end
	end
	
	-- Verify limits, change direction and move enemies down
	if enemyRight then
		if bigX >= (X-EnemySize) then
			enemyRight = false
			updateY()
		end
	elseif smallX <= 10 then
		enemyRight = true
		updateY()
	end
	
	-- Move shoots
	for sI = #shoots, 1, -1 do
		s = shoots[sI]
		s.y = s.y - (ShootSpeed * dt)
		if s.y == 0 then
			table.remove(shoots, sI)
		end
	end
	
	-- Check end of game
	endOfGame = (bigY + EnemySize) > player.y
	if #enemies == 0 then
		endOfGame = true
	end
	
end



function love.draw()
	love.graphics.setBackgroundColor(BgColor);
	
	-- End of game
	if endOfGame then
		love.graphics.setColor(100,233,240);
		love.graphics.print("End !!!!!!", 400, 300);
		return
	end
	
	-- Draw player
	love.graphics.setColor(player.color);
	love.graphics.rectangle("fill", player.x,player.y ,PlayerSize,PlayerSize)
	
	-- Draw enemies
	love.graphics.setColor(0, 0, 200);
	for _,e in pairs(enemies) do
		love.graphics.rectangle("fill", e.x,e.y ,EnemySize,EnemySize)
	end
	
	-- Draw shoots
	love.graphics.setColor(0, 200, 0);
	for _,s in pairs(shoots) do
		love.graphics.rectangle("fill", s.x,s.y ,ShootSize,ShootSize)
	end
	
end



-- Helpper functions

function updateY()
	for _,e in pairs(enemies) do
		e.y = e.y + 20
	end
end

function collide(enemy, shoot)	
	local l1 = enemy.x
	local t1 = enemy.y
	local w1 = EnemySize
	local h1 = EnemySize
	
	local l2,t2,w2,h2
	
	l2 = shoot.x
		t2 = shoot.y
		w2 = ShootSize
		h2 = ShootSize
	if l1 < l2+w2 and l1+w1 > l2 and t1 < t2+h2 and t1+h1 > t2 then
		return true
	end

	return false
end

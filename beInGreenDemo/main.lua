
require("enviroment")
player = {}
base={}
enemies = {}
shoots = {}
starfield = {}
rocks = {}

function love.load()
	-- init global variables for the enviroment
	enviroment.MaxX = love.graphics.getWidth()
	enviroment.MaxY = love.graphics.getHeight()
	
	starfield = createStarField()
	
	-- init player	
	player.x = 250
	player.size = 10
	player.y = (enviroment.MaxY / 2) - (player.size/2)
	player.color = {255, 20, 100}
	player.vel = enviroment.PlayerVelocity
	
	-- init base
	base.size = 20
	base.x = enviroment.MaxX - base.size - 10
	base.y = (enviroment.MaxY / 2) - (base.size/2)
	base.color = {0, 255, 0}
	base.vel = 0
	
	
	enviroment.rocksActivated = false
	rockCounter = {counter = 0, limit = 0.3}
	
	turbo = false
	turboLimit = 500
	turboCount = 100
	turboSpeed = 300
	turboReload =0.1
end

--[[
]]
function love.update(dt)
	
	if enviroment.gameStatus == enviroment.GAMEOVER then
		return
	end

	updatePlayer(dt)
	updateStarfield(dt)
	updateRocks(dt)
end


function love.draw()
	love.graphics.setBackgroundColor(enviroment.BackgroundColor)

	-- Draw starfield
	love.graphics.setColor(enviroment.StarColor);
	for _,s in pairs(starfield) do
		love.graphics.rectangle("fill", s.x,s.y ,enviroment.StarSize ,enviroment.StarSize )
	end

	-- draw base
	love.graphics.setColor(base.color);
	love.graphics.rectangle( "fill", base.x, base.y, base.size, base.size )

	--draw player
	love.graphics.setColor(player.color);
	love.graphics.rectangle( "fill", player.x, player.y, player.size, player.size )
	
	--draw rocks	
	for _,rock in pairs(rocks) do
		love.graphics.setColor(rock.color);
		love.graphics.rectangle( "fill", rock.x, rock.y, rock.size, rock.size)
	end
	
	-- draw turbo
	local size = enviroment.MaxX / turboLimit
	love.graphics.setColor(player.color);
	love.graphics.rectangle( "fill", 0, enviroment.MaxY - 10, size * turboCount, 10 )
	

end


---------------------------------------------------------
-- Helpper functions

function updatePlayer(dt) 
	-- Turbo
	turbo = love.keyboard.isDown(" ")
	if turbo == false and turboCount < turboLimit then
		turboCount = turboCount + turboReload
	end
	
	-- Up & Down
	if love.keyboard.isDown("up") then
        player.update("up", dt)
    elseif love.keyboard.isDown("down") then
        player.update("down", dt)  
    end 

	-- Left & right
	if love.keyboard.isDown("left") then
         player.update("left", dt)  
    elseif love.keyboard.isDown("right") then
        player.update("right", dt)  
    end 
	
	if isIn(player, base) then
		enviroment.gameStatus = enviroment.GAMEOVER
	end
end


function player.update(dir, dt)
	local inc = 0
	if turbo and turboCount > 0 then
		turboCount = turboCount -0.5
		inc = turboSpeed
	end
	
	if love.keyboard.isDown("up") then
        player.y = player.y - ((player.vel+inc) *dt) 
    elseif love.keyboard.isDown("down") then
        player.y = player.y + ((player.vel+inc) *dt)  
    end 

	-- Left & right
	if love.keyboard.isDown("left") then
         player.x = player.x - ((player.vel+inc) *dt)  
    elseif love.keyboard.isDown("right") then
        player.x = player.x + ((player.vel+inc) *dt) 
    end 

end


function updateCounter(object, dt )
	object.counter = object.counter + dt
	if object.counter >= object.limit then
		object.counter = 0
		return true
	end
	return false
end


function createStarField()
	local field = {}
	local star
	for s = 1, enviroment.StarsInField do
		star = {x=math.random( 10 ,(enviroment.MaxX-10)), y = math.random( 10 ,(enviroment.MaxY-10))}
		table.insert(field, star)
	end
	return field
end


function updateStarfield(dt)
	-- Move shoots
	local removed = false
	for sI = #starfield, 1, -1 do
		s = starfield[sI]
		s.x = s.x -(enviroment.StarVelocity * dt)
		if s.x < 1 then
			table.remove(starfield, sI)
			removed = true
		end
		
	end

	-- Creates a new star if other star was deleted
	if removed then
			local star = {x=enviroment.MaxX-10, y = math.random( 10 ,(enviroment.MaxY-10))}
			table.insert(starfield, star)
		end

end



function updateRocks(dt)

	if enviroment.rocksActivated == false then
		if player.x >  (enviroment.MaxX / 2) then
			enviroment.rocksActivated = true
		else
			return
		end
	end

	for sI = #rocks, 1, -1 do
		s = rocks[sI]
		s.x = s.x  +  (s.vel * dt)
		if (s.x + s.size) > enviroment.MaxX and s.vel > 0 then
			table.remove(rocks, sI)
		elseif (s.x) < (0-s.size) and s.vel < 0 then
			table.remove(rocks, sI)
		else
			-- Detect collsion with player
			if collide(s, player) then
				enviroment.gameStatus = enviroment.GAMEOVER
				--table.remove(rocks, sI)
			end
			-- Detect Collision with other asteroids
			for astI = (sI-1), 1, -1 do
				local ast = rocks[astI]
				if collide(s, ast) then
					table.remove(rocks, sI)
					--table.remove(rocks, astI)
					break
				end
			end -- for
		end 
	end -- for
	
	-- create a new rock at random
	if updateCounter(rockCounter, dt) then
		--local v = math.random(1, 6)
		--if v <= 5 then
			table.insert(rocks, createRock())
		--end
	end
end

--[[ Creates and return a new rock object ]]
function createRock()
	local rock = {}
	--rock.color = {100, 120, 200} -- constant, never changes
	rock.color = {}
	rock.color[1] = 100 + math.random(-30, 30)
	rock.color[2] = 100 + math.random(-30, 30)
	rock.color[3] = 100 + math.random(-30, 30)
	
	rock.vel = 160 + math.random(0, 60)
	rock.size = 20 + math.random(0, 40)
	rock.y = math.random(rock.size+5, (enviroment.MaxY-rock.size-5))

	local dir = math.random(1, 2)
	if (dir == 1) then
		rock.x = enviroment.MaxX
		rock.vel = -rock.vel
	else
		rock.x = -rock.size
	end

	
	return rock
end

--[[ Detects a collision between two objects ]]
function collide(a, b)	
	local l1 = a.x
	local t1 = a.y
	local w1 , h1
	
	if a.size ~= nil then
		w1 = a.size
		h1 = a.size
	else
		w1 = a.width
		h1 = a.height
	end
	
	local l2,t2,w2,h2
	
	l2 = b.x
		t2 = b.y
	if b.size ~= nil then
		w2 = b.size
		h2 = b.size
	else
		w2 = b.width
		h2 = b.height
	end

	if l1 < l2+w2 and l1+w1 > l2 and t1 < t2+h2 and t1+h1 > t2 then
		return true
	end

	return false
end


function isIn(a, b)	
	local l1 = a.x
	local t1 = a.y
	local w1 , h1
	
	if a.size ~= nil then
		w1 = a.size
		h1 = a.size
	else
		w1 = a.width
		h1 = a.height
	end
	
	local l2,t2,w2,h2
	
	l2 = b.x
		t2 = b.y
	if b.size ~= nil then
		w2 = b.size
		h2 = b.size
	else
		w2 = b.width
		h2 = b.height
	end
	
	if l1 >= l2 and t1 >= t2 and (l1+w1) <= (l2+w2) and (t1+h1) <= (t2+h2) then
		return true
	end

	return false
end


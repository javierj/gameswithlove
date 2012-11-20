-- Enviroment

enviroment = {}

-- Constants

enviroment.MaxX = 0
enviroment.MaxY = 0


-- Functions

function enviroment.load() 
	enviroment.MaxX = love.graphics.getWidth()	
	enviroment.MaxY = love.graphics.getHeight()
end

function enviroment.isTimeFor(block)
	local now = love.timer.getTime()
	local time = now - block.counter
	if time < block.limit then
		return false
	end
	block.counter = now
	return true

end


function enviroment.keyPressed(key)
	return love.keyboard.isDown(key)
end
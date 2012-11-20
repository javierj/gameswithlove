

powerbar = {}

function powerbar.load()
	powerbar.limit = 500
	powerbar.count = powerbar.limit
	--turboSpeed = 300
	--turboReload =0.1
	powerbar.timeToReduce={counter = 0, limit = 0.01}
	powerbar.timeToIncrease={counter = 0, limit = 0.1}

end


function powerbar.update(dt)

	if enviroment.keyPressed("z") and powerbar.count > 0 then
		if enviroment.isTimeFor(powerbar.timeToReduce) then
			powerbar.count = powerbar.count -1
		end
		game.stopTime()
	else
		game.startTime()
		if enviroment.isTimeFor(powerbar.timeToIncrease) and powerbar.count < powerbar.limit then
			powerbar.count = powerbar.count +1
		end

	end

end

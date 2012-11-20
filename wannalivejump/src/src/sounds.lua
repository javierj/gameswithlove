

sounds = {}

function sounds.load()
	sounds.jumpsnd =  love.audio.newSource(R.sounds.jump, "static")
	sounds.endOfLevelsnd =  love.audio.newSource(R.sounds.endOfLevel, "static")
	sounds.die =  love.audio.newSource(R.sounds.die, "static")

	--sounds.music = love.audio.newSource(R.sounds.killTheSun, "stream")
end


function sounds.play( sound )
	love.audio.play( sound )
end

function sounds.playDieSound()
	sounds.play( sounds.die )
end

function sounds.playJumpSound()
	sounds.play( sounds.jumpsnd )
end	

function sounds.playMusicLoop()
	--sounds.play( sounds.music )
end	
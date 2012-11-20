
require("autogenerated/R")
require("src/splash")
require("src/game")
require("src/over")
require("src/enviroment")


main = {}

function main.changeState(state)

	if state == main.SPLASH then
		main.state = main.SPLASH
		main.module = splash
	elseif state == main.GAME then
		main.state = main.GAME
		main.module = game
    
	  end
  
end


function love.load()
	main.SPLASH = 1
	main.GAME = 2
	main.OVER = 3
	main.state = nil
	main.changeState(main.SPLASH)
	
	enviroment.load()
	splash.load()
	game.load()
	over.load()
end


function love.draw()
	main.module.draw()
end

function love.update(dt)
	main.module.update(dt)
end



function love.keypressed(key)
	main.module.keypressed(key)
end

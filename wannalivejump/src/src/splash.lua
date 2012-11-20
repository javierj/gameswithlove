splash = {}

function splash.load()
	splash.img = love.graphics.newImage("assets/imgs/splashscreen.jpg")
	--splash.maintitle = love.graphics.newImage("assets/imgs/maintitle.png")
	splash.subtitle = love.graphics.newImage("assets/imgs/subtitle.png")
end

function splash.draw()
	local x, y

	-- Center de Image in the screen
	x =  (enviroment.MaxX - splash.img:getWidth()) / 2
	--y =  (enviroment.MaxY - splash.img:getHeight()) / 2
	

	love.graphics.draw(splash.img,x,y)

	-- Main title
	--x =  (enviroment.MaxX - splash.maintitle:getWidth()) / 2
	--y =  (enviroment.MaxY - splash.maintitle:getHeight()) / 2
	--love.graphics.draw(splash.maintitle,x,y)

	x =  (enviroment.MaxX - splash.subtitle:getWidth()) / 2
	y = enviroment.MaxY -  60
	love.graphics.draw(splash.subtitle,x,y)
end

function splash.update(dt)
	-- TODO
end

function splash.keypressed(key)
	main.changeState(main.GAME)
end
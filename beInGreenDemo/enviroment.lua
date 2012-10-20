-- Enviroment

enviroment = {}

-- Constants

enviroment.MaxX = 0
enviroment.MaxY = 0
enviroment.StarsInField = 30
enviroment.StarVelocity = 40
enviroment.StarSize = 2
enviroment.PlayerVelocity = 70


-- Colors
enviroment.BackgroundColor = {0, 0, 0}
enviroment.StarColor = {255, 255, 255}

-- Variables
enviroment.gameStatus = enviroment.PLAY
enviroment.PLAY = "play"
enviroment.GAMEOVER = "game-over"


enviroment.rocksActivated = true
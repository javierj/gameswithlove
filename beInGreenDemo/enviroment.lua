-- Enviroment

enviroment = {}

-- Constants

enviroment.MaxX = 0
enviroment.MaxY = 0
enviroment.ShootSize = 8
enviroment.ShootVelocity = 140
enviroment.StarsInField = 30
enviroment.StarVelocity = 40
enviroment.StarSize = 2
enviroment.PlayerVelocity = 70

enviroment.EnemySize = 10
enviroment.EnemyRespawnLimit = 10000
enviroment.MinEnemyNumber = 2

enviroment.Formation={0, -25, 25, -50, 50, -75, 75, -100, 100} 

-- Colors
enviroment.BackgroundColor = {0, 0, 0}
enviroment.EnemyColor = {40,33,140}
enviroment.StarColor = {255, 255, 255}

-- Variables
rockCounter = {counter = 0, limit = 0.5}
enviroment.gameStatus = enviroment.PLAY
enviroment.PLAY = "play"
enviroment.GAMEOVER = "game-over"

enviroment.formationIndex = 1

enviroment.rocksActivated = true
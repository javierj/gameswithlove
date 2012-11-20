Wanna Live ? Jump !!

This game is a crazy prototype for F*ck this Jam! (http://fuckthisjam.com/) 11-17-2012



1. Running the game

The game have been developed under Love2D (https://love2d.org) and Lua. But you don't need anything to run the game. You have an LOVE file containing the game and Love2D interpreter for Windows (c) so, you can execute it under Windows (c) platform.

You also have the source code and assets of the game in the folder next to the EXE. you don't need that folder if you run the BAT. If you have another operative system, you may download the Love2D runtime version for your system and run the game indicating the folder as parameter.



2. Story & Goal

You have to go into the sun in the upper corner of the screen. Then you will see a happy sun and you'll start the next level.

There is no a level counter but levels are finites. There are 11 levels grouped in 3 blocks. First block of levels only drops basic block in a predefined sequence. Second block of levels drops random blocks and third block... is a block nightmare. Unfortunately the end of the game is ... (SPOILER)... another happy sun image.

Remember than you can stop de blocks quit "z" key, but the reload is very slow.



3. Bugs

I have only tested the game in my own computer and, probably, I have not tested all the possible scenarios. However, there are well known bugs:

- You can jump out of the screen. Use it in your benefit.
- Collisions didn't work fine, so expect weird things. I have tried to don't kill you randomly



4. Music.

I haven't found any music with a free licence and a little file size. Sorry.



5. Contact

You can e-mail me at ukeitaro@yahoo.es
Hope you enjoy the game.



6. Source code

You have the source code an all assets of the game. Feel free to change anything you want and redistribute the game. You don't need to download anything else, just running the Love2D interpreter you can test your own modifications



7. Hacking the game

Do you wanna see other level blocks without playing? Just go into the source code folder, search for the game.lua file, edit it (it’s plain text) and change the parameter in the line “game.loadLevel(game.DemoLevelName)” . You can use two different values: game.RandomLevelName and game.LoneBlockLevelName

Then run the game from the command line writing: love2d wannalive to load the game in the folder instead of the original game in the .love file

Enjoy it.




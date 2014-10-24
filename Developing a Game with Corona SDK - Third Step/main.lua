--Hide status bar from the beginning
display.setStatusBar( display.HiddenStatusBar ) 

-- Start Physics
local physics = require("physics")
physics.start()
--physics.setDrawMode( "hybrid" )
	
-- Set Variables
_W 			= display.contentWidth; -- Get the width of the screen
_H 			= display.contentHeight; -- Get the height of the screen
motionx 	= 0; -- Variable used to move character along x axis
speed 		= 5; -- Set Walking Speed
playerInAir = true; -- Set a boolean of whether our guy is in the air or not
score 		= 0; -- Set Score to 0
snd_coin    = audio.loadSound("coin.wav") -- Set coin variable

--************************
-- Add Graphic Elements to Game

-- Add Sky to the background
local sky = display.newImage( "images/background_sky.png", true )
	sky.x = _W/2; sky.y = 160;
	
-- Add Grass floor to game
local grass_bottom = display.newImage( "images/grass_bottom.png", true )
	physics.addBody( grass_bottom, "static", { friction=0.5, bounce=0.3 } )
	grass_bottom.x = _W/2; grass_bottom.y = _H-35;
	grass_bottom:setReferencePoint(display.BottomLeftReferencePoint);
	grass_bottom.myName = "grass"

-- Add Grass to the background
local grass_top = display.newImage( "images/grass_top.png", true)
	grass_top.x = _W/2; grass_top.y = _H-95;

-- Add Guy		
guy = display.newImage( "images/guy.png" )
	physics.addBody( guy, "dynamic", { friction=0.5, bounce=0 } ) 
	guy.x = math.random(100,_W-100); guy.y = 170;
	guy.myName = "guy"

-- Add Left Wall
local left_wall = display.newRect(-5,0,5,_H)
	physics.addBody( left_wall, "static" )

-- Add Right Wall
local right_wall = display.newRect(_W+5,0,5,_H)
	physics.addBody( right_wall, "static")
	
-- Add left joystick button
local left = display.newImage ("images/btn_arrow.png")
	left.x = 45; left.y = 280;
	left.rotation = 180;

-- Add right joystick button
local right = display.newImage ("images/btn_arrow.png")
	right.x = 120; right.y = 282;

-- Add Jump button
local up = display.newImage ("images/btn_arrow.png")
	up.x = 440; up.y = 280;
	up.rotation = 270;

-- Add Score to Screen
local playerScore = display.newText("Score: "..score, 0, 0, native.systemFont, 16);
	playerScore:setTextColor(0, 0, 0);
-- End Graphic Elements
--*****************
	
	
--******************
-- Add Game Functionality
	
-- Stop character movement when no arrow is pushed
local function stop (event)
	if event.phase =="ended" then
		motionx = 0;
	end		
end
Runtime:addEventListener("touch", stop )

-- Move character
local function moveguy (event)
	guy.x = guy.x + motionx;	
end
Runtime:addEventListener("enterFrame", moveguy)

-- When left arrow is touched, move character left
function left:touch()
	motionx = -speed;
end
left:addEventListener("touch",left)

-- When right arrow is touched, move character right
function right:touch()
	motionx = speed;
end
right:addEventListener("touch",right)

-- Make character jump
function up:touch(event)
	if(event.phase == "began" and playerInAir == false) then
		playerInAir = true
		guy:setLinearVelocity( 0, -200 )
	end
end
up:addEventListener("touch",up)

-- Detect whether the player is in the air or not
function onCollision( event )
	-- If guy is touching grass, allow jump
	if(event.object1.myName == "grass" and event.object2.myName == "guy") then
		playerInAir = false;
	end

	-- Remove coin when it reaches the ground
	if(event.object1.myName == "grass" and event.object2.myName == "coin") then
		event.object2:removeSelf();
	end

	-- If guy collides with coin, remove coin
	if(event.object1.myName == "guy" and event.object2.myName == "coin") then
		score = score + 1;
		playerScore.text = "Score: " .. score
		event.object2:removeSelf();
		audio.play(snd_coin);
	end
end
Runtime:addEventListener( "collision", onCollision )

function createCoin()	
	coin = display.newCircle( math.random(20,_W-20), -25, math.random(8,14) )
	coin:setFillColor(math.random(245,255),math.random(210,223),7)
	coin:setStrokeColor(0,0,0)
	physics.addBody( coin, "dynamic" )
	coin.myName = "coin"
end
timer.performWithDelay( 800, createCoin, 0 )
-- End Game Functionality
--******************

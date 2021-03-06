-- START:newSpaceship
-- Define a new Spaceship class
Spaceship = Class( GameSprite )

-- Create a new spaceship sprite
function Spaceship:new( group )
    -- Initialize the Spaceship sprite
    self:initialize( spriteAnims.spaceshipSequence, group )
    
    -- Set the start coordinates and rotation
    local rot = math.pi * ( -0.4 + math.random( 8 ) / 10 )
    local dx = SHIP_DIST * math.sin( rot )
    local dy = - SHIP_DIST * math.cos( rot )
    local x = PLANET_X + dx
    local y = PLANET_Y + dy
    local rot = 90 + math.atan2( dy, dx ) * 180 / math.pi
    self.spriteInstance.rotation = rot
    self:moveTo( x, y )
    
    -- Set the speed
    self.speed = 1 + math.random(3)
end
-- END:newSpaceship

-- START:updateFunc
-- Spaceship update function 
--   (called each frame)
-- START:updatePos
-- START:checkPositiveHypotenuse
function Spaceship:update( )
-- END:checkPositiveHypotenuse
-- END:updatePos
    -- Ship movement goes here
    -- END:updateFunc
    -- START:updatePos
    -- Calculate the distance to the planet
    local dx = PLANET_X - self.spriteInstance.x
    local dy = PLANET_Y - self.spriteInstance.y
    local hyp = dx * dx + dy * dy
    
    -- START:checkPositiveHypotenuse
    -- Move the sprite only if the ship is not on the planet
    if hyp > PLANET_RADIUS_SQ then
        -- Move the sprite
        hyp = math.sqrt( hyp )
        self:move( self.speed * dx / hyp, self.speed * dy / hyp )
    end
    -- END:checkPositiveHypotenuse
-- START:updateFunc
-- START:checkPositiveHypotenuse
end
-- END:checkPositiveHypotenuse
-- END:updatePos
-- END:updateFunc

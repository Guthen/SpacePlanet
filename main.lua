require( "lua/planet" )

local zoom = 1
local cam_x, cam_y = 0, 0
show_planet_circle = true
show_planet_text = true

local function clamp( x, a, b )
    return x < a and a or x > b and b or x
end

function love.load()
    local Sun = Planet( "Sun", _, love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 32 )
        :setColor( 245, 209, 66 )

    local Mercure = Planet( "Mercure", Sun, 0, 0, 4 )
        :setColor( 243, 156, 18 )

    local Venus = Planet( "Venus", Sun, 0, 0, 4 )
        :setColor( 241, 196, 15 )

    local Earth = Planet( "Earth", Sun, 0, 0, 5 )
        :setColor( 66, 245, 129 )

    local Moon = Planet( "Moon", Earth, 0, 0, 3 )
        :setColor( 149, 165, 166 )

    local Mars = Planet( "Mars", Sun, 0, 0, 4 )
        :setColor( 230, 126, 34 )

    local Jupiter = Planet( "Jupiter", Sun, 0, 0, 32 )
        :setColor( 241, 196, 15 )

    local Saturn = Planet( "Saturn", Sun, 0, 0, 30 )
        :setColor( 235, 211, 134 )

    local Uranus = Planet( "Uranus", Sun, 0, 0, 16 )
        :setColor( 52, 152, 219 )

    local Neptune = Planet( "Neptune", Sun, 0, 0, 16 )
        :setColor( 41, 128, 185 )

    love.graphics.setBackgroundColor( 10 / 255, 10 / 255, 10 / 255 )
end

function love.update( dt )
    planets_update( dt )
end

function love.draw()
    love.graphics.setColor( 1, 1, 1, 1 )
    love.graphics.print( "zoom >>> " .. zoom, 5, 5 )
    love.graphics.print( "cam (x;y) >>> " .. cam_x .. ";" .. cam_y, 5, 20 )

    love.graphics.scale( zoom )
    love.graphics.translate( cam_x, cam_y )

    planets_draw()
end

function love.keypressed( k )
    if k == "a" then
        show_planet_circle = not show_planet_circle
    elseif k == "t" then
        show_planet_text = not show_planet_text
    end
end

function love.wheelmoved( x, y )
    zoom = clamp( zoom + y / 6, .2, 1.5 )
    --cam_x = cam_x + love.mouse.getX() * zoom
    --cam_y = cam_y + love.mouse.getY() * zoom
end

function love.mousemoved( x, y, dx, dy )
    if not love.mouse.isDown( 1 ) then return end

    cam_x = cam_x + dx * 1 / zoom
    cam_y = cam_y + dy * 1 / zoom
end

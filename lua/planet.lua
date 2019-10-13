Planet = {}
local planets = {}

local mt = {}
mt.__index = Planet

local DEFAULT_SPEED = 5

function Planet:new( name, parent, x, y, radius )
    local p = {}

    p.parent = parent
    p.parentId = parent and #parent.childs + 1 or -1
    p.name = name or "???"
    p.radius = radius or 64
    p.x = parent and parent.x + parent.radius + p.radius * 2 or x or 0
    p.y = parent and parent.y + parent.radius + p.radius * 2 or y or 0
    p.ang = 0
    p.color = { 1, 1, 1, 1 }
    p.childs = {}
    setmetatable( p, mt )

    print( ( "PLANET: Added %s at %d:%d with radius %d and %s" ):format( p.name, p.x, p.y, p.radius, ( parent and parent.name .. " as parent! (" .. p.parentId .. ")" or "no parent." ) ) )

    planets[#planets + 1] = p
    if p.parent then p.parent.childs[p.parentId] = p end
    return p
end

setmetatable( Planet, 
    {
        __call = function( self, ... )
            return self:new( ... )
        end
    } )

function Planet:update( dt )
    self.ang = self.ang + 1 / self.radius * dt * DEFAULT_SPEED
    if self.parent then
        local offset = self:getParentOffset()
        self.x = self.parent.x + math.cos( self.ang ) * offset
        self.y = self.parent.y + math.sin( self.ang ) * offset
    end
end

function Planet:draw()
    love.graphics.setColor( unpack( self.color ) )
    love.graphics.circle( "fill", self.x, self.y, self.radius, 50 )

    --  > Orbital circle
    if self.parent then
        if show_planet_circle then
            love.graphics.circle( "line", self.parent.x, self.parent.y, self:getParentOffset(), 100 )
        end
    else -- draw glow for stars
        self:drawGlow( math.abs( math.sin( love.timer.getTime() ) * 20 ) )
    end

    if show_planet_text then 
        love.graphics.setColor( 1, 1, 1, 1 )
        love.graphics.print( self.name, self.x + self.radius, self.y + self.radius )
    end
end

--  >

function Planet:drawGlow( nCircles )
    for i = 0, nCircles do
        love.graphics.setColor( self.color[1], self.color[2], self.color[3], i / 255 )
        love.graphics.circle( "line", self.x, self.y, self.radius + i, 100 )
    end
end

function Planet:getParentDistance()
    -- > /!\ square root is an expensive process, don't use it every frame (update and draw)
    return math.sqrt( ( self.parent.x - self.x ) ^ 2 + ( self.parent.y - self.y ) ^ 2 ) 
end

function Planet:getParentOffset()
    return ( self.parent.radius * self.parentId ) * 2
end

function Planet:setColor( r, g, b )
    self.color[1] = r / 255
    self.color[2] = g / 255
    self.color[3] = b / 255
    return self
end

--  >

function planets_update( dt )
    for i, v in ipairs( planets ) do
        v:update( dt )
    end
end

function planets_draw()
    for i, v in ipairs( planets ) do
        v:draw()
    end
end

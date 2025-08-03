

-- watch lua Mods/Hot-Potato/Perkeocoin/plinko_game.lua


-- plinko.lua is huge so this is the new thing game logic related only I guess

-- Transform pixels into game units:
local function to_game_units(val)
    return val / (G.TILESCALE*G.TILESIZE)
end

local function to_pixels(val)
    return val * (G.TILESCALE*G.TILESIZE)
end

-- PLAN FOR TOMORROW:
-- Ignore game units.
-- Ignore any UI
-- Logic to place obstacle (+draw)
-- Setup basic map
-- Spawn ball on command
-- AFTER all of this works, adjust the map to the UI
-- After that, add logic to automatically adjust scale on screen scale change

--[[
Use this to draw sprites 
love.graphics.draw( texture, quad, x, y, r, sx, sy, ox, oy, kx, ky )

Arguments

Texture texture
    A Texture (Image or Canvas) to texture the Quad with.
Quad quad
    The Quad to draw on screen.
number x
    The position to draw the object (x-axis).
number y
    The position to draw the object (y-axis).
number r (0)
    Orientation (radians).
number sx (1)
    Scale factor (x-axis).
number sy (sx)
    Scale factor (y-axis).
number ox (0)
    Origin offset (x-axis).
number oy (0)
    Origin offset (y-axis).
number kx (0)
    Shearing factor (x-axis).
number ky (0)
    Shearing factor (y-axis).

]]


-- TODO UPDATE PHYSICS SHIT WHEN PLAYER CHANGES WINDOW SIZE

if Plinko then
    -- Cleanup old stuff on reload
    if Plinko.world ~= "undefined" then
        Plinko.world:destroy()
        Plinko.world = "undefined"
    end
end

Plinko = {
    world = "undefined",
    -- settings
    s = {
        meter = 100,
        acceleration_x = 0,
        acceleration_y = 9.81,
        world_width = 500,  -- x
        world_height = 500, -- y
        ball_radius = 5,
    },
    -- objects
    o = {

    },

    draw = function ()
      if Plinko.world == 'undefined' then
        return
      end
      -- TODO : draw normal textures
      debug_objects()
    end
}

function update_plinko_world(dt)
    if Plinko.world == 'undefined' then
        return
    end
    Plinko.world:update(dt)
end

-- I dont think thins needs to be a moveable tbf
--[[
--class
PlinkoObstacle = Moveable:extend()

--class methods
function PlinkoObstacle:init(X, Y, W, H, card, center, params)
    self.params = (type(params) == 'table') and params or {}

    Moveable.init(self,X, Y, W, H)

    self.CT = self.VT
    self.config = {
        card = card or {},
        center = center
        }

    self.states.collide.can = false
    self.states.hover.can = false
    self.states.drag.can = false
    self.states.click.can = false

    if getmetatable(self) == PlinkoObstacle then
        --table.insert(G.I.CARD, self)
    end
end]]

local world_offset = {x = 0, y = 0}


local function circle(obj)
    local r,g,b,a = love.graphics.getColor()
    
    love.graphics.setColor(255/255, 100/255, 100/255, 255/255)
    love.graphics.circle("line", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
    love.graphics.setColor(r,g,b,a)
end 

local function circle_fill(obj)
    local r,g,b,a = love.graphics.getColor()
    
    love.graphics.setColor(100/255, 100/255, 255/255, 255/255)
    love.graphics.circle("fill", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
    love.graphics.setColor(r,g,b,a)
end

local function polygon(obj)
    local r,g,b,a = love.graphics.getColor()

    love.graphics.setColor(100/255, 255/255, 100/255, 255/255)
    love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
    love.graphics.setColor(r,g,b,a)
end

local debugging = true
 
-- Draw object boundaries ()
function debug_objects(toggle)
    if toggle then
        debugging = not debugging
        print(("You are %s debugging objects"):format(debugging and "now" or "no longer"))
        return
    end

    if not debugging then
        return
    end

    for _, v in pairs(Plinko.o) do
        v:debug_draw()
    end
end

local function fix(obj)
    -- Connect body (placement) with shape
    obj.fixture = love.physics.newFixture(obj.body, obj.shape, obj.density)
    obj.density = nil
    return obj
end

local function create_obstacle(offset)
    local o = {
        body = love.physics.newBody(
            Plinko.world,
            world_offset.x + offset.x,
            world_offset.y + offset.y
        ),
        shape = love.physics.newCircleShape(Plinko.s.ball_radius),
        debug_draw = circle,
        draw = function (self)
            -- TODO draw texture
        end
    }
    
    o.fixture = love.physics.newFixture(o.body, o.shape)

    return o
end

function create_world()
    
    love.physics.setMeter(Plinko.s.meter)

    Plinko.world = love.physics.newWorld(
        Plinko.s.acceleration_x * Plinko.s.meter,
        Plinko.s.acceleration_y * Plinko.s.meter,
        true -- Whether the bodies in this world are allowed to sleep (eepy)
    )

    --#region Create box around the visible world
    local h_rect = {
        width = Plinko.s.world_width,
        height = 2,
    }

    local v_rect = {
        width = 2,
        height = Plinko.s.world_height,
    }

    Plinko.o.box_bottom = fix {
        body = love.physics.newBody(
            Plinko.world,
            Plinko.s.world_width / 2, -- in the middle
            Plinko.s.world_height - h_rect.height / 2 -- at the bottom
        ),
        shape = love.physics.newRectangleShape(h_rect.width, h_rect.height),
        debug_draw = polygon
    }
    Plinko.o.box_top = fix {
        body = love.physics.newBody(
            Plinko.world,
            Plinko.s.world_width / 2, -- in the middle
            h_rect.height / 2 -- at the top
        ),
        shape = love.physics.newRectangleShape(h_rect.width, h_rect.height),
        debug_draw = polygon
    }

    Plinko.o.box_left = fix {
        body = love.physics.newBody(
            Plinko.world,
            v_rect.width / 2, -- to the left
            Plinko.s.world_height / 2 -- in the middle
        ),
        shape = love.physics.newRectangleShape(v_rect.width, v_rect.height),
        debug_draw = polygon
    }

    Plinko.o.box_right = fix {
        body = love.physics.newBody(
            Plinko.world,
            Plinko.s.world_width - v_rect.width / 2, -- to the right
            Plinko.s.world_height / 2 -- in the middle
        ),
        shape = love.physics.newRectangleShape(v_rect.width, v_rect.height),
        debug_draw = polygon
    }
    --#endregion


    --#region Create obstacles for the ball

    local obstacle_id = 1
    for x = 1, 9 do
        for y = 1, 5 do
            
            local pos = {
                x = (y%2 == 1 and 25 or 0) - 20 + x * 50, -- offset every other row a bit
                y = 100 + y * 50, -- generic offset from top, then every 90 px
            }

            Plinko.o["obstacle_"..tostring(obstacle_id)] = create_obstacle(pos)
            obstacle_id = obstacle_id + 1
        end
    end

    --#endregion



    --#region Create dummy ball at random loc
    local ball = {
        radius = 10,
    -- density in kg / m^2, 
    -- which definies weight of this object.
        density = 1,
    -- How much velocity is saved after collision?
    -- range: [0.0, 1.0]
        bounciness = 0.95
    }

    Plinko.o.ball = fix {
        body = love.physics.newBody(
            Plinko.world,
            50 + math.random() * (Plinko.s.world_width - 100),
            10,
            "dynamic"
        ),
        shape = love.physics.newCircleShape(ball.radius),
        density = ball.density,
        debug_draw = circle_fill
    }

    Plinko.o.ball.fixture:setRestitution(ball.bounciness)

    --#endregion
end





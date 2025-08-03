

-- watch lua Mods/Hot-Potato/Perkeocoin/plinko_game.lua


-- plinko.lua is huge so this is the new thing game logic related only I guess

-- Transform pixels into game units:
local function to_game_units(val)
    return val / (G.TILESCALE*G.TILESIZE)
end

local function to_pixels(val)
    return val * (G.TILESCALE*G.TILESIZE)
end

-- all of this works, adjust the map to the UI
-- After that, add logic to automatically adjust scale on screen scale change
--

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

local world_offset = {x = 845, y = 390}

Plinko = {
    world = "undefined",
    -- settings
    s = {
        meter = 150,
        acceleration_x = 0,
        acceleration_y = 9.81,
        world_width = 660,  -- x
        world_height = 475, -- y

        peg_radius = 3.5,
        pegs_x = 12,
        pegs_y = 7,
        peg_offset = 53,

        ball_radius = 13,
        -- density in kg / m^2, 
        -- which definies weight of this object.
        ball_density = 1,
        -- How much velocity is saved after collision?
        -- range: [0.0, 1.0]
        ball_bounce = 0.85,
    },
    -- objects
    o = { },
    -- functions
    f = { },
}

function Plinko.f.draw()
  if Plinko.world == 'undefined' then
    return
  end
  -- TODO : draw normal textures
  Plinko.f.debug_objects()
end

function Plinko.f.tick_objects()

    for k, v in pairs(Plinko.o) do
        if v.destroyed then
            Plinko.o[k] = nil
        end
    end

end

function Plinko.f.update_plinko_world(dt)
    if Plinko.world == 'undefined' then
        Plinko.f.create_world()
        Plinko.f.init_dummy_ball()
        return
    end


    Plinko.f.tick_objects()
    Plinko.f.ballin(dt)

    Plinko.world:update(dt)
end

--#region Dynamic ball offset

local plinko_balling = 1
local where_is_plinko_balling = 1
local how_much_balling_per_second = 200
local ball_idle_offset = 175/2
local plinko_should_be_balling_in_a_different_direction = (Plinko.s.world_width - ball_idle_offset * 2)
local function get_dummy_ball_x()
    return world_offset.x + (ball_idle_offset + plinko_balling)
end

function Plinko.f.ballin(dt)
    plinko_balling = plinko_balling + where_is_plinko_balling * how_much_balling_per_second * G.real_dt
    if plinko_balling >= plinko_should_be_balling_in_a_different_direction or plinko_balling <= 1 then
        where_is_plinko_balling = -where_is_plinko_balling
    end

    if Plinko.o.dummy_ball then
        Plinko.o.dummy_ball.body:setX(get_dummy_ball_x())
    end
end

--#endregion

local destroy_obj = function (self)
        self.fixture:destroy()
        self.destroyed = true
end

local function fix(obj)
    -- Connect body (placement) with shape
    obj.fixture = love.physics.newFixture(obj.body, obj.shape, obj.density)
    obj.shape = obj.fixture:getShape()
    obj.density = nil
    obj.destroy = destroy_obj
    return obj
end

-- Create obstacle pegs 
function Plinko.f.create_obstacle(offset)
    return fix {
        body = love.physics.newBody(
            Plinko.world,
            world_offset.x + offset.x,
            world_offset.y + offset.y
        ),
        shape = love.physics.newCircleShape(Plinko.s.peg_radius),
        debug_draw = Plinko.f.circle,
        draw = function (self)
            -- TODO draw texture
        end
    }
end

function Plinko.f.init_dummy_ball()
    if Plinko.o.dummy_ball then
        Plinko.o.dummy_ball:destroy()
    end

    if Plinko.o.ball then
        Plinko.o.ball:destroy()
    end

    Plinko.o.dummy_ball = fix {
        body = love.physics.newBody(
            Plinko.world,
            get_dummy_ball_x(),
            world_offset.y + 20
        ),
        shape = love.physics.newCircleShape(Plinko.s.ball_radius),
        debug_draw = Plinko.f.circle_fill,
    }

end

-- Create ball
function Plinko.f.drop_ball(x)
    x = x and (world_offset.x + x) or get_dummy_ball_x()

    if Plinko.o.dummy_ball then
        Plinko.o.dummy_ball:destroy()
    end

    if Plinko.o.ball then
        Plinko.o.ball:destroy()
    end

    Plinko.o.ball = fix {
        body = love.physics.newBody(
            Plinko.world,
            x,
            world_offset.y + 20,
            "dynamic"
        ),
        shape = love.physics.newCircleShape(Plinko.s.ball_radius),
        density = Plinko.s.ball_density,
        debug_draw = Plinko.f.circle_fill
    }

    Plinko.o.ball.fixture:setRestitution(Plinko.s.ball_bounce)
end

function Plinko.f.create_world_box()
    local h_rect = {
        width = Plinko.s.world_width,
        height = 1,
    }

    local v_rect = {
        width = 1,
        height = Plinko.s.world_height,
    }

    Plinko.o.box_bottom = fix {
        body = love.physics.newBody(
            Plinko.world,
            world_offset.x + Plinko.s.world_width / 2, -- in the middle
            world_offset.y + Plinko.s.world_height - h_rect.height / 2 -- at the bottom
        ),
        shape = love.physics.newRectangleShape(h_rect.width, h_rect.height),
        debug_draw = Plinko.f.polygon
    }
    Plinko.o.box_top = fix {
        body = love.physics.newBody(
            Plinko.world,
            world_offset.x + Plinko.s.world_width / 2, -- in the middle
            world_offset.y + h_rect.height / 2 -- at the top
        ),
        shape = love.physics.newRectangleShape(h_rect.width, h_rect.height),
        debug_draw = Plinko.f.polygon
    }

    Plinko.o.box_left = fix {
        body = love.physics.newBody(
            Plinko.world,
            world_offset.x + v_rect.width / 2, -- to the left
            world_offset.y + Plinko.s.world_height / 2 -- in the middle
        ),
        shape = love.physics.newRectangleShape(v_rect.width, v_rect.height),
        debug_draw = Plinko.f.polygon
    }

    Plinko.o.box_right = fix {
        body = love.physics.newBody(
            Plinko.world,
            world_offset.x + Plinko.s.world_width - v_rect.width / 2, -- to the right
            world_offset.y + Plinko.s.world_height / 2 -- in the middle
        ),
        shape = love.physics.newRectangleShape(v_rect.width, v_rect.height),
        debug_draw = Plinko.f.polygon
    }
end

function is_above(body_a, body_b)
    return body_a:isActive() and body_a:getY() > body_b:getY()
end

-- Check if moveable ball is above the statis one
function should_boost(a, b)
    if a:type() == b:type() and a:type() == "Fixture" and a:getShape():type() == b:getShape():type() and a:getShape():type() == "CircleShape" then
        return
            (is_above(a:getBody(), b:getBody())) or
            (is_above(b:getBody(), a:getBody()))
    end
end

function Plinko.f.create_world()
    if Plinko.world ~= "undefined" then
        return
    end

    love.physics.setMeter(Plinko.s.meter)

    Plinko.world = love.physics.newWorld(
        Plinko.s.acceleration_x * Plinko.s.meter,
        Plinko.s.acceleration_y * Plinko.s.meter,
        true -- Whether the bodies in this world are allowed to sleep (eepy)
    )

    Plinko.world:setCallbacks(
        -- Begin contact callback
        function (a, b, coll)
            -- Small chance to boost if balls are colliding 
            if math.random() < 0.5 then
                local boost = should_boost(a, b)
                if boost then
                    
                    -- extra bounce
                    coll:setRestitution(1.1)
                elseif type(boost) == "boolean" then
                    -- lower bounce, boolean check because hitting a wall would return nil
                    coll:setRestitution(0.5)
                end
            end
        end,
        nil,
        nil,
        nil
    )

    Plinko.f.create_world_box()

    --#region Create obstacles for the ball

    local obstacle_id = 1
    for y = 1, Plinko.s.pegs_y do
        for x = 1, y%2 == 1 and Plinko.s.pegs_x - 1 or Plinko.s.pegs_x do
            
            local pos = {
                x = (y%2 == 1 and Plinko.s.peg_offset/2 or 0) - 15 + x * Plinko.s.peg_offset, -- offset every other row a bit
                y = 40 + y * Plinko.s.peg_offset, -- generic offset from top, then every 90 px
            }

            Plinko.o["obstacle_"..tostring(obstacle_id)] = Plinko.f.create_obstacle(pos)
            obstacle_id = obstacle_id + 1
        end
    end

    --#endregion
end


--#region Debug Objects (draw hitboxes outlines)

function Plinko.f.circle(obj)
    local r,g,b,a = love.graphics.getColor()
    
    love.graphics.setColor(255/255, 100/255, 100/255, 255/255)
    love.graphics.circle("line", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
    love.graphics.setColor(r,g,b,a)
end 

function Plinko.f.circle_fill(obj)
    local r,g,b,a = love.graphics.getColor()
    
    love.graphics.setColor(100/255, 100/255, 255/255, 255/255)
    love.graphics.circle("fill", obj.body:getX(), obj.body:getY(), obj.shape:getRadius())
    love.graphics.setColor(r,g,b,a)
end

function Plinko.f.polygon(obj)
    local r,g,b,a = love.graphics.getColor()

    love.graphics.setColor(100/255, 255/255, 100/255, 255/255)
    love.graphics.polygon("fill", obj.body:getWorldPoints(obj.shape:getPoints()))
    love.graphics.setColor(r,g,b,a)
end

local debugging = true
 
-- Draw hitboxes
function Plinko.f.debug_objects(toggle)
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

--#endregion




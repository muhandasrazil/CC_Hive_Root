function calibrate()
    -- GEOPOSITION BY MOVING TO ADJACENT BLOCK AND BACK
    local sx, sy, sz = gps.locate()
--    if sx == config.interface.x and sy == config.interface.y and sz == config.interface.z then
--        refuel()
--    end
    if not sx or not sy or not sz then
        return false
    end
    for i = 1, 4 do
        -- TRY TO FIND EMPTY ADJACENT BLOCK
        if not turtle.detect() then
            break
        end
        if not turtle.turnRight() then return false end
    end
    if turtle.detect() then
        -- TRY TO DIG ADJACENT BLOCK
        for i = 1, 4 do
            safedig('forward')
            if not turtle.detect() then
                break
            end
            if not turtle.turnRight() then return false end
        end
        if turtle.detect() then
            return false
        end
    end
    if not turtle.forward() then return false end
    local nx, ny, nz = gps.locate()
    if nx == sx + 1 then
        orientation = 'east'
    elseif nx == sx - 1 then
        orientation = 'west'
    elseif nz == sz + 1 then
        orientation = 'south'
    elseif nz == sz - 1 then
        orientation = 'north'
    else
        return false
    end
    location = {x = nx, y = ny, z = nz}
    --print('Calibrated to ' .. str_xyz(location, orientation))
    
    turtle.back()
    
    --if basics.in_area(location, config.locations.home_area) then
      --  face(left_shift[left_shift[config.locations.homes.increment]])
    --end
    
    return true
end

calibrate()


move = {
    forward = turtle.forward,
    up      = turtle.up,
    down    = turtle.down,
    back    = turtle.back,
    left    = turtle.turnLeft,
    right   = turtle.turnRight
}

bumps = {
    north = { 0,  0, -1},
    south = { 0,  0,  1},
    east  = { 1,  0,  0},
    west  = {-1,  0,  0},
}


left_shift = {
    north = 'west',
    south = 'east',
    east  = 'north',
    west  = 'south',
}


right_shift = {
    north = 'east',
    south = 'west',
    east  = 'south',
    west  = 'north',
}


reverse_shift = {
    north = 'south',
    south = 'north',
    east  = 'west',
    west  = 'east',
}

detect = {
    forward = turtle.detect,
    up      = turtle.detectUp,
    down    = turtle.detectDown
}


r_shft_dr = reverse_shift[arg[1]]

l_shft_dr = left_shift[self_dr]

bak_shft_dr = right_shift[self_dr]

print(arg[1])

print(network.pc[1].x)
print(network.pc[1].y)
print(network.pc[1].z)

for n, i in pairs(network.pc[1]) do
    print(i)
end


pc_pos_check = {x = network.pc[1].x, y = 64, z = network.pc[1].z}



function face(orientation1)
    if orientation == orientation1 then
        return true
    elseif right_shift[orientation] == orientation1 then
        if not go('right') then return false end
    elseif left_shift[orientation] == orientation1 then
        if not go('left') then return false end
    elseif right_shift[right_shift[orientation]] == orientation1 then
        if not go('right') then return false end
        if not go('right') then return false end
    else
        return false
    end
    return true
end

function log_movement(direction)
    if direction == 'up' then
        location.y = location.y +1
    elseif direction == 'down' then
        location.y = location.y -1
    elseif direction == 'forward' then
        bump = bumps[orientation]
        location = {x = location.x + bump[1], y = location.y + bump[2], z = location.z + bump[3]}
    elseif direction == 'back' then
        bump = bumps[orientation]
        location = {x = location.x - bump[1], y = location.y - bump[2], z = location.z - bump[3]}
    elseif direction == 'left' then
        orientation = left_shift[orientation]
    elseif direction == 'right' then
        orientation = right_shift[orientation]
    end
    return true
end

function go(direction, nodig)
    if not nodig then
        if detect[direction] then
            if detect[direction]() then
                safedig(direction)
            end
        end
    end
    if not move[direction] then
        return false
    end
    if not move[direction]() then
        if attack[direction] then
            attack[direction]()
        end
        return false
    end
    log_movement(direction)
    return true
end

function go_to_axis(axis, coordinate, nodig)
    local delta = coordinate - location[axis]
    if delta == 0 then
        return true
    end
    
    if axis == 'x' then
        if delta > 0 then
            if not face('east') then return false end
        else
            if not face('west') then return false end
        end
    elseif axis == 'z' then
        if delta > 0 then
            if not face('south') then return false end
        else
            if not face('north') then return false end
        end
    end
    
    for i = 1, math.abs(delta) do
        if axis == 'y' then
            if delta > 0 then
                if not go('up', nodig) then return false end
            else
                if not go('down', nodig) then return false end
            end
        else
            if not go('forward', nodig) then return false end
        end
    end
    return true
end

function go_to(end_location, end_orientation, path, nodig)
    if path then
        for axis in path:gmatch'.' do
            if not go_to_axis(axis, end_location[axis], nodig) then return false end
        end
    elseif end_location.path then
        for axis in end_location.path:gmatch'.' do
            if not go_to_axis(axis, end_location[axis], nodig) then return false end
        end
    else
        return false
    end
    if end_orientation then
        if not face(end_orientation) then return false end
    elseif end_location.orientation then
        if not face(end_location.orientation) then return false end
    end
    return true
end

go_to(pc_pos_check, arg[1], 'yzx', true)
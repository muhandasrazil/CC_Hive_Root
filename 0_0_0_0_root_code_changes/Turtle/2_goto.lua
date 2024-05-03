term.clear()
term.setCursorPos(1,1)
self_id = os.getComputerID()
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
function face(orientation)
    if actions.pcTable[self_id].orientation == orientation then
        return true
    elseif right_shift[actions.pcTable[self_id].orientation] == orientation then
        if not go('right') then return false end
    elseif left_shift[actions.pcTable[self_id].orientation] == orientation then
        if not go('left') then return false end
    elseif right_shift[right_shift[actions.pcTable[self_id].orientation]] == orientation then
        if not go('right') then return false end
        if not go('right') then return false end
    else
        return false
    end
    return true
end
function log_movement(direction)
    if direction == 'up' then
        actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y +1
    elseif direction == 'down' then
        actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y -1
    elseif direction == 'forward' then
        bump = bumps[actions.pcTable[self_id].orientation]
        actions.pcTable[self_id].location = {x = actions.pcTable[self_id].location.x + bump[1], y = actions.pcTable[self_id].location.y + bump[2], z = actions.pcTable[self_id].location.z + bump[3]}
    elseif direction == 'back' then
        bump = bumps[actions.pcTable[self_id].orientation]
        actions.pcTable[self_id].location = {x = actions.pcTable[self_id].location.x - bump[1], y = actions.pcTable[self_id].location.y - bump[2], z = actions.pcTable[self_id].location.z - bump[3]}
    elseif direction == 'left' then
        actions.pcTable[self_id].orientation = left_shift[actions.pcTable[self_id].orientation]
    elseif direction == 'right' then
        actions.pcTable[self_id].orientation = right_shift[actions.pcTable[self_id].orientation]
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
    local delta = coordinate - actions.pcTable[self_id].location[axis]
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
for id, pc in pairs(actions.pcTable) do
    pc_reference_id = id
    continue = true
    if pc.pc_cmp then
        if pc.orientation then
            print("Orientation for PC ID " .. id .. " is already set to " .. pc.orientation)
            continue = false
        end
        if continue then
            local target_orientation = 'north'  -- Set orientation to 'north' by default for all PCs
            local target_location = {
                x = pc.location.x,
                y = pc.location.y+1,
                z = pc.location.z
            }
            --local bump = bumps[target_orientation]
            --target_location = {x = target_location.x + bump[1], y = target_location.y + bump[2], z = target_location.z + bump[3]}
            local high_height = actions.pcTable[self_id].location.y + 3
            while high_height >= actions.pcTable[self_id].location.y do
                turtle.up()
                actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y + 1
                if actions.pcTable[self_id].location.y > 70 then
                    break
                end
            end
            local high_height_2 = target_location.y + 3
            while high_height_2 >= actions.pcTable[self_id].location.y do
                turtle.up()
                actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y + 1
                if actions.pcTable[self_id].location.y > 70 then
                    break
                end
            end
            if go_to_axis('x', target_location.x, true) and go_to_axis('z', target_location.z, true) then
                while target_location.y >= actions.pcTable[self_id].location.y do
                    turtle.up()
                    actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y + 1
                end
                while target_location.y < actions.pcTable[self_id].location.y do
                    turtle.down()
                    actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y - 1
                end
            end
            print(id.." Tx "..target_location.x.." Ty "..target_location.y.." Tz "..target_location.z)
            if go_to(target_location, target_orientation, 'yxz', true) then
                ax, ay, az = gps.locate()
                actions.pcTable[id].location = {x = ax, y = ay, z = az}
                current_pos = {x = ax, y = ay, z = az}
                print("ID "..id.." x= " .. actions.pcTable[id].location.x.." y= "..actions.pcTable[id].location.y.." z= "..actions.pcTable[id].location.z)
                actions.updateStateValue("location", current_pos)
                actions.updateStateValue("orientation", target_orientation)
                actions.updateAndBroadcast()
                sleep(1)
                actions.a_all_cmd('o', pc_reference_id, my_id)
                sleep(3)
            end
        end
    end
end


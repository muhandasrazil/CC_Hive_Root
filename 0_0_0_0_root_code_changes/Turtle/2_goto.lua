tArgs = { ... }
keep_going = true
pc_destination = tArgs[1]
pc_destination = tonumber(pc_destination)
target_location = actions.pcTable[pc_destination].location
target_orientation = nil
nswe_check = tArgs[2]
if nswe_check == 'n' then
    target_orientation = 'north'
elseif nswe_check == 's' then
    target_orientation = 'south'
elseif nswe_check == 'w' then
    target_orientation = 'west'
elseif nswe_check == 'e' then
    target_orientation = 'east'
else
    target_orientation = nil
end
print("Target... "..pc_destination)
print(target_location.x..","..target_location.y..","..target_location.z)
print(target_orientation)
self_id = os.getComputerID()
state = {
    orientation = actions.pcTable[self_id].orientation,
    location = actions.pcTable[self_id].location
}
print("Current... "..self_id)
print(actions.pcTable[self_id].orientation)
print(actions.pcTable[self_id].location.x..","..actions.pcTable[self_id].location.y..","..actions.pcTable[self_id].location.z)
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
bump = bumps[target_orientation]
target_location = {x = target_location.x + bump[1], y = target_location.y + bump[2], z = target_location.z + bump[3]}
high_height = 70
if keep_going then
while high_height >= actions.pcTable[self_id].location.y do
    turtle.up()
    actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y+1
end
while target_location.y+3 >= actions.pcTable[self_id].location.y do
    turtle.up()
    actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y+1
end
end
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
go_to(target_location,target_orientation,'zxy',true)
print("done")
ax,ay,az = gps.locate()
actions.pcTable[self_id].location = {x = ax, y = ay, z = az}
current_pos = {x = ax, y = ay, z = az}
print("x= "..actions.pcTable[self_id].location.x)
print("y= "..actions.pcTable[self_id].location.y)
print("z= "..actions.pcTable[self_id].location.z)
print(actions.pcTable[self_id].orientation)
actions.updateStateValue("location",current_pos)
actions.updateStateValue("orientation",actions.pcTable[self_id].orientation)
actions.updateAndBroadcast()
sleep(1)
actions.a_all_cmd('o',tArgs[1],my_id)
term.clear()
term.setCursorPos(1,1)
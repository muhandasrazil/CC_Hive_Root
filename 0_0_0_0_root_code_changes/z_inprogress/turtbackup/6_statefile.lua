
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


move = {
    forward = turtle.forward,
    up      = turtle.up,
    down    = turtle.down,
    back    = turtle.back,
    left    = turtle.turnLeft,
    right   = turtle.turnRight
}


detect = {
    forward = turtle.detect,
    up      = turtle.detectUp,
    down    = turtle.detectDown
}


inspect = {
    forward = turtle.inspect,
    up      = turtle.inspectUp,
    down    = turtle.inspectDown
}


dig = {
    forward = turtle.dig,
    up      = turtle.digUp,
    down    = turtle.digDown
}

attack = {
    forward = turtle.attack,
    up      = turtle.attackUp,
    down    = turtle.attackDown
}

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
    --log_movement(direction)
    return true
end


function face(orientation)
    if state.orientation == orientation then
        return true
    elseif right_shift[state.orientation] == orientation then
        if not go('right') then return false end
    elseif left_shift[state.orientation] == orientation then
        if not go('left') then return false end
    elseif right_shift[right_shift[state.orientation]] == orientation then
        if not go('right') then return false end
        if not go('right') then return false end
    else
        return false
    end
    return true
end


tArgs = { ... }

face(tArgs[1])

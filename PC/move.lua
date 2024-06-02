function nav_priority(trtl_loc,pc_loc)
    dist_x = math.abs(trtl_loc.x - pc_loc.x)
    dist_y = trtl_loc.y - pc_loc.y
    dist_z = math.abs(trtl_loc.z - pc_loc.z)
    if dist_z >= dist_x then
        xzzx = 'zx'
    elseif dist_z < dist_x then
        xzzx = 'xz'
    end
    if dist_y > 0 then
        y_xzzx = xzzx..'y'
    elseif dist_y <= 0 then
        y_xzzx = 'y'..xzzx
    end
    return y_xzzx
end
function move_log(direction)
    status.move[direction]()
    move.log_movement(direction)
end
function face(orientation)
    if status.pcTable[status.who_am_i.my_id].orientation == orientation then
        return true
    elseif status.right_shift[status.pcTable[status.who_am_i.my_id].orientation] == orientation then
        move_log('right')
    elseif status.left_shift[status.pcTable[status.who_am_i.my_id].orientation] == orientation then
        move_log('left')
    elseif status.reverse_shift[status.pcTable[status.who_am_i.my_id].orientation] == orientation then
        move_log('left')
        move_log('left')
    else
        return false
    end
    return true
end
function log_movement(direction)
    if direction == 'up' then
        status.pcTable[status.who_am_i.my_id].location.y = status.pcTable[status.who_am_i.my_id].location.y +1
    elseif direction == 'down' then
        status.pcTable[status.who_am_i.my_id].location.y = status.pcTable[status.who_am_i.my_id].location.y -1
    elseif direction == 'forward' then
        bump = status.bumps[status.pcTable[status.who_am_i.my_id].orientation]
        status.pcTable[status.who_am_i.my_id].location = {x = status.pcTable[status.who_am_i.my_id].location.x + bump[1], y = status.pcTable[status.who_am_i.my_id].location.y + bump[2], z = status.pcTable[status.who_am_i.my_id].location.z + bump[3]}
    elseif direction == 'back' then
        bump = status.bumps[status.pcTable[status.who_am_i.my_id].orientation]
        status.pcTable[status.who_am_i.my_id].location = {x = status.pcTable[status.who_am_i.my_id].location.x - bump[1], y = status.pcTable[status.who_am_i.my_id].location.y - bump[2], z = status.pcTable[status.who_am_i.my_id].location.z - bump[3]}
    elseif direction == 'left' then
        status.pcTable[status.who_am_i.my_id].orientation = status.left_shift[status.pcTable[status.who_am_i.my_id].orientation]
    elseif direction == 'right' then
        status.pcTable[status.who_am_i.my_id].orientation = status.right_shift[status.pcTable[status.who_am_i.my_id].orientation]
    end
    status.going.distx = status.going.endloc.x-status.pcTable[status.who_am_i.my_id].location.x
    status.going.disty = status.going.endloc.y-status.pcTable[status.who_am_i.my_id].location.y
    status.going.distz = status.going.endloc.z-status.pcTable[status.who_am_i.my_id].location.z
    term.clear()
    term.setCursorPos(1,1)
    print("dist "..status.going.distx.." , "..status.going.disty.." , "..status.going.distz)
    return true
end
function go_to(end_location, end_orientation, path)
    status.going.distx = end_location.x-status.pcTable[status.who_am_i.my_id].location.x
    status.going.disty = end_location.y-status.pcTable[status.who_am_i.my_id].location.y
    status.going.distz = end_location.z-status.pcTable[status.who_am_i.my_id].location.z
    status.going.endloc = end_location
    print("dist "..status.going.distx.." , "..status.going.disty.." , "..status.going.distz)
    local function reached_destination()
        for axis in path:gmatch('.') do
            if status.pcTable[status.who_am_i.my_id].location[axis] ~= end_location[axis] then
                return false
            end
        end
        return true
    end
    local function try_path()
        for axis in path:gmatch('.') do
            if not go_to_axis(axis) then return false end
        end
        return true
    end
    while not reached_destination() do
        if not try_path() then return false end
    end
    if end_orientation then
        if not face(end_orientation) then return false end
    elseif end_location.orientation then
        if not face(end_location.orientation) then return false end
    end
    return true
end
function go_to_axis(axis)
    local distKey = 'dist' .. axis
    if status.going[distKey] == 0 then
        return true
    end
    if axis == 'x' then
        if status.going[distKey] > 0 then
            if not face('east') then return false end
        else
            if not face('west') then return false end
        end
    elseif axis == 'z' then
        if status.going[distKey] > 0 then
            if not face('south') then return false end
        else
            if not face('north') then return false end
        end
    end
    while status.going[distKey] ~= 0 do
        if axis == 'y' then
            if status.going[distKey] > 0 then
                if not go('up') then return false end
            else
                if not go('down') then return false end
            end
        else
            if not go('forward') then return false end
        end
    end
    return true
end
function go(direction)
    if (direction == 'forward' and status.detect[direction]()) then
        if move.moving_forward_check(end_location) then return true else return false end
    elseif (direction == 'up' and status.detect[direction]()) then
        return move.moving_up_check()
    elseif (direction == 'down' and status.detect[direction]()) then
        return false
    end
    move.move_log(direction)
    return true
end
function moving_forward_check()
    local max_attempts = 256
    local cur_height = status.pcTable[status.who_am_i.my_id].location.y
    local counters = {up = 0, down = 0, left = 0, right = 0}
    local function try_direction(check_function, direction)
        for i = cur_height, max_attempts do
            local check_result = check_function()
            if check_result == true then
                return true
            elseif check_result == false then
                counters[direction] = counters[direction] + 1
            elseif check_result == nil then
                break
            end
        end
        return false
    end
    local function try_up_again(now_height)
        while status.pcTable[status.who_am_i.my_id].location.y < og_height do
            if not status.detect['up']() then
                move.move_log('up')
                if not status.detect['up']() and status.pcTable[status.who_am_i.my_id].location.y == og_height then
                    return true
                elseif not status.detect['forward']() then
                    return true
                end
            else
                break
            end
        end
        while status.pcTable[status.who_am_i.my_id].location.y > now_height do
            move.move_log('down')
        end
        return false
    end
    local function return_check(direction)
        local opposite_direction = direction == 'left' and 'right' or 'left'
        move.move_log(opposite_direction)
        while counters[direction] > 0 do
            move.move_log('forward')
            counters[direction] = counters[direction] - 1
        end
        move.move_log(direction)
    end
    local function try_left_and_right()
        if try_direction(function()
            move.move_log('left')
            if not status.detect['forward']() then
                move.move_log('forward')
                move.move_log('right')
                if not status.detect['forward']() then
                    return true
                else
                    return try_up_again(status.pcTable[status.who_am_i.my_id].location.y)
                end
            else
                move.move_log('right')
                return nil
            end
        end, 'left') then
            return true
        else
            return_check('left')
            if try_direction(function()
                move.move_log('right')
                if not status.detect['forward']() then
                    move.move_log('forward')
                    move.move_log('left')
                    if not status.detect['forward']() then
                        return true
                    else
                        return try_up_again(status.pcTable[status.who_am_i.my_id].location.y)
                    end
                else
                    move.move_log('left')
                    return nil
                end
            end, 'right') then
                return true
            else
                return_check('right')
            end
        end
        return false
    end
    if try_direction(function()
        if not status.detect['up']() then
            move.move_log('up')
            return not status.detect['forward']()
        else
            return nil
        end
    end, 'up') then
        return true
    else
        cur_height = 1
        max_attempts = 10
        og_height = status.pcTable[status.who_am_i.my_id].location.y
        while counters.up > -max_attempts do
            if try_left_and_right() then
                return true
            elseif not status.detect['down']() then
                move.move_log('down')
                if not status.detect['forward']() then
                    return true
                end
            else
                return false
            end
            counters.up = counters.up - 1
        end
    end
    return false
end
function moving_up_check()
end
function up_foward_check()
    if not status.detect['forward']() then
        move.move_log('forward')
        if status.detect['up']() then
            move.move_log('back')
            return false
        end
    else
        return false
    end
    return true
end
function up_left_check()
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        if status.detect['up']() then
            move.move_log('back')
            move.move_log('right')
            return false
        end
    else
        return false
    end
    return true
end
function up_right_check()
    move.move_log('right')
    if not status.detect['forward']() then
        move.move_log('forward')
        if status.detect['up']() then
            move.move_log('back')
            move.move_log('left')
            return false
        end
    else
        return false
    end
    return true
end
function up_back_check()
    move.move_log('left')
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        if status.detect['up']() then
            move.move_log('back')
            move.move_log('right')
            move.move_log('right')
            return false
        end
    else
        return false
    end
    return true
end
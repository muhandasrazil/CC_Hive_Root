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
    if status.pcTable[status.me].orientation == orientation then
        return true
    elseif status.right_shift[status.pcTable[status.me].orientation] == orientation then
        move_log('right')
    elseif status.left_shift[status.pcTable[status.me].orientation] == orientation then
        move_log('left')
    elseif status.reverse_shift[status.pcTable[status.me].orientation] == orientation then
        move_log('left')
        move_log('left')
    else
        return false
    end
    return true
end
function log_movement(direction)
    if direction == 'up' then
        status.pcTable[status.me].location.y = status.pcTable[status.me].location.y +1
    elseif direction == 'down' then
        status.pcTable[status.me].location.y = status.pcTable[status.me].location.y -1
    elseif direction == 'forward' then
        bump = status.bumps[status.pcTable[status.me].orientation]
        status.pcTable[status.me].location = {x = status.pcTable[status.me].location.x + bump[1], y = status.pcTable[status.me].location.y + bump[2], z = status.pcTable[status.me].location.z + bump[3]}
    elseif direction == 'back' then
        bump = status.bumps[status.pcTable[status.me].orientation]
        status.pcTable[status.me].location = {x = status.pcTable[status.me].location.x - bump[1], y = status.pcTable[status.me].location.y - bump[2], z = status.pcTable[status.me].location.z - bump[3]}
    elseif direction == 'left' then
        status.pcTable[status.me].orientation = status.left_shift[status.pcTable[status.me].orientation]
    elseif direction == 'right' then
        status.pcTable[status.me].orientation = status.right_shift[status.pcTable[status.me].orientation]
    end
    return true
end

--{x = , y = , z = }
function status_goto_startup(end_loc, end_ori, path)
    status.going.static.sloc = status.pcTable[status.me].location
    status.going.static.eloc = end_loc
    status.going.static.sloc_nav = {x = status.pcTable[status.me].location.x-end_loc.x, y = status.pcTable[status.me].location.y-end_loc.y, z =status.pcTable[status.me].location.z-end_loc.z}
    status.going.static.sloc_nav_abs = math.abs({x = status.pcTable[status.me].location.x-end_loc.x, y = status.pcTable[status.me].location.y-end_loc.y, z =status.pcTable[status.me].location.z-end_loc.z})
    status.going.static.eloc_nav = {x = end_loc.x-status.pcTable[status.me].location.x, y = end_loc.y-status.pcTable[status.me].location.y, z = end_loc.z-status.pcTable[status.me].location.z}
    status.going.static.eloc_nav_abs = math.abs({x = end_loc.x-status.pcTable[status.me].location.x, y = end_loc.y-status.pcTable[status.me].location.y, z = end_loc.z-status.pcTable[status.me].location.z})
    status.going.static.nav_priority_input = path
    status.going.static.sdir = status.pcTable[status.me].orientation
    status.going.static.edir = end_ori
end

function go_to(end_location, end_orientation, path)
    status.going.endloc = end_location
    move.status_goto_startup(end_location, end_orientation, path)
    print(textutils.serialize(status.going.static))
    read()
    local function reached_destination()
        for axis in path:gmatch('.') do
            if status.pcTable[status.me].location[axis] ~= end_location[axis] then
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
    if status.going.endloc[axis]-status.pcTable[status.me].location[axis] == 0 then
        return true
    end
    if axis == 'x' then
        if status.going.endloc[axis]-status.pcTable[status.me].location[axis] > 0 then
            if not face('east') then return false end
        else
            if not face('west') then return false end
        end
    elseif axis == 'z' then
        if status.going.endloc[axis]-status.pcTable[status.me].location[axis] > 0 then
            if not face('south') then return false end
        else
            if not face('north') then return false end
        end
    end
    while status.going.endloc[axis]-status.pcTable[status.me].location[axis] ~= 0 do
        if axis == 'y' then
            if status.going.endloc[axis]-status.pcTable[status.me].location[axis] > 0 then
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
        return false
    elseif (direction == 'up' and status.detect[direction]()) then
        return false
    elseif (direction == 'down' and status.detect[direction]()) then
        return false
    end
    move.move_log(direction)
    return true
end
-- section for checking directings if forward is blocked
function fwd_up_ck()
    if not status.detect['up']() then
        move.move_log('up')
        if not status.detect['forward']() then
            return true
        end
    end
    return false
end
function fwd_lft_ck()
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('right')
        if not status.detect['forward']() then
            return true
        end
    end
    return false
end
function fwd_rit_ck()
    move.move_log('right')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('left')
        if not status.detect['forward']() then
            return true
        end
    end
    return false
end
function fwd_dwn_ck()
    if not status.detect['down']() then
        move.move_log('down')
        if not status.detect['forward']() then
            return true
        end
    end
    return false
end
-- section for checking directings if up is blocked
function up_fwd_ck()
    if not status.detect['forward']() then
        move.move_log('forward')
        if not status.detect['up']() then
            return true
        end
    end
    return false
end
function up_lft_ck()
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('right')
        if not status.detect['up']() then
            return true
        end
    end
    return false
end
function up_rit_ck()
    move.move_log('right')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('left')
        if not status.detect['up']() then
            return true
        end
    end
    return false
end
function up_bak_ck()
    move.move_log('left')
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('left')
        move.move_log('left')
        if not status.detect['up']() then
            return true
        end
    end
    return false
end
-- section for checking directings if down is blocked
function dwn_fwd_ck()
    if not status.detect['forward']() then
        move.move_log('forward')
        if not status.detect['down']() then
            return true
        end
    end
    return false
end
function dwn_lft_ck()
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('right')
        if not status.detect['down']() then
            return true
        end
    end
    return false
end
function dwn_rit_ck()
    move.move_log('right')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('left')
        if not status.detect['down']() then
            return true
        end
    end
    return false
end
function dwn_bak_ck()
    move.move_log('left')
    move.move_log('left')
    if not status.detect['forward']() then
        move.move_log('forward')
        move.move_log('left')
        move.move_log('left')
        if not status.detect['down']() then
            return true
        end
    end
    return false
end
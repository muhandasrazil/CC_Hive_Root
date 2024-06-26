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
    stats.update_face(false,{2,3,4,5})                                                      --* face - 1|face
    if orientation == 'north' then stats.update_face(false,{1,3,4,5})                       --+ face - 2|north
    elseif orientation == 'south' then stats.update_face(false,{1,2,4,5})                   --* face - 3|south
    elseif orientation == 'east' then stats.update_face(false,{1,2,3,5})                    --+ face - 4|east
    elseif orientation == 'west' then stats.update_face(false,{1,2,3,4})                    --* face - 5|west
    end
    if status.pcTable[status.me].orientation == orientation then
        stats.update_vars(false,{2,3,4,5,6,7,8})                                            --+ vars - 1|tru
        return true
    elseif status.right_shift[status.pcTable[status.me].orientation] == orientation then
        move_log('right')
    elseif status.left_shift[status.pcTable[status.me].orientation] == orientation then
        move_log('left')
    elseif status.reverse_shift[status.pcTable[status.me].orientation] == orientation then
        move_log('left')
        move_log('left')
    else
        stats.update_vars(false,{1,3,4,5,6,7,8})                                            --+ vars - 2|fls
        return false
    end
    stats.update_vars(false,{2,3,4,5,6,7,8})                                                --* vars - 1|tru
    return true
end
function log_movement(direction)
    if direction == 'up' then
        status.pcTable[status.me].location.y = status.pcTable[status.me].location.y +1
        stats.update_move(false,{1,2,4,5,6,7,8,9,10,11,13,14,15,16,17})                     --* move - 3|pos_y - 12|up
    elseif direction == 'down' then
        status.pcTable[status.me].location.y = status.pcTable[status.me].location.y -1
        stats.update_move(false,{1,2,3,4,5,7,8,9,10,11,12,14,15,16,17})                     --+ move - 6|neg_y - 13|down
    elseif direction == 'forward' then
        bump = status.bumps[status.pcTable[status.me].orientation]
        status.pcTable[status.me].location = {x = status.pcTable[status.me].location.x + bump[1], y = status.pcTable[status.me].location.y + bump[2], z = status.pcTable[status.me].location.z + bump[3]}
        if status.pcTable[status.me].orientation == 'north' then
            stats.update_move(false,{1,2,3,4,5,6,9,10,11,12,13,14,15,17})                   --* move - 7|neg_z - 8|north - 16|forward
        elseif status.pcTable[status.me].orientation == 'south' then
            stats.update_move(false,{1,2,3,5,6,7,8,10,11,12,13,14,15,17})                   --* move - 4|pos_z - 9|south - 16|forward
        elseif status.pcTable[status.me].orientation == 'east' then
            stats.update_move(false,{1,3,4,5,6,7,8,9,11,12,13,14,15,17})                    --* move - 2|pos_x - 10|east - 16|forward
        elseif status.pcTable[status.me].orientation == 'west' then
            stats.update_move(false,{1,2,3,4,6,7,8,9,10,12,13,14,15,17})                    --* move - 5|neg_x - 11|west - 16|forward
        end
    elseif direction == 'back' then
        bump = status.bumps[status.pcTable[status.me].orientation]
        status.pcTable[status.me].location = {x = status.pcTable[status.me].location.x - bump[1], y = status.pcTable[status.me].location.y - bump[2], z = status.pcTable[status.me].location.z - bump[3]}
        if status.pcTable[status.me].orientation == 'north' then
            stats.update_move(false,{1,2,3,5,6,7,8,10,11,12,13,14,15,16})                   --* move - 4|pos_z - 9|south - 17|back
        elseif status.pcTable[status.me].orientation == 'south' then
            stats.update_move(false,{1,2,3,4,5,6,9,10,11,12,13,14,15,16})                   --* move - 7|neg_z - 8|north - 17|back
        elseif status.pcTable[status.me].orientation == 'east' then
            stats.update_move(false,{1,2,3,4,6,7,8,9,10,12,13,14,15,16})                    --* move - 5|neg_x - 11|west - 17|back
        elseif status.pcTable[status.me].orientation == 'west' then
            stats.update_move(false,{1,3,4,5,6,7,8,9,11,12,13,14,15,16})                    --* move - 2|pos_x - 10|east - 17|back
        end
    elseif direction == 'left' then
        status.pcTable[status.me].orientation = status.left_shift[status.pcTable[status.me].orientation]
        stats.update_move(false,{1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17})                   --* move - 14|left
    elseif direction == 'right' then
        status.pcTable[status.me].orientation = status.right_shift[status.pcTable[status.me].orientation]
        stats.update_move(false,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,17})                   --+ move - 15|right
    end
    stats.update_move(false,{2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17})                      --+ move - 1|total
    stats.update_vars(false,{2})                                                            --* vars - 1|tru - 3,4,5|larg_x,y,z - 6,7,8|smal_x,y,z
    return true
end
function go_to(end_location, end_orientation, path)
    --- (move,detect,vars,go,face,static,dynmc,fwd,up,dwn,lft,rit,bck)
    stats.clear_all_stats(1,1,1,1,1,1,0,0,0,0,0,0,0)                                        --+ 1 = on | 0 = off
    sleep(2)
    stats.update_static(end_location, path, false, {})
    stats.first_min_max_xyz()
    local function reached_destination()
        for axis in path:gmatch('.') do
            if status.pcTable[status.me].location[axis] ~= end_location[axis] then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --* vars - 2|fls
                return false
            end
        end
        stats.update_vars(false,{2,3,4,5,6,7,8})                                            --* vars - 1|tru
        return true
    end
    local function try_path()
        for axis in path:gmatch('.') do
            if not go_to_axis(axis) then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --* vars - 2|fls
                return false
            end
        end
        stats.update_vars(false,{2,3,4,5,6,7,8})                                            --* vars - 1|tru
        return true
    end
    while not reached_destination() do
        if not try_path() then
            stats.update_vars(false,{1,3,4,5,6,7,8})                                        --+ vars - 2|fls
            return false
        end
    end
    if end_orientation then
        if not face(end_orientation) then
            stats.update_vars(false,{1,3,4,5,6,7,8})                                        --+ vars - 2|fls
            return false
        end
    elseif end_location.orientation then
        if not face(end_location.orientation) then
            stats.update_vars(false,{1,3,4,5,6,7,8})                                        --* vars - 2|fls
            return false
        end
    end
    stats.update_vars(false,{2,3,4,5,6,7,8})                                                --* vars - 1|tru
    return true
end
function go_to_axis(axis)
    if stats.going.static.eloc[axis]-status.pcTable[status.me].location[axis] == 0 then
        stats.update_vars(false,{2,3,4,5,6,7,8})                                            --+ vars - 1|tru
        return true
    end
    if axis == 'x' then
        if stats.going.static.eloc[axis]-status.pcTable[status.me].location[axis] > 0 then
            if not face('east') then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --+ vars - 2|fls
                return false
            end
        else
            if not face('west') then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --* vars - 2|fls
                return false
            end
        end
    elseif axis == 'z' then
        if stats.going.static.eloc[axis]-status.pcTable[status.me].location[axis] > 0 then
            if not face('south') then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --+ vars - 2|fls
                return false
            end
        else
            if not face('north') then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --* vars - 2|fls
                return false
            end
        end
    end
    while stats.going.static.eloc[axis]-status.pcTable[status.me].location[axis] ~= 0 do
        if axis == 'y' then
            if stats.going.static.eloc[axis]-status.pcTable[status.me].location[axis] > 0 then
                if not go('up') then
                    stats.update_vars(false,{1,3,4,5,6,7,8})                                --+ vars - 2|fls
                    return false
                end
            else
                if not go('down') then
                    stats.update_vars(false,{1,3,4,5,6,7,8})                                --* vars - 2|fls
                    return false
                end
            end
        else
            if not go('forward') then
                stats.update_vars(false,{1,3,4,5,6,7,8})                                    --* vars - 2|fls
                return false
            end
        end
    end
    stats.update_vars(false,{2,3,4,5,6,7,8})                                                --+ vars - 1|tru
    return true
end
function go(direction)
    stats.update_go(false,{2,3,4,5,6,7})                                                    --+ go - 1|go
    if direction == 'up' then
        stats.update_go(false,{1,3,4,5,6,7})                                                --+ go - 2|up
    elseif direction == 'down' then
        stats.update_go(false,{1,2,4,5,6,7})                                                --+ go - 3|down
    elseif direction == 'forward' then
        stats.update_go(false,{1,2,3,5,6,7})                                                --+ go - 4|forward
    elseif direction == 'back' then
        stats.update_go(false,{1,2,3,4,6,7})                                                --+ go - 5|back
    elseif direction == 'left' then
        stats.update_go(false,{1,2,3,4,5,7})                                                --+ go - 6|left
    elseif direction == 'right' then
        stats.update_go(false,{1,2,3,4,5,6})                                                --+ go - 7|right
    end
    if (direction == 'forward' and status.detect[direction]()) then
        stats.update_detect(false,{2,3})                                                    --* detect - 1|total - 4|forward
        stats.update_vars(false,{1,3,4,5,6,7,8})                                            --+ vars - 2|fls
        return false
    elseif (direction == 'up' and status.detect[direction]()) then
        stats.update_detect(false,{3,4})                                                    --* detect - 1|total - 2|up
        stats.update_vars(false,{1,3,4,5,6,7,8})                                            --+ vars - 2|fls
        return false
    elseif (direction == 'down' and status.detect[direction]()) then
        stats.update_detect(false,{2,4})                                                    --* detect - 1|total - 3|down
        stats.update_vars(false,{1,3,4,5,6,7,8})                                            --+ vars - 2|fls
        return false
    end
    move.move_log(direction)
    stats.update_vars(false,{2,3,4,5,6,7,8})                                                --+ vars - 1|tru
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
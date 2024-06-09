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

function print_going_status(t)
    term.clear()
    term.setCursorPos(1,1)
    print(t..":")
    for _, key in ipairs(status.going[t].key_order) do
        val = status.going[t][key]
        term.write(key..":  ")
        if type(val) == "table" then
            if val.key_order then
                for _, k in ipairs(val.key_order) do
                    v = val[k]
                    print(k..":  ")
                    if type(v) == "table" then
                        for _, subkey in ipairs(status.going.sub_order) do
                            term.write(tostring(subkey)..": "..tostring(v[subkey]).." ")
                        end
                    end
                end
            else
                for _, subkey in ipairs(status.going.sub_order) do
                    term.write(tostring(subkey)..": "..tostring(val[subkey]).." ")
                end
            end
        else
            term.write(val)
        end
        print()
    end
end
function update_stats(move, mp, detect, dp, vars, vp, print)
    if move then
        move.update_move(mp)
    end
    if detect then
        move.update_detect(dp)
    end
    if vars then
        move.update_vars(vp)
    end
    if print then
        move.print_going_status('stats')
    end
end
function update_move(print)
    status.going.stats.move.total = nil
    status.going.stats.move.pos_x = nil
    status.going.stats.move.pos_y = nil
    status.going.stats.move.pos_z = nil
    status.going.stats.move.neg_x = nil
    status.going.stats.move.neg_y = nil
    status.going.stats.move.neg_z = nil
    status.going.stats.move.north = nil
    status.going.stats.move.south = nil
    status.going.stats.move.east = nil
    status.going.stats.move.west = nil
    status.going.stats.move.up = nil
    status.going.stats.move.down = nil
    status.going.stats.move.left = nil
    status.going.stats.move.right = nil
    status.going.stats.move.forward = nil
    status.going.stats.move.back = nil
    if print then
        move.print_going_status('stats.move')
    end
end
function update_detect(print)
    status.going.stats.detect.total = nil
    status.going.stats.detect.up = nil
    status.going.stats.detect.down = nil
    status.going.stats.detect.forward = nil
    if print then
        move.print_going_status('stats.detect')
    end
end
function update_vars(print)
    status.going.stats.vars.tru = nil
    status.going.stats.vars.fls = nil
    status.going.stats.vars.go = nil
    status.going.stats.vars.up = nil
    status.going.stats.vars.down = nil
    status.going.stats.vars.forward = nil
    status.going.stats.vars.larg_x = nil
    status.going.stats.vars.larg_y = nil
    status.going.stats.vars.larg_z = nil
    status.going.stats.vars.smal_x = nil
    status.going.stats.vars.smal_y = nil
    status.going.stats.vars.smal_z = nil
    if print then
        move.print_going_status('stats.vars')
    end
end



--{x = , y = , z = }
function update_static(end_loc, end_ori, path,print)
    status.going.static.sloc = status.pcTable[status.me].location
    status.going.static.eloc = end_loc
    status.going.static.sloc_nav = {x = status.pcTable[status.me].location.x-end_loc.x, y = status.pcTable[status.me].location.y-end_loc.y, z =status.pcTable[status.me].location.z-end_loc.z}
    status.going.static.sloc_nav_abs = {x = math.abs(status.pcTable[status.me].location.x-end_loc.x), y = math.abs(status.pcTable[status.me].location.y-end_loc.y), z = math.abs(status.pcTable[status.me].location.z-end_loc.z)}
    status.going.static.eloc_nav = {x = end_loc.x-status.pcTable[status.me].location.x, y = end_loc.y-status.pcTable[status.me].location.y, z = end_loc.z-status.pcTable[status.me].location.z}
    status.going.static.eloc_nav_abs = {x = math.abs(end_loc.x-status.pcTable[status.me].location.x),y = math.abs(end_loc.y-status.pcTable[status.me].location.y), z = math.abs(end_loc.z-status.pcTable[status.me].location.z)}
    status.going.static.nav_priority_input = path
    status.going.static.sdir = status.pcTable[status.me].orientation
    status.going.static.edir = end_ori
    if print then
        move.print_going_status('static')
    end
end
function update_dynmc(print)
    status.going.dynmc.slocn = nil
    status.going.dynmc.elocn = nil
    status.going.dynmc.slocn_nav = {x = nil, y = nil, z = nil}
    status.going.dynmc.slocn_nav_abs = {x = nil, y = nil, z = nil}
    status.going.dynmc.elocn_nav = {x = nil, y = nil, z = nil}
    status.going.dynmc.elocn_nav_abs = {x = nil, y = nil, z = nil}
    status.going.dynmc.nav = {x = nil, y = nil, z = nil}
    status.going.dynmc.nav_abs = {x = nil, y = nil, z = nil}
    status.going.dynmc.dirn = nil
    status.going.dynmc.sdirn = nil
    status.going.dynmc.edirn = nil
    status.going.dynmc.axisn = nil
    if print then
        move.print_going_status('dynmc')
    end
end
function update_fwd(print)
    status.going.fwd.dirfc = nil
    status.going.fwd.sdir = nil
    status.going.fwd.edir = nil
    status.going.fwd.hloc = nil
    status.going.fwd.hs_nav = {x = nil, y = nil, z = nil}
    status.going.fwd.hs_nav_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.he_nav = {x = nil, y = nil, z = nil}
    status.going.fwd.he_nav_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.nav_sh = {x = nil, y = nil, z = nil}
    status.going.fwd.nav_sh_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.nav_he = {x = nil, y = nil, z = nil}
    status.going.fwd.nav_he_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.h_nav_c = {x = nil, y = nil, z = nil}
    status.going.fwd.h_nav_c_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.clos_sloc = nil
    status.going.fwd.clos_nav_s = {x = nil, y = nil, z = nil}
    status.going.fwd.clo_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.clo_eloc = nil
    status.going.fwd.clo_nav_e = {x = nil, y = nil, z = nil}
    status.going.fwd.clo_nav_e_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.fur_sloc = nil
    status.going.fwd.fur_nav_s = {x = nil, y = nil, z = nil}
    status.going.fwd.fur_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.fwd.fur_eloc = nil
    status.going.fwd.fur_nav_e = {x = nil, y = nil, z = nil}
    status.going.fwd.fur_nav_e_abs = {x = nil, y = nil, z = nil}
    if print then
        move.print_going_status('fwd')
    end
end
function update_up(print)
    status.going.up.dirfc = nil
    status.going.up.sdir = nil
    status.going.up.edir = nil
    status.going.up.hloc = nil
    status.going.up.hs_nav = {x = nil, y = nil, z = nil}
    status.going.up.hs_nav_abs = {x = nil, y = nil, z = nil}
    status.going.up.he_nav = {x = nil, y = nil, z = nil}
    status.going.up.he_nav_abs = {x = nil, y = nil, z = nil}
    status.going.up.nav_sh = {x = nil, y = nil, z = nil}
    status.going.up.nav_sh_abs = {x = nil, y = nil, z = nil}
    status.going.up.nav_he = {x = nil, y = nil, z = nil}
    status.going.up.nav_he_abs = {x = nil, y = nil, z = nil}
    status.going.up.h_nav_c = {x = nil, y = nil, z = nil}
    status.going.up.h_nav_c_abs = {x = nil, y = nil, z = nil}
    status.going.up.clos_sloc = nil
    status.going.up.clos_nav_s = {x = nil, y = nil, z = nil}
    status.going.up.clo_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.up.clo_eloc = nil
    status.going.up.clo_nav_e = {x = nil, y = nil, z = nil}
    status.going.up.clo_nav_e_abs = {x = nil, y = nil, z = nil}
    status.going.up.fur_sloc = nil
    status.going.up.fur_nav_s = {x = nil, y = nil, z = nil}
    status.going.up.fur_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.up.fur_eloc = nil
    status.going.up.fur_nav_e = {x = nil, y = nil, z = nil}
    status.going.up.fur_nav_e_abs = {x = nil, y = nil, z = nil}
    if print then
        move.print_going_status('up')
    end
end
function update_dwn(print)
    status.going.dwn.dirfc = nil
    status.going.dwn.sdir = nil
    status.going.dwn.edir = nil
    status.going.dwn.hloc = nil
    status.going.dwn.hs_nav = {x = nil, y = nil, z = nil}
    status.going.dwn.hs_nav_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.he_nav = {x = nil, y = nil, z = nil}
    status.going.dwn.he_nav_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.nav_sh = {x = nil, y = nil, z = nil}
    status.going.dwn.nav_sh_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.nav_he = {x = nil, y = nil, z = nil}
    status.going.dwn.nav_he_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.h_nav_c = {x = nil, y = nil, z = nil}
    status.going.dwn.h_nav_c_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.clos_sloc = nil
    status.going.dwn.clos_nav_s = {x = nil, y = nil, z = nil}
    status.going.dwn.clo_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.clo_eloc = nil
    status.going.dwn.clo_nav_e = {x = nil, y = nil, z = nil}
    status.going.dwn.clo_nav_e_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.fur_sloc = nil
    status.going.dwn.fur_nav_s = {x = nil, y = nil, z = nil}
    status.going.dwn.fur_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.dwn.fur_eloc = nil
    status.going.dwn.fur_nav_e = {x = nil, y = nil, z = nil}
    status.going.dwn.fur_nav_e_abs = {x = nil, y = nil, z = nil}
    if print then
        move.print_going_status('dwn')
    end
end
function update_lft(print)
    status.going.lft.dirfc = nil
    status.going.lft.sdir = nil
    status.going.lft.edir = nil
    status.going.lft.hloc = nil
    status.going.lft.hs_nav = {x = nil, y = nil, z = nil}
    status.going.lft.hs_nav_abs = {x = nil, y = nil, z = nil}
    status.going.lft.he_nav = {x = nil, y = nil, z = nil}
    status.going.lft.he_nav_abs = {x = nil, y = nil, z = nil}
    status.going.lft.nav_sh = {x = nil, y = nil, z = nil}
    status.going.lft.nav_sh_abs = {x = nil, y = nil, z = nil}
    status.going.lft.nav_he = {x = nil, y = nil, z = nil}
    status.going.lft.nav_he_abs = {x = nil, y = nil, z = nil}
    status.going.lft.h_nav_c = {x = nil, y = nil, z = nil}
    status.going.lft.h_nav_c_abs = {x = nil, y = nil, z = nil}
    status.going.lft.clos_sloc = nil
    status.going.lft.clos_nav_s = {x = nil, y = nil, z = nil}
    status.going.lft.clo_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.lft.clo_eloc = nil
    status.going.lft.clo_nav_e = {x = nil, y = nil, z = nil}
    status.going.lft.clo_nav_e_abs = {x = nil, y = nil, z = nil}
    status.going.lft.fur_sloc = nil
    status.going.lft.fur_nav_s = {x = nil, y = nil, z = nil}
    status.going.lft.fur_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.lft.fur_eloc = nil
    status.going.lft.fur_nav_e = {x = nil, y = nil, z = nil}
    status.going.lft.fur_nav_e_abs = {x = nil, y = nil, z = nil}
    if print then
        move.print_going_status('lft')
    end
end
function update_rit(print)
    status.going.rit.dirfc = nil
    status.going.rit.sdir = nil
    status.going.rit.edir = nil
    status.going.rit.hloc = nil
    status.going.rit.hs_nav = {x = nil, y = nil, z = nil}
    status.going.rit.hs_nav_abs = {x = nil, y = nil, z = nil}
    status.going.rit.he_nav = {x = nil, y = nil, z = nil}
    status.going.rit.he_nav_abs = {x = nil, y = nil, z = nil}
    status.going.rit.nav_sh = {x = nil, y = nil, z = nil}
    status.going.rit.nav_sh_abs = {x = nil, y = nil, z = nil}
    status.going.rit.nav_he = {x = nil, y = nil, z = nil}
    status.going.rit.nav_he_abs = {x = nil, y = nil, z = nil}
    status.going.rit.h_nav_c = {x = nil, y = nil, z = nil}
    status.going.rit.h_nav_c_abs = {x = nil, y = nil, z = nil}
    status.going.rit.clos_sloc = nil
    status.going.rit.clos_nav_s = {x = nil, y = nil, z = nil}
    status.going.rit.clo_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.rit.clo_eloc = nil
    status.going.rit.clo_nav_e = {x = nil, y = nil, z = nil}
    status.going.rit.clo_nav_e_abs = {x = nil, y = nil, z = nil}
    status.going.rit.fur_sloc = nil
    status.going.rit.fur_nav_s = {x = nil, y = nil, z = nil}
    status.going.rit.fur_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.rit.fur_eloc = nil
    status.going.rit.fur_nav_e = {x = nil, y = nil, z = nil}
    status.going.rit.fur_nav_e_abs = {x = nil, y = nil, z = nil}
    if print then
        move.print_going_status('rit')
    end
end
function update_bck(print)
    status.going.bck.dirfc = nil
    status.going.bck.sdir = nil
    status.going.bck.edir = nil
    status.going.bck.hloc = nil
    status.going.bck.hs_nav = {x = nil, y = nil, z = nil}
    status.going.bck.hs_nav_abs = {x = nil, y = nil, z = nil}
    status.going.bck.he_nav = {x = nil, y = nil, z = nil}
    status.going.bck.he_nav_abs = {x = nil, y = nil, z = nil}
    status.going.bck.nav_sh = {x = nil, y = nil, z = nil}
    status.going.bck.nav_sh_abs = {x = nil, y = nil, z = nil}
    status.going.bck.nav_he = {x = nil, y = nil, z = nil}
    status.going.bck.nav_he_abs = {x = nil, y = nil, z = nil}
    status.going.bck.h_nav_c = {x = nil, y = nil, z = nil}
    status.going.bck.h_nav_c_abs = {x = nil, y = nil, z = nil}
    status.going.bck.clos_sloc = nil
    status.going.bck.clos_nav_s = {x = nil, y = nil, z = nil}
    status.going.bck.clo_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.bck.clo_eloc = nil
    status.going.bck.clo_nav_e = {x = nil, y = nil, z = nil}
    status.going.bck.clo_nav_e_abs = {x = nil, y = nil, z = nil}
    status.going.bck.fur_sloc = nil
    status.going.bck.fur_nav_s = {x = nil, y = nil, z = nil}
    status.going.bck.fur_nav_s_abs = {x = nil, y = nil, z = nil}
    status.going.bck.fur_eloc = nil
    status.going.bck.fur_nav_e = {x = nil, y = nil, z = nil}
    status.going.bck.fur_nav_e_abs = {x = nil, y = nil, z = nil}
    if print then
        move.print_going_status('bck')
    end
end
function go_to(end_location, end_orientation, path)
    status.going.endloc = end_location
    move.update_static(end_location, end_orientation, path,true)
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
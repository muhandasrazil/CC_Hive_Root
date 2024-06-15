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
        move.update_move(false,{1,2,4,5,6,7,8,9,10,11,13,14,15,16,17})                      --+ 3|pos_y - 12|up
        move.update_vars(false,{1,2,3,5,6,7,8,9,10,11,12})                                  --* 4|up
    elseif direction == 'down' then
        status.pcTable[status.me].location.y = status.pcTable[status.me].location.y -1
        move.update_move(false,{1,2,3,4,5,7,8,9,10,11,12,14,15,16,17})                      --+ 6|neg_y - 13|down
        move.update_vars(false,{1,2,3,4,6,7,8,9,10,11,12})                                  --* 5|down
    elseif direction == 'forward' then
        bump = status.bumps[status.pcTable[status.me].orientation]
        status.pcTable[status.me].location = {x = status.pcTable[status.me].location.x + bump[1], y = status.pcTable[status.me].location.y + bump[2], z = status.pcTable[status.me].location.z + bump[3]}
        if status.pcTable[status.me].orientation == 'north' then
            move.update_move(false,{1,2,3,4,5,6,9,10,11,12,13,14,15,17})                    --+ 7|neg_z - 8|north - 16|forward
        elseif status.pcTable[status.me].orientation == 'south' then
            move.update_move(false,{1,2,3,5,6,7,8,10,11,12,13,14,15,17})                    --+ 4|pos_z - 9|south - 16|forward
        elseif status.pcTable[status.me].orientation == 'east' then
            move.update_move(false,{1,3,4,5,6,7,8,9,11,12,13,14,15,17})                     --+ 2|pos_x - 10|east - 16|forward
        elseif status.pcTable[status.me].orientation == 'west' then
            move.update_move(false,{1,2,3,4,6,7,8,9,10,12,13,14,15,17})                     --+ 5|neg_x - 11|west - 16|forward
        end
        move.update_vars(false,{1,2,3,4,5,7,8,9,10,11,12})                                  --+ 6|forward
    elseif direction == 'back' then
        bump = status.bumps[status.pcTable[status.me].orientation]
        status.pcTable[status.me].location = {x = status.pcTable[status.me].location.x - bump[1], y = status.pcTable[status.me].location.y - bump[2], z = status.pcTable[status.me].location.z - bump[3]}
        if status.pcTable[status.me].orientation == 'north' then
            move.update_move(false,{1,2,3,5,6,7,8,10,11,12,13,14,15,16})                    --* 4|pos_z - 9|south - 17|back
        elseif status.pcTable[status.me].orientation == 'south' then
            move.update_move(false,{1,2,3,4,5,6,9,10,11,12,13,14,15,16})                    --* 7|neg_z - 8|north - 17|back
        elseif status.pcTable[status.me].orientation == 'east' then
            move.update_move(false,{1,2,3,4,6,7,8,9,10,12,13,14,15,16})                     --* 5|neg_x - 11|west - 17|back
        elseif status.pcTable[status.me].orientation == 'west' then
            move.update_move(false,{1,3,4,5,6,7,8,9,11,12,13,14,15,16})                     --* 2|pos_x - 10|east - 17|back
        end
    elseif direction == 'left' then
        status.pcTable[status.me].orientation = status.left_shift[status.pcTable[status.me].orientation]
        move.update_move(false,{1,2,3,4,5,6,7,8,9,10,11,12,13,15,16,17})                    --* 14|left
    elseif direction == 'right' then
        status.pcTable[status.me].orientation = status.right_shift[status.pcTable[status.me].orientation]
        move.update_move(false,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,16,17})                    --+ 15|right
    end
    move.update_move(false,{2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17})                       --+ 1|total
    move.update_vars(false,{1,2,3,4,5,6})                                                   --* 7,8,9|larg_x,y,z - 10,11,12|smal_x,y,z
    return true
end
function print_going_status(t)
    term.clear()
    term.setCursorPos(1,1)
    print(t..":")
    local function resolveTablePath(tbl, path)
        local scope = tbl
        for part in string.gmatch(path, "[^.]+") do
            scope = scope[part]
            if not scope then return nil end
        end
        return scope
    end
    local resolvedTable = resolveTablePath(status.going, t)
    for _, key in ipairs(resolvedTable.key_order) do
        local val = resolvedTable[key]
        term.write(key..":  ")
        if type(val) == "table" then
            if val.key_order then
                for _, k in ipairs(val.key_order) do
                    local v = val[k]
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
            term.write(tostring(val))
        end
        print()
    end
end
--| Just making a simple way to update the largest and smallest xyz values.
--| If I fill out these variables like a check list I can do fun things later maybe
function first_min_max_xyz()
    status.going.stats.vars.larg_x = status.pcTable[status.me].location.x
    actions.updateStateValue("stats_vars_larg_x",status.pcTable[status.me].location.x)
    status.going.stats.vars.larg_y = status.pcTable[status.me].location.y
    actions.updateStateValue("stats_vars_larg_y",status.pcTable[status.me].location.y)
    status.going.stats.vars.larg_z = status.pcTable[status.me].location.z
    actions.updateStateValue("stats_vars_larg_z",status.pcTable[status.me].location.z)
    status.going.stats.vars.smal_x = status.pcTable[status.me].location.x
    actions.updateStateValue("stats_vars_smal_x",status.pcTable[status.me].location.x)
    status.going.stats.vars.smal_y = status.pcTable[status.me].location.y
    actions.updateStateValue("stats_vars_smal_y",status.pcTable[status.me].location.y)
    status.going.stats.vars.smal_z = status.pcTable[status.me].location.z
    actions.updateStateValue("stats_vars_smal_z",status.pcTable[status.me].location.z)
end
-- use the point a to point b system for the location information
-- this is to calculate which cardinal direction turtle must go to get to point B from point A
function d_math(pointA_xyz,pointB_xyz)
    local nx
    local ny
    local nz
    if pointA_xyz.x > pointB_xyz.x then nx = 'west' elseif pointA_xyz.x < pointB_xyz.x then nx = 'east' else nx = 'axis' end
    if pointA_xyz.y > pointB_xyz.y then ny = 'down' elseif pointA_xyz.y < pointB_xyz.y then ny = 'up' else ny = 'axis' end
    if pointA_xyz.z > pointB_xyz.z then nz = 'north' elseif pointA_xyz.z < pointB_xyz.z then nz = 'south' else nz = 'axis' end
    return {x = nx, y = ny, z = nz}
end
function update_move(print, skp_lst)
    -- move.update_move(false,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17})
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.stats.move[key] = value actions.updateStateValue("stats_move_" .. key, value) end
    local key_order = status.going.stats.move.key_order
    local updates = {
        function() setAndUpdate(key_order[1], status.going.stats.move.total + 1) end,       --+ 1|total
        function() setAndUpdate(key_order[2], status.going.stats.move.pos_x + 1) end,       --* 2|pos_x
        function() setAndUpdate(key_order[3], status.going.stats.move.pos_y + 1) end,       --+ 3|pos_y
        function() setAndUpdate(key_order[4], status.going.stats.move.pos_z + 1) end,       --* 4|pos_z
        function() setAndUpdate(key_order[5], status.going.stats.move.neg_x + 1) end,       --+ 5|neg_x
        function() setAndUpdate(key_order[6], status.going.stats.move.neg_y + 1) end,       --* 6|neg_y
        function() setAndUpdate(key_order[7], status.going.stats.move.neg_z + 1) end,       --+ 7|neg_z
        function() setAndUpdate(key_order[8], status.going.stats.move.north + 1) end,       --* 8|north
        function() setAndUpdate(key_order[9], status.going.stats.move.south + 1) end,       --+ 9|south
        function() setAndUpdate(key_order[10], status.going.stats.move.east + 1) end,       --* 10|east
        function() setAndUpdate(key_order[11], status.going.stats.move.west + 1) end,       --+ 11|west
        function() setAndUpdate(key_order[12], status.going.stats.move.up + 1) end,         --* 12|up
        function() setAndUpdate(key_order[13], status.going.stats.move.down + 1) end,       --+ 13|down
        function() setAndUpdate(key_order[14], status.going.stats.move.left + 1) end,       --* 14|left
        function() setAndUpdate(key_order[15], status.going.stats.move.right + 1) end,      --+ 15|right
        function() setAndUpdate(key_order[16], status.going.stats.move.forward + 1) end,    --* 16|forward
        function() setAndUpdate(key_order[17], status.going.stats.move.back + 1) end,       --+ 17|back
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('stats.move') end
end
function update_detect(print, skp_lst)
    -- move.update_detect(false,{1,2,3,4})
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.stats.detect[key] = value; actions.updateStateValue("stats_detect_" .. key, value) end
    local key_order = status.going.stats.detect.key_order
    local updates = {
        function() setAndUpdate(key_order[1], status.going.stats.detect.total + 1) end,     --+ 1|total
        function() setAndUpdate(key_order[2], status.going.stats.detect.up + 1) end,        --* 2|up
        function() setAndUpdate(key_order[3], status.going.stats.detect.down + 1) end,      --+ 3|down
        function() setAndUpdate(key_order[4], status.going.stats.detect.forward + 1) end,   --* 4|forward
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('stats.detect') end
end
function update_vars(print, skp_lst)
    -- move.update_vars(false,{1,2,3,4,5,6,7,8,9,10,11,12})
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.stats.vars[key] = value; actions.updateStateValue("stats_vars_" .. key, value) end
    local key_order = status.going.stats.vars.key_order
    local updates = {
        function() setAndUpdate(key_order[1], status.going.stats.vars.tru + 1) end,         --* 1|tru
        function() setAndUpdate(key_order[2], status.going.stats.vars.fls + 1) end,         --+ 2|fls
        function() setAndUpdate(key_order[3], status.going.stats.vars.go + 1) end,          --* 3|go
        function() setAndUpdate(key_order[4], status.going.stats.vars.up + 1) end,          --+ 4|up
        function() setAndUpdate(key_order[5], status.going.stats.vars.down + 1) end,        --* 5|down
        function() setAndUpdate(key_order[6], status.going.stats.vars.forward + 1) end,     --+ 6|forward
        function()
            if status.pcTable[status.me].location.x > status.going.stats.vars.larg_x then
                setAndUpdate(key_order[7], status.pcTable[status.me].location.x)            --* 7|larg_x
            end
        end,
        function()
            if status.pcTable[status.me].location.y > status.going.stats.vars.larg_y then
                setAndUpdate(key_order[8], status.pcTable[status.me].location.y)            --+ 8|larg_y
            end
        end,
        function()
            if status.pcTable[status.me].location.z > status.going.stats.vars.larg_z then
                setAndUpdate(key_order[9], status.pcTable[status.me].location.z)            --* 9|larg_z
            end
        end,
        function()
            if status.pcTable[status.me].location.x < status.going.stats.vars.smal_x then
                setAndUpdate(key_order[10], status.pcTable[status.me].location.x)           --+ 10|smal_x
            end
        end,
        function()
            if status.pcTable[status.me].location.y < status.going.stats.vars.smal_y then
                setAndUpdate(key_order[11], status.pcTable[status.me].location.y)           --* 11|smal_y
            end
        end,
        function()
            if status.pcTable[status.me].location.z < status.going.stats.vars.smal_z then
                setAndUpdate(key_order[12], status.pcTable[status.me].location.z)           --+ 12|smal_z
            end
        end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('stats.vars') end
end
function update_static(end_loc, path, print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.static[key] = value actions.updateStateValue("static_" .. key, value) end
    local key_order = status.going.static.key_order
    local updates = {
        --- sloc
        function() setAndUpdate(key_order[1], status.pcTable[status.me].location) end,
        --- eloc
        function() setAndUpdate(key_order[2], end_loc) end,
        --- sloc_nav
        function() setAndUpdate(key_order[3], {x = status.pcTable[status.me].location.x - end_loc.x, y = status.pcTable[status.me].location.y - end_loc.y, z = status.pcTable[status.me].location.z - end_loc.z}) end,
        --- sloc_nav_abs
        function() setAndUpdate(key_order[4], {x = math.abs(status.pcTable[status.me].location.x - end_loc.x), y = math.abs(status.pcTable[status.me].location.y - end_loc.y), z = math.abs(status.pcTable[status.me].location.z - end_loc.z)}) end,
        --- eloc_nav
        function() setAndUpdate(key_order[5], {x = end_loc.x - status.pcTable[status.me].location.x, y = end_loc.y - status.pcTable[status.me].location.y, z = end_loc.z - status.pcTable[status.me].location.z}) end,
        --- eloc_nav_abs
        function() setAndUpdate(key_order[6], {x = math.abs(end_loc.x - status.pcTable[status.me].location.x), y = math.abs(end_loc.y - status.pcTable[status.me].location.y), z = math.abs(end_loc.z - status.pcTable[status.me].location.z)}) end,
        --- nav_priority_input
        function() setAndUpdate(key_order[7], path) end,
        --- sdir
        function() setAndUpdate(key_order[8], move.d_math(status.pcTable[status.me].location,end_loc)) end,
        --- edir
        function() setAndUpdate(key_order[9], move.d_math(end_loc,status.pcTable[status.me].location)) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('static') end
end
function update_dynmc(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.dynmc[key] = value; actions.updateStateValue("dynmc_" .. key, value) end
    local key_order = status.going.dynmc.key_order
    local updates = {
        --- slocn
        function() setAndUpdate(key_order[1], status.pcTable[status.me].location) end,
        --- slocn_nav
        function() setAndUpdate(key_order[2], {x = nil, y = nil, z = nil}) end,
        --- slocn_nav_abs
        function() setAndUpdate(key_order[3], {x = nil, y = nil, z = nil}) end,
        --- elocn
        function() setAndUpdate(key_order[4], nil) end,
        --- elocn_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- elocn_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- dirn
        function() setAndUpdate(key_order[9], nil) end,
        --- sdirn
        function() setAndUpdate(key_order[10], nil) end,
        --- edirn
        function() setAndUpdate(key_order[11], nil) end,
        --- axisn
        function() setAndUpdate(key_order[12], nil) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('dynmc') end
end
function update_fwd(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.fwd[key] = value; actions.updateStateValue("fwd_" .. key, value) end
    local key_order = status.going.fwd.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('fwd') end
end
function update_up(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.up[key] = value; actions.updateStateValue("up_" .. key, value) end
    local key_order = status.going.up.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('up') end
end
function update_dwn(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.dwn[key] = value; actions.updateStateValue("dwn_" .. key, value) end
    local key_order = status.going.dwn.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('dwn') end
end
function update_lft(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.lft[key] = value; actions.updateStateValue("lft_" .. key, value) end
    local key_order = status.going.lft.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('lft') end
end
function update_rit(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.rit[key] = value; actions.updateStateValue("rit_" .. key, value) end
    local key_order = status.going.rit.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('rit') end
end
function update_bck(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.bck[key] = value; actions.updateStateValue("bck_" .. key, value) end
    local key_order = status.going.bck.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then move.print_going_status('bck') end
end
function go_to(end_location, end_orientation, path)
    actions.clear_all_stats()
    sleep(2)
    status.going.endloc = end_location
    move.update_static(end_location, path, false, {})
    move.first_min_max_xyz()
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
        move.update_detect(false,{2,3})                                                     --* 1|total - 4|forward
        move.update_vars(false,{1,3,4,5,6,7,8,9,10,11,12})                                  --+ 2|fls
        return false
    elseif (direction == 'up' and status.detect[direction]()) then
        move.update_detect(false,{3,4})                                                     --* 1|total - 2|up
        move.update_vars(false,{1,3,4,5,6,7,8,9,10,11,12})                                  --+ 2|fls
        return false
    elseif (direction == 'down' and status.detect[direction]()) then
        move.update_detect(false,{2,4})                                                     --* 1|total - 3|down
        move.update_vars(false,{1,3,4,5,6,7,8,9,10,11,12})                                  --+ 2|fls
        return false
    end
    move.move_log(direction)
    move.update_vars(false,{2,4,5,6,7,8,9,10,11,12})                                        --+ 1|tru - 3|go
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
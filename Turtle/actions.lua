pcTable = {}
who_am_i = {
    trtl = false,
    pckt_cmp = false,
    cmd_cmp = false,
    pc_cmp = false,
    my_id = os.getComputerID(),
    my_name = os.getComputerLabel()
}
if turtle then
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
    inspect = {
        forward = turtle.inspect,
        up      = turtle.inspectUp,
        down    = turtle.inspectDown
    }
end
function calibrate_turtle()
    local sx, sy, sz = gps.locate()
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
    turtle.back()
    location = {x = sx, y = sy , z = sz}
    actions.updateStateValue("orientation",orientation)
    actions.updateStateValue("location",location)
    return true
end
function calibrate_pc()
    local nx, ny, nz = gps.locate()
    location = {x = nx, y = ny , z = nz}
    actions.updateStateValue("location",location)
end
function getAllCompData()
    path = "CompData"
    file = fs.open(path, "r")
    actions.pcTable = {}
    if file then
        line = file.readLine()
        while line do
            pcId, dataString = line:match("^%s*%[(%d+)%]%s*=%s*{(.+)}")
            pcId = tonumber(pcId)
            if dataString then
                actions.pcTable[pcId] = actions.pcTable[pcId] or {}
                local restData = dataString:gsub("(%w+) = {%s*([^}]+)%s*}", function(key, nestedData)
                    actions.pcTable[pcId][key] = {}
                    for subKey, subValue in string.gmatch(nestedData, "([%w_]+) = ([^,]+)") do
                        subValue = tonumber(subValue) or subValue:gsub("^'(.*)'$", "%1") or (subValue == 'true' and true or subValue == 'false' and false)
                        actions.pcTable[pcId][key][subKey] = subValue
                    end
                    return ""
                end)
                for key, value in string.gmatch(restData, '([%w_]+) = ([^,]+)') do
                    if value:match("^'.*'$") then
                        value = value:gsub("^'(.*)'$", "%1")
                    elseif value == 'true' or value == 'false' then
                        value = (value == 'true')
                    else
                        value = tonumber(value) or value
                    end
                    actions.pcTable[pcId][key] = value
                end
            end
            line = file.readLine()
        end
        file.close()
    end
end
function updateStateValue(stateKey, newValue)
    local filename = "/state"
    local lines = {}
    local found = false
    local file = fs.open(filename, "r")
    local newValueString
    if type(newValue) == "string" then
        newValueString = "'" .. newValue .. "'"
    elseif type(newValue) == "table" then
        newValueString = "{" .. "x = " .. tostring(newValue.x) .. ", y = " .. tostring(newValue.y) .. ", z = " .. tostring(newValue.z) .. "}"
    else
        newValueString = tostring(newValue)
    end
    if file then
        while true do
            local line = file.readLine()
            if line == nil then break end
            if line:find("^" .. stateKey .. " =") then
                line = stateKey .. " = " .. newValueString
                found = true
            end
            table.insert(lines, line)
        end
        file.close()
    end
    if not found then
        table.insert(lines, stateKey .. " = " .. newValueString)
    end
    file = fs.open(filename, "w")
    if file then
        for _, line in ipairs(lines) do
            file.writeLine(line)
        end
        file.close()
    end
end
function updateCompDataFromState(pcId)
    local path = "state"
    local stateFile = fs.open(path, "r")
    local readData = false
    local stateData = {}
    if stateFile then
        while true do
            local line = stateFile.readLine()
            if line == nil then break end
            if readData then
                local key, value = line:match("^([%w_]+) = (.+)$")
                if key and value then
                    if value:match("^%{.-%}$") or value:match("^'.-'$") or value:match("^%d+$") or value == "true" or value == "false" then
                        stateData[key] = value
                    else
                        stateData[key] = "'" .. value .. "'"
                    end
                end
            elseif line:match("^flag = true$") then
                readData = true
            end
        end
        stateFile.close()
    end
    local compDataPath = "CompData"
    local compFile = fs.open(compDataPath, "r")
    local lines = {}
    local updated = false
    if compFile then
        local line = compFile.readLine()
        while line do
            if line:match("^%s*%[" .. pcId .. "%]") then
                local newData = "    [" .. pcId .. "] = {"
                for key, value in pairs(stateData) do
                    newData = newData .. key .. " = " .. value .. ", "
                end
                newData = newData .. "},"
                line = newData
                updated = true
            end
            table.insert(lines, line)
            line = compFile.readLine()
        end
        compFile.close()
    else
        lines[1] = "    [" .. pcId .. "] = {"
        for key, value in pairs(stateData) do
            lines[#lines + 1] = "        " .. key .. " = " .. value .. ","
        end
        lines[#lines + 1] = "    },"
        updated = true
    end
    if updated then
        local writeFile = fs.open(compDataPath, "w")
        if writeFile then
            for _, line in ipairs(lines) do
                writeFile.writeLine(line)
            end
            writeFile.close()
        end
    end
end
function readStateData()
    local path = "state"
    local file = fs.open(path, "r")
    local readData = false
    local stateData = {}
    if file then
        while true do
            local line = file.readLine()
            if line == nil then break end
            if readData then
                local key, value = line:match("^([%w_]+) = (.+)$")
                if key and value then
                    if value:match("^%{.-%}$") or value:match("^'.-'$") or value:match("^%d+$") or value == "true" or value == "false" then
                        stateData[key] = value
                    else
                        stateData[key] = "'" .. value .. "'"
                    end
                end
            elseif line:match("^flag = true$") then
                readData = true
            end
        end
        file.close()
    end
    return stateData
end
function updateAndBroadcast()
    local pcId = tostring(os.getComputerID())
    local stateData = readStateData()
    updateCompDataFromState(pcId)
    rednet.broadcast('update_me', 'wake_up')
    local broadcastData = stateData
    rednet.broadcast(broadcastData, 'find_me')
end
function a_all_cmd(cmd,id,id2)
    if cmd == 's' then
        rednet.broadcast('s','wake_up')
        os.shutdown()
    elseif cmd == 'r' then
        rednet.broadcast('r','wake_up')
        os.reboot()
    elseif cmd =='o' then
        rednet.send(tonumber(id),id2,'wake_up')
    else
        print("Not recognized")
    end
end
function readCurrentPcData()
    local path = "CompData"
    local file = fs.open(path, "r")
    local currentData = { pc = {} }
    if file then
        local content = file.readAll()
        file.close()
        if content and #content > 0 then
            local deserializedData = textutils.unserialize(content)
            if deserializedData and deserializedData.pc then
                currentData = deserializedData
            end
        end
    end
    return currentData
end
function writeToPcTable(stateData, pcId)
    local path = "CompData"
    local file = fs.open(path, "r")
    local lines = {}
    local foundNewLine = false
    if file then
        local index = 0
        local line = file.readLine()
        while line do
            index = index + 1
            if line:match("newLineStart") then
                foundNewLine = true
                local insertData = "    [" .. pcId .. "] = {"
                for key, value in pairs(stateData) do
                    insertData = insertData .. key .. " = " .. value .. ", "
                end
                insertData = insertData .. "},"
                lines[index] = insertData
                table.insert(lines, index + 1, "    newLineStart")
                index = index + 1
            else
                lines[index] = line
            end
            line = file.readLine()
        end
        file.close()
    end
    if not foundNewLine then
        lines[#lines + 1] = "    [" .. pcId .. "] = {"
        for key, value in pairs(stateData) do
            lines[#lines + 1] = key .. " = " .. value .. ", "
        end
        lines[#lines + 1] = "},"
        lines[#lines + 1] = "    newLineStart"
    end
    file = fs.open(path, "w")
    if file then
        for _, line in ipairs(lines) do
            file.writeLine(line)
        end
        file.close()
    end
end
function updatePcTable(stateData, pcId)
    local path = "CompData"
    local file = fs.open(path, "r")
    local lines = {}
    local updated = false
    if file then
        local line = file.readLine()
        while line do
            if line:match("^%s*%[" .. pcId .. "%]") then
                local newData = "    [" .. pcId .. "] = {"
                for key, value in pairs(stateData) do
                    newData = newData .. key .. " = " .. value .. ", "
                end
                newData = newData .. "},"
                line = newData
                updated = true
            end
            table.insert(lines, line)
            line = file.readLine()
        end
        file.close()
    end
    if updated then
        local file = fs.open(path, "w")
        if file then
            for _, line in ipairs(lines) do
                file.writeLine(line)
            end
            file.close()
        end
    end
    actions.getAllCompData()
end
function face(orientation)
    if actions.pcTable[actions.who_am_i.my_id].orientation == orientation then
        return true
    elseif actions.right_shift[actions.pcTable[actions.who_am_i.my_id].orientation] == orientation then
        if not go('right') then return false end
    elseif actions.left_shift[actions.pcTable[actions.who_am_i.my_id].orientation] == orientation then
        if not go('left') then return false end
    elseif actions.right_shift[actions.right_shift[actions.pcTable[actions.who_am_i.my_id].orientation]] == orientation then
        if not go('right') then return false end
        if not go('right') then return false end
    else
        return false
    end
    return true
end
function log_movement(direction)
    if direction == 'up' then
        actions.pcTable[actions.who_am_i.my_id].location.y = actions.pcTable[actions.who_am_i.my_id].location.y +1
    elseif direction == 'down' then
        actions.pcTable[actions.who_am_i.my_id].location.y = actions.pcTable[actions.who_am_i.my_id].location.y -1
    elseif direction == 'forward' then
        bump = actions.bumps[actions.pcTable[actions.who_am_i.my_id].orientation]
        actions.pcTable[actions.who_am_i.my_id].location = {x = actions.pcTable[actions.who_am_i.my_id].location.x + bump[1], y = actions.pcTable[actions.who_am_i.my_id].location.y + bump[2], z = actions.pcTable[actions.who_am_i.my_id].location.z + bump[3]}
    elseif direction == 'back' then
        bump = actions.bumps[actions.pcTable[actions.who_am_i.my_id].orientation]
        actions.pcTable[actions.who_am_i.my_id].location = {x = actions.pcTable[actions.who_am_i.my_id].location.x - bump[1], y = actions.pcTable[actions.who_am_i.my_id].location.y - bump[2], z = actions.pcTable[actions.who_am_i.my_id].location.z - bump[3]}
    elseif direction == 'left' then
        actions.pcTable[actions.who_am_i.my_id].orientation = actions.left_shift[actions.pcTable[actions.who_am_i.my_id].orientation]
    elseif direction == 'right' then
        actions.pcTable[actions.who_am_i.my_id].orientation = actions.right_shift[actions.pcTable[actions.who_am_i.my_id].orientation]
    end
    return true
end
function go_to_axis(axis, coordinate, nodig)
    local delta = coordinate - actions.pcTable[actions.who_am_i.my_id].location[axis]
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

function no_go()
    if up_check() then
        return true
    elseif left_check() then
        return true
    elseif right_check() then
        return true
    elseif down_check() then
        return true
    end
    return false
end
function up_check()
    local max_count = 0
    up_offset = max_count
    while max_count < 5 do
        if not actions.detect['up']() then
            actions.move['up']()
            actions.log_movement('up')
            if not actions.detect['forward']() then
                actions.move['forward']()
                actions.log_movement('forward')
                return true
            else
                max_count = max_count + 1
                up_offset = max_count
            end
        else
            while up_offset > 0 do
                actions.move['down']()
                actions.log_movement('down')
                up_offset = up_offset - 1
            end
            return false
        end
    end
    while up_offset > 0 do
        actions.move['down']()
        actions.log_movement('down')
        up_offset = up_offset - 1
    end
    return false
end
function down_check()
    local max_count = 0
    
    while max_count < 5 do
        if not actions.detect['down']() then
            actions.move['down']()
            actions.log_movement('down')
            if not actions.detect['forward']() then
                actions.move['forward']()
                actions.log_movement('forward')
                return true
            else
                max_count = max_count + 1
            end
        else
            return false
        end
    end
    return false
end
function left_check()
    local max_count = 0
    left_offset = max_count
    while max_count < 5 do
        actions.move['left']()
        actions.log_movement('left')
        if not actions.detect['forward']() then
            actions.move['forward']()
            actions.log_movement('forward')
            actions.move['right']()
            actions.log_movement('right')
            if not actions.detect['forward']() then
                actions.move['forward']()
                actions.log_movement('forward')
                return true
            else
                max_count = max_count + 1
                left_offset = max_count
            end
        else
            actions.move['right']()
            actions.log_movement('right')
            actions.move['right']()
        actions.log_movement('right')
    while left_offset > 0 do
        actions.move['forward']()
        actions.log_movement('forward')
        left_offset = left_offset - 1
    end
        actions.move['left']()
        actions.log_movement('left')
            return false
        end
    end
    actions.move['right']()
        actions.log_movement('right')
    while left_offset > 0 do
        actions.move['forward']()
        actions.log_movement('forward')
        left_offset = left_offset - 1
    end
        actions.move['left']()
        actions.log_movement('left')
    return false
end
function right_check()
    local max_count = 0
        
    while max_count < 5 do
        actions.move['right']()
        actions.log_movement('right')
        if not actions.detect['forward']() then
            actions.move['forward']()
            actions.log_movement('forward')
            actions.move['left']()
            actions.log_movement('left')
            if not actions.detect['forward']() then
                actions.move['forward']()
                actions.log_movement('forward')
                return true
            else
                max_count = max_count + 1
            end
        else
            actions.move['left']()
            actions.log_movement('left')
            return false
        end
    end
    return false
end
function go(direction, nodig)
        if not actions.move[direction]() then
            return actions.no_go()
        end
    log_movement(direction)
    return true
end
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

function detect_modem()
    succsess, what_is_this = actions.inspect['down']()
    print("I found this: "..what_is_this.name)
    print("waiting for key press")
    os.pullEvent("key")
    if what_is_this.name == "computercraft:computer_advanced" then
        print("is true now waiting for key press")
        actions.move['forward']()
        actions.inspect['down']()
        os.pullEvent("key")
    else
        print("is false. waiting for the key press")
        os.pullEvent("key")
    end
end
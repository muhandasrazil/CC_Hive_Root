
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
    status.pcTable = {}
    if file then
        line = file.readLine()
        while line do
            pcId, dataString = line:match("^%s*%[(%d+)%]%s*=%s*{(.+)}")
            pcId = tonumber(pcId)
            if dataString then
                status.pcTable[pcId] = status.pcTable[pcId] or {}
                local restData = dataString:gsub("(%w+) = {%s*([^}]+)%s*}", function(key, nestedData)
                    status.pcTable[pcId][key] = {}
                    for subKey, subValue in string.gmatch(nestedData, "([%w_]+) = ([^,]+)") do
                        subValue = tonumber(subValue) or subValue:gsub("^'(.*)'$", "%1") or (subValue == 'true' and true or subValue == 'false' and false)
                        status.pcTable[pcId][key][subKey] = subValue
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
                    status.pcTable[pcId][key] = value
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
        if (type(newValue.x) == "string" or type(newValue.y) == "string" or type(newValue.z) == "string") then
            newValueString = "{".."x = ".."'"..tostring(newValue.x).."'"..", y = ".."'"..tostring(newValue.y).."'"..", z = ".."'"..tostring(newValue.z).."'".."}"
        else
            newValueString = "{".."x = "..tostring(newValue.x)..", y = "..tostring(newValue.y)..", z = "..tostring(newValue.z).."}"
        end
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
function detect_modem()
    _, ori = status.inspect['down']()
    if _ then
        return ori.state.facing
    else
        return false
    end
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
function clear_all_stats()
local function update_move(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.stats.move[key] = value actions.updateStateValue("stats_move_" .. key, value) end
    local key_order = status.going.stats.move.key_order
    local updates = {
        function() setAndUpdate(key_order[1], 0) end,
        function() setAndUpdate(key_order[2], 0) end,
        function() setAndUpdate(key_order[3], 0) end,
        function() setAndUpdate(key_order[4], 0) end,
        function() setAndUpdate(key_order[5], 0) end,
        function() setAndUpdate(key_order[6], 0) end,
        function() setAndUpdate(key_order[7], 0) end,
        function() setAndUpdate(key_order[8], 0) end,
        function() setAndUpdate(key_order[9], 0) end,
        function() setAndUpdate(key_order[10], 0) end,
        function() setAndUpdate(key_order[11], 0) end,
        function() setAndUpdate(key_order[12], 0) end,
        function() setAndUpdate(key_order[13], 0) end,
        function() setAndUpdate(key_order[14], 0) end,
        function() setAndUpdate(key_order[15], 0) end,
        function() setAndUpdate(key_order[16], 0) end,
        function() setAndUpdate(key_order[17], 0) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_detect(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.stats.detect[key] = value; actions.updateStateValue("stats_detect_" .. key, value) end
    local key_order = status.going.stats.detect.key_order
    local updates = {
        function() setAndUpdate(key_order[1], 0) end,
        function() setAndUpdate(key_order[2], 0) end,
        function() setAndUpdate(key_order[3], 0) end,
        function() setAndUpdate(key_order[4], 0) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_vars(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.stats.vars[key] = value; actions.updateStateValue("stats_vars_" .. key, value) end
    local key_order = status.going.stats.vars.key_order
    local updates = {
        function() setAndUpdate(key_order[1], 0) end,
        function() setAndUpdate(key_order[2], 0) end,
        function() setAndUpdate(key_order[3], 0) end,
        function() setAndUpdate(key_order[4], 0) end,
        function() setAndUpdate(key_order[5], 0) end,
        function() setAndUpdate(key_order[6], 0) end,
        function() setAndUpdate(key_order[7], 0) end,
        function() setAndUpdate(key_order[8], 0) end,
        function() setAndUpdate(key_order[9], 0) end,
        function() setAndUpdate(key_order[10], 0) end,
        function() setAndUpdate(key_order[11], 0) end,
        function() setAndUpdate(key_order[12], 0) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_static(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.static[key] = value actions.updateStateValue("static_" .. key, value) end
    local key_order = status.going.static.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[4], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], nil) end,
        function() setAndUpdate(key_order[8], nil) end,
        function() setAndUpdate(key_order[9], nil) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end

local function update_dynmc(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.dynmc[key] = value; actions.updateStateValue("dynmc_" .. key, value) end
    local key_order = status.going.dynmc.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[3], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], nil) end,
        function() setAndUpdate(key_order[10], nil) end,
        function() setAndUpdate(key_order[11], nil) end,
        function() setAndUpdate(key_order[12], nil) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_fwd(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.fwd[key] = value; actions.updateStateValue("fwd_" .. key, value) end
    local key_order = status.going.fwd.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], nil) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[15], nil) end,
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[18], nil) end,
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[21], nil) end,
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[24], nil) end,
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_up(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.up[key] = value; actions.updateStateValue("up_" .. key, value) end
    local key_order = status.going.up.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], nil) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[15], nil) end,
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[18], nil) end,
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[21], nil) end,
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[24], nil) end,
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_dwn(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.dwn[key] = value; actions.updateStateValue("dwn_" .. key, value) end
    local key_order = status.going.dwn.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], nil) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[15], nil) end,
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[18], nil) end,
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[21], nil) end,
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[24], nil) end,
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_lft(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.lft[key] = value; actions.updateStateValue("lft_" .. key, value) end
    local key_order = status.going.lft.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], nil) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[15], nil) end,
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[18], nil) end,
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[21], nil) end,
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[24], nil) end,
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_rit(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.rit[key] = value; actions.updateStateValue("rit_" .. key, value) end
    local key_order = status.going.rit.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], nil) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[15], nil) end,
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[18], nil) end,
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[21], nil) end,
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[24], nil) end,
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
local function update_bck(skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) status.going.bck[key] = value; actions.updateStateValue("bck_" .. key, value) end
    local key_order = status.going.bck.key_order
    local updates = {
        function() setAndUpdate(key_order[1], nil) end,
        function() setAndUpdate(key_order[2], nil) end,
        function() setAndUpdate(key_order[3], nil) end,
        function() setAndUpdate(key_order[4], nil) end,
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[15], nil) end,
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[18], nil) end,
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[21], nil) end,
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[24], nil) end,
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
end
update_move({})
update_detect({})
update_vars({})
update_static({})
--update_dynmc({})
--update_fwd({})
--update_up({})
--update_dwn({})
--update_lft({})
--update_rit({})
--update_bck({})
end
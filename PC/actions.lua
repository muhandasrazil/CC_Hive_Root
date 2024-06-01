
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

local function readStateData()
    local path = "state.lua"
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
    else
        print("Error: Unable to read state file.")
    end
    return stateData
end
local function readCurrentPcData()
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
local function writeToPcTable(stateData, pcId)
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
    else
        print("Error: Unable to write to CompData file.")
    end
end
local function broadcastData(stateData)
    local serializedData = textutils.serialize(stateData)
    rednet.broadcast(serializedData, 'find_me')
    print("Broadcasted: " .. serializedData)
end
local function isSenderIdInPcTable(senderId)
    local path = "CompData"
    local file = fs.open(path, "r")
    local senderIdNum = tonumber(senderId)
    if file then
        while true do
            local line = file.readLine()
            if not line then break end
            if line:match("%[" .. senderIdNum .. "%]") then
                file.close()
                return true
            end
        end
        file.close()
    else
        print("Error: Unable to open CompData file for reading.")
    end
    return false
end
function waitForWakeUp()
    while true do
        local senderId, message, protocol = rednet.receive('wake_up')
        if message == 'wake_up' then
            print("Received wake_up message. Restarting get_info loop.")
            get_info()
        end
    end
end
local my_self_id = tostring(os.getComputerID())
function get_info()
    timeout_count = 0
    local increment_counter = 3
    while timeout_count < increment_counter do
        local senderId, message, protocol = rednet.receive('find_me', 2)
        if not senderId then
            print("Timeout " .. timeout_count)
            if timeout_count >= increment_counter then
                print("now waiting for new responses")
                break
            end
            broadcastOwnState()
            timeout_count = timeout_count + 1
        else
            local receivedData = textutils.unserialize(message)
            if receivedData.my_id == my_self_id then
                print("Ignoring own broadcast")
            else
                term.clear()
                term.setCursorPos(1,1)
                print("Timeout " .. timeout_count)
                handleReceivedData(senderId, receivedData)
            end
        end
    end
    term.clear()
    term.setCursorPos(1,1)
    print("now waiting for new responses")
end
function broadcastOwnState()
    local stateData = readStateData()
    local dataToSend = textutils.serialize(stateData)
    rednet.broadcast(dataToSend, 'find_me')
end
function handleReceivedData(senderId, receivedData)
    if isSenderIdInPcTable(senderId) then
        print("Known sender ID: " .. senderId .. ", forwarding...")
        forwardToOthers(senderId, receivedData)
    else
        print("Unknown sender ID: " .. senderId .. ", adding new entry...")
        writeToPcTable(receivedData, senderId)
        timeout_count = 0
    end
end
function forwardToOthers(senderId, data)
    local dataToSend = textutils.serialize(data)
    for id in pairs(readCurrentPcData().pc) do
        if id ~= senderId and id ~= my_self_id then
            rednet.send(tonumber(id), dataToSend, 'find_me')
            print("Forwarding to ID: " .. id)
        end
    end
end
if not isSenderIdInPcTable(my_self_id) then
    local stateData = readStateData()
    writeToPcTable(stateData, stateData.my_id)
    rednet.broadcast('wake_up','wake_up')
    sleep(0.5)
    broadcastData(stateData)
end
get_info()
waitForWakeUp()
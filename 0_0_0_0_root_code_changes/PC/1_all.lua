function processFile()
    local path = "state.lua"
    local file = fs.open(path, "r")
    local content = file.readAll()
    file.close()

    -- Perform replacements
    content = content:gsub("''", "'")
    content = content:gsub("'{", "{")
    content = content:gsub("}'", "}")

    -- Write the updated content back to the file
    file = fs.open(path, "w")
    file.write(content)
    file.close()
end
-- Custom function to format table entries appropriately for Lua
local function customSerialize(table)
    local str = "{"
    for k, v in pairs(table) do
        if type(v) == "table" then
            v = customSerialize(v)  -- Recursive call for nested tables
        elseif type(v) == "string" then
            -- Add single quotes only if the string contains spaces or non-word characters
            if v:match("[^%w_]") then
                v = "'" .. v .. "'"  -- Enclose in single quotes
            end
        elseif type(v) == "boolean" or type(v) == "number" then
            v = tostring(v)  -- Handle booleans and numbers as plain text
        end
        str = str .. k .. " = " .. v .. ", "
    end
    str = str:sub(1, -3)  -- Remove the last comma and space
    str = str .. "}"
    return str
end

-- Function to parse the state.lua file to find the pc table's position
local function parseStateFile()
    local path = "state.lua"
    local file = fs.open(path, "r")
    local lines = {}
    local pcTableExists = false
    local pcTableStartIndex, pcTableEndIndex = nil, nil

    if file then
        while true do
            local line = file.readLine()
            if line == nil then break end
            table.insert(lines, line)

            if line:match("^pc = {") then
                pcTableExists = true
                pcTableStartIndex = #lines
            elseif line:match("^}") and pcTableExists and not pcTableEndIndex then
                pcTableEndIndex = #lines
            end
        end
        file.close()
    else
        print("Error: Unable to open the state file for reading.")
    end

    return lines, pcTableExists, pcTableStartIndex, pcTableEndIndex
end

-- Function to update the pc table in state.lua
local function updatePcTable(senderId, receivedData)
    local lines, pcExists, startIndex, endIndex = parseStateFile()
    local formattedData = customSerialize(receivedData)
    local found = false

    if pcExists then
        for i = startIndex + 1, endIndex - 1 do
            if lines[i]:match("%[" .. senderId .. "%]") then
                found = true
                break
            end
        end

        if not found then
            table.insert(lines, endIndex, "    [" .. senderId .. "] = " .. formattedData .. ",")
            local file = fs.open("state.lua", "w")
            if file then
                for _, line in ipairs(lines) do
                    file.writeLine(line)
                end
                file.close()
            else
                print("Error: Unable to open the state file for writing.")
            end
        end
    else
        print("pc table does not exist in the file.")
    end
    processFile()
end

-- Function to parse lines and convert to table format
local function parseToTable(line)
    local key, value = line:match("^([%w_]+) = (.+)$")
    if key and value then
        if value:match("^%{.-%}$") or value:match("^'.-'$") or value:match("^%d+$") or value == "true" or value == "false" then
            return key, value
        else
            return key, "'" .. value .. "'"
        end
    end
    return nil
end

-- Function to read state from state.lua
local function readStateFromFile()
    local path = "state.lua"
    local file = fs.open(path, "r")
    local stateData = {}

    if file then
        local startProcessing = false
        while true do
            local line = file.readLine()
            if line == nil then break end
            if startProcessing then
                local key, value = parseToTable(line)
                if key then
                    stateData[key] = value
                end
            elseif line:match("^flag = true$") then
                startProcessing = true
            end
        end
        file.close()
        return stateData
    else
        print("Error: Unable to read state file.")
        return nil
    end
end
local function checkPcForId19(valueidcheck)
    local path = "state.lua"
    local file = fs.open(path, "r")
    local pcTableExists = false
    local foundId19 = false
    if file then
        while true do
            local line = file.readLine()
            if line == nil then break end
            if line:match("^pc = {") then
                pcTableExists = true
            elseif line:match("^}") and pcTableExists then
                break
            elseif pcTableExists and line:match("%["..valueidcheck.."%]") then
                foundId19 = true
            end
        end
        file.close()
    end
    return foundId19
end

my_self_id = tostring(os.getComputerID())
function get_info()
    while true do
        local skipProcessing = false
        local senderId, message, broadcast = rednet.receive('find_me',5)
            if not senderId then
                local stateData = readStateFromFile()
                local dataToSend = textutils.serialize(stateData)
                sleep(1)
                rednet.broadcast(dataToSend, 'find_me')
                term.clear()
                term.setCursorPos(1,1)
                print("No new entries")
            else
                local receivedData = textutils.unserialize(message)
                if receivedData.my_id == my_self_id  then
                    term.clear()
                    term.setCursorPos(1,1)
                    print("No new messages")
                    skipProcessing = true
                    sleep(3)
                end
                if not skipProcessing then
            local i_found_u = checkPcForId19(senderId)
                if i_found_u then
                    rednet.broadcast(message,'find_me')
                    term.clear()
                    term.setCursorPos(1,1)
                    print("Entry found passing on")
                    sleep(1)
                else
                    local receivedData = textutils.unserialize(message)
                    updatePcTable(tostring(senderId), receivedData)
                    local stateData = readStateFromFile()
                    local dataToSend = textutils.serialize(stateData)
                    sleep(2)
                    rednet.send(senderId, dataToSend, 'find_me')
                    term.clear()
                    term.setCursorPos(1,1)
                    print("New Entry Found")
                end
            end
        end
    end
end

get_info()
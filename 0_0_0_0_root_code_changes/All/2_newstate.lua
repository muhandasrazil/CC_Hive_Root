local function readAllStateData()
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
    else
        print("Error: Unable to read state file.")
    end
    return stateData
end
function saveState(stateKey, newValue)
    local filename = "/state"
    local lines = {}
    local found = false
    local file = fs.open(filename, "r")
    if file then
        while true do
            local line = file.readLine()
            if line == nil then break end
            if line:find("^" .. stateKey .. " =") then
                line = stateKey .. " = " .. tostring(newValue)
                found = true
            end
            table.insert(lines, line)
        end
        file.close()
    end
    if not found then
        table.insert(lines, stateKey .. " = " .. tostring(newValue))
    end
    file = fs.open(filename, "w")
    if file then
        for _, line in ipairs(lines) do
            file.writeLine(line)
        end
        file.close()
    else
        print("Error: Unable to write to state file.")
    end
end
local function updateCompData(pcId, stateData)
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
                    newData = newData .. key .. " = " .. tostring(value) .. ", "
                end
                newData = newData .. "},"
                line = newData
                updated = true
            end
            table.insert(lines, line)
            line = file.readLine()
        end
        file.close()
    else
        lines[1] = "    [" .. pcId .. "] = {"
        for key, value in pairs(stateData) do
            table.insert(lines, "        " .. key .. " = " .. tostring(value) .. ",")
        end
        table.insert(lines, "    },")
        updated = true
    end
    if updated then
        local file = fs.open(path, "w")
        if file then
            for _, line in ipairs(lines) do
                file.writeLine(line)
            end
            file.close()
        else
            print("Error: Unable to write to CompData file.")
        end
    end
end
local function findAllIdsAndPrint()
    local path = "CompData"
    local file = fs.open(path, "r")
    local idsFound = {}
    local stateData = readAllStateData()
    if file then
        while true do
            local line = file.readLine()
            if not line then break end
            for id in line:gmatch("%[(%d+)%]") do
                if not idsFound[id] then
                    idsFound[id] = true
                    print(id)
                    rednet.send(tonumber(id),'update_me', 'wake_up')
                    rednet.send(tonumber(id), stateData, 'find_me')
                end
            end
        end
        file.close()
    else
        print("Error: Unable to read from CompData file.")
    end
end
local test = 'test'
saveState(test, "helloworld")
local pcId = tostring(os.getComputerID())
local stateData = readAllStateData()
updateCompData(pcId, stateData)
findAllIdsAndPrint()
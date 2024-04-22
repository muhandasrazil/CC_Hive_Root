-- SET LABEL
os.setComputerLabel('PC '.. os.getComputerID())

local me = os.getComputerID()
sleep((1+me)/10)

shell.run("state_check.lua")

-- INITIALIZE APIS
if fs.exists('/apis') then
    fs.delete('/apis')
end
fs.makeDir('/apis')
--fs.copy('/network.lua', '/apis/network')
fs.copy('/state.lua', '/apis/state')
--os.loadAPI('/apis/network')
os.loadAPI('/apis/state')


-- OPEN REDNET
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end

-- LAUNCH PROGRAMS AS SEPARATE THREADS
--multishell.launch({}, '/find_me.lua')
--multishell.setTitle(2, 'find_me')
--multishell.launch({}, '/who_are_you.lua')
--multishell.setTitle(3, 'whoru')
multishell.launch({}, '/1_all.lua')
multishell.setTitle(2, 'all')

--sleep(2)
--my_loc_val = {x = state.location.x, y = state.location.y, z = state.location.z}
--rednet.broadcast(my_loc_val,'find_me')

sleep(2)
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
--my_loc_val = {x = state.location.x, y = state.location.y, z = state.location.z}
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
local stateData = readStateFromFile()
local dataToSend = textutils.serialize(stateData)
rednet.broadcast(dataToSend,'find_me')
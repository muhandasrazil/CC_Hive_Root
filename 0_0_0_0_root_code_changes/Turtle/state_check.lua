id = os.getComputerID()

who_am_i = {
    trtl = false,
    pckt_cmp = false,
    cmd_cmp = false,
    pc_cmp = false,
    my_id = id,
    my_name = "'" .. os.getComputerLabel() .. "'"
}

    if turtle then
        who_am_i.trtl = true
    elseif pocket then
        who_am_i.pckt_cmp = true
    elseif commands then
        who_am_i.cmd_cmp = true
    else
        who_am_i.pc_cmp = true
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
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end

for key, v in pairs(who_am_i) do

    saveState(key,v)
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
    orientation = "'" .. orientation .. "'"

    turtle.back()
    location = string.format("{x = %s, y = %s, z = %s}", nx, ny ,nz)
    saveState("orientation",orientation)
    saveState("location",location)
    return true
end

function calibrate_pc()
    local nx, ny, nz = gps.locate()
    location = string.format("{x = %s, y = %s, z = %s}", nx, ny ,nz)
    saveState("location",location)
end

function gps_on_check()
    local sx, sy, sz = gps.locate()
    if not sx or not sy or not sz then
        print("no gps found retaining location info")
        return false
    else
        if who_am_i.trtl then
            calibrate_turtle()
        else
            calibrate_pc()
        end
    end
end

gps_on_check()
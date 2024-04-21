function str_xyz(coords, facing)
    if facing then
        return coords.x .. ',' .. coords.y .. ',' .. coords.z .. ':' .. facing
    else
        return coords.x .. ',' .. coords.y .. ',' .. coords.z
    end
end


function saveState(stateKey, newValue)
    local filename = "/state.lua"
    local lines = {}
    local found = false

    -- Open the file for reading
    local file = fs.open(filename, "r")
    if file then
        -- Read all lines and update as necessary
        while true do
            local line = file.readLine()
            if line == nil then break end
            if line:find("^" .. stateKey .. " =") then
                line = stateKey .. " = " .. newValue  -- Update the line
                found = true
            end
            table.insert(lines, line)
        end
        file.close()
    end

    -- If the orientation line was not found, add it
    if not found then
        table.insert(lines, stateKey .. " = " .. newValue)
    end

    -- Open the file for writing and write all lines
    file = fs.open(filename, "w")
    for _, line in ipairs(lines) do
        file.writeLine(line)
    end
    file.close()
end




function calibrate()
    local sx, sy, sz = gps.locate()
    if not sx or not sy or not sz then
        return false
    end
    for i = 1, 4 do
        if not turtle.detect() then
            break
        end
        if not turtle.turnRight() then return false end
    end
    if turtle.detect() then
        for i = 1, 4 do
            safedig('forward')
            if not turtle.detect() then
                break
            end
            if not turtle.turnRight() then return false end
        end
        if turtle.detect() then
            return false
        end
    end
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
    location = {x = nx, y = ny, z = nz}
    saveState("orientation",orientation)
    saveState("location",location)
    return true
end

calibrate()
function saveTableState(id, value)
    local filename = "/state.lua"
    local lines = {}
    local pcTable = {}
    local pc_started = false
    local flag_found = false
    local file = fs.open(filename, "r")
    
    if file then
        -- Read all lines and modify or retain as necessary
        while true do
            local line = file.readLine()
            if line == nil then break end
            
            if line:find("^pc = {") then
                pc_started = true
            elseif line:find("^}") and pc_started then
                -- When reaching the end of the pc table, stop adding to pcTable
                pc_started = false
            elseif pc_started then
                -- Collect existing pc entries
                local key, val = line:match("%[([%d]+)%]%s*=%s*{([^}]*)}")
                if key and val then
                    pcTable[tonumber(key)] = val:gsub("\"", "") -- remove quotes for consistency
                end
            elseif line:find("^flag =") then
                flag_found = true
                -- Process all pc entries before writing flag
                lines[#lines + 1] = "pc = {"
                pcTable[id] = value -- add or update the new entry
                for k, v in pairs(pcTable) do
                    lines[#lines + 1] = "    [" .. tostring(k) .. "] = {" .. v .. "},"
                end
                lines[#lines + 1] = "}"
                lines[#lines + 1] = line
            else
                lines[#lines + 1] = line
            end
        end
        file.close()
    end

    -- Handle case where no pc or flag was found
    if not pc_started and not flag_found then
        lines[#lines + 1] = "pc = {"
        pcTable[id] = value
        for k, v in pairs(pcTable) do
            lines[#lines + 1] = "    [" .. tostring(k) .. "] = {" .. v .. "},"
        end
        lines[#lines + 1] = "}"
        lines[#lines + 1] = "flag = true"
    end

    -- Write back to the file
    file = fs.open(filename, "w")
    if file then
        for _, line in ipairs(lines) do
            file.writeLine(line)
        end
        file.close()
    else
        print("Error: Unable to open file for writing.")
    end
end

function find_me_ping()
    while true do
    senderid,message,broadcast = rednet.receive('find_me')
    if state.pc[senderid] == nil then
    xyz_str = "x = "..message.x..", y = "..message.y..", z = "..message.z
    saveTableState(senderid,xyz_str)
    state.pc[senderid] = message
    else
    end
    term.clear()
    term.setCursorPos(1,1)
    for id, loc in pairs(state.pc) do
        print(id.. " = {x = "..loc.x..", y = "..loc.y..", z = "..loc.z.."}")
    end


    sleep(2)
    my_loc_val = {x = state.location.x, y = state.location.y, z = state.location.z}
    rednet.broadcast(rednet.broadcast(my_loc_val,'find_me'))
end
end

find_me_ping()
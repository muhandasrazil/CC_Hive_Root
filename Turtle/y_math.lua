self_id = os.getComputerID()
og_location = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
og_orientation = actions.pcTable[self_id].orientation
-- Step 1: Extract and sort IDs
local ids = {}
for id in pairs(actions.pcTable) do
    table.insert(ids, id)
end
table.sort(ids)
for id, pc in ipairs(ids) do
    term.write(pc .. " ")
end
sleep(1.2)
-- Step 2: Using sorted IDs to maintain functionalities
for _, id in ipairs(ids) do
    local pc = actions.pcTable[id]
    if pc.pc_cmp then
        if pc.orientation then
            print("PC: " .. id .. " is: " .. pc.orientation)
        else
            local target_location = {x = pc.location.x, y = pc.location.y + 1, z = pc.location.z}
            local target_orientation = pc.orientation
            local self_loc = actions.pcTable[os.getComputerID()].location
            local nav_priority = actions.nav_priority(self_loc, target_location)
            actions.go_to(target_location, target_orientation, nav_priority, target_location)
            actions.detect_modem()
            actions.calibrate_turtle()
            actions.updateAndBroadcast()
            actions.a_all_cmd('o', id, os.getComputerID())
        end
    end
end

trtl_loc = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
trtl_ori = actions.pcTable[self_id].orientation
nav_priority = actions.nav_priority(trtl_loc,og_location)
actions.go_to(og_location,og_orientation,nav_priority,og_location)
actions.calibrate_turtle()
actions.updateAndBroadcast()
term.clear()
term.setCursorPos(1,1)
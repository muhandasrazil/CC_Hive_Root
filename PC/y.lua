self_id = os.getComputerID()
og_location = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
og_orientation = actions.pcTable[self_id].orientation
local ids = {}
for id in pairs(actions.pcTable) do
    table.insert(ids, id)
end
table.sort(ids)
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
            actions.go_to(target_location, target_orientation, nav_priority)
            ori_data_collect = actions.detect_modem()
            actions.calibrate_turtle()
            actions.updateAndBroadcast()
            actions.a_all_cmd('o', id, ori_data_collect)
        end
    end
end
sleep(2)
actions.calibrate_turtle()
actions.updateAndBroadcast()
sleep(.2)
trtl_loc = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
trtl_ori = actions.pcTable[self_id].orientation
nav_priority = actions.nav_priority(trtl_loc,og_location)
print(nav_priority)
actions.go_to(og_location,og_orientation,nav_priority)
actions.calibrate_turtle()
actions.updateAndBroadcast()
term.clear()
term.setCursorPos(1,1)
term.clear()
term.setCursorPos(1,1)
actions.getAllCompData()
print("Type PC ID you want distance data for:")
for id, pc in pairs(actions.pcTable) do
    term.write(id .. " ")
end



trtl_loc = {x = actions.pcTable[17].location.x, y = actions.pcTable[17].location.y, z = actions.pcTable[17].location.z}
trtl_ori = actions.pcTable[17].orientation



self_id = os.getComputerID()
og_location = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
og_orientation = actions.pcTable[self_id].orientation
for id, pc in pairs(actions.pcTable) do
    
    if pc.pc_cmp then
        if pc.orientation then
            print("PC: " .. id .. " is: " .. pc.orientation)
        else
            local target_location = {x = pc.location.x, y = pc.location.y + 1, z = pc.location.z}
            local target_orientation = pc.orientation
            
            nav_priority = actions.nav_priority({x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z},target_location)
            actions.go_to(target_location,target_orientation,nav_priority,target_location)
            actions.detect_modem()
            actions.calibrate_turtle()
            actions.updateAndBroadcast()
            actions.a_all_cmd('o', id, self_id)
        end
    end
end
nav_priority = actions.nav_priority({x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z},trtl_loc)
actions.go_to(trtl_loc,trtl_ori,nav_priority,trtl_loc)
actions.calibrate_turtle()
actions.updateAndBroadcast()
term.clear()
term.setCursorPos(1,1)

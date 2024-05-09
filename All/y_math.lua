term.clear()
term.setCursorPos(1,1)
actions.getAllCompData()
print("Type PC ID you want distance data for:")
for id, pc in pairs(actions.pcTable) do
    term.write(id .. " ")
end
term.setCursorPos(1,3)
pc_selected = tonumber(read())
print("calibrate pc orientation? y/n")
usr_go = read()
term.clear()
term.setCursorPos(1,1)


trtl_loc = {x = actions.pcTable[17].location.x, y = actions.pcTable[17].location.y, z = actions.pcTable[17].location.z}
pc_loc = {x = actions.pcTable[pc_selected].location.x, y = actions.pcTable[pc_selected].location.y, z = actions.pcTable[pc_selected].location.z}
trtl_ori = actions.pcTable[17].orientation
pc_ori = actions.pcTable[pc_selected].orientation

dist_x = math.abs(trtl_loc.x - pc_loc.x)
dist_y = pc_loc.y - trtl_loc.y
dist_z = math.abs(trtl_loc.z - pc_loc.z)

print(trtl_loc.x,trtl_loc.y,trtl_loc.z)
print(pc_loc.x,pc_loc.y,pc_loc.z)
print("x: "..dist_x.." y: "..dist_y.." z: "..dist_z)
nav_priority = actions.nav_priority(trtl_loc,pc_loc)
print("Navigation priority: ".. nav_priority)

if usr_go == 'y' then
    term.clear()
    term.setCursorPos(1,1)
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
                actions.go_to(target_location,target_orientation,nav_priority,true)
                actions.detect_modem()
                actions.calibrate_turtle()
                actions.updateAndBroadcast()
                actions.a_all_cmd('o', id, self_id)
            end
        end
    end
    nav_priority = actions.nav_priority({x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z},trtl_loc)
    actions.go_to(trtl_loc,trtl_ori,nav_priority,true)
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
end
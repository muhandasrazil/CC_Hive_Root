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
print("Send turtule back to start point? y/n")
trtl_return = read()
term.clear()
term.setCursorPos(1,1)


trtl_loc = {x = actions.pcTable[17].location.x, y = actions.pcTable[17].location.y, z = actions.pcTable[17].location.z}
pc_loc = {x = actions.pcTable[pc_selected].location.x, y = actions.pcTable[pc_selected].location.y, z = actions.pcTable[pc_selected].location.z}
trtl_ori = actions.pcTable[17].orientation
pc_ori = actions.pcTable[pc_selected].orientation
xyz_priority = 'xyz'
dist_pc = {}


function dist_output()
    dist_x = math.abs(math.max(trtl_loc.x,pc_loc.x)-math.min(trtl_loc.x,pc_loc.x))
    dist_y = math.abs(math.max(trtl_loc.y,pc_loc.y)-math.min(trtl_loc.y,pc_loc.y))
    dist_z = math.abs(math.max(trtl_loc.z,pc_loc.z)-math.min(trtl_loc.z,pc_loc.z))
    dist_pc = {x = dist_x, y = dist_y, z = dist_z}
end
dist_output()



print(trtl_loc.x,trtl_loc.y,trtl_loc.z)
print(pc_loc.x,pc_loc.y,pc_loc.z)
print("x: "..dist_pc.x.." y: "..dist_pc.y.." z: "..dist_pc.z)


nav_priority = actions.nav_priority(dist_x,dist_y,dist_z)

print("Navigation priority:")
print(nav_priority)

if dist_x >= dist_z then
    xyz_priority = 'zxy'
else
    xyz_priority = 'xzy'
end



if usr_go == 'y' then
    term.clear()
    term.setCursorPos(1,1)
    self_id = os.getComputerID()
    og_location = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
    og_orientation = actions.pcTable[self_id].orientation
    global_path = 'xzy'
    for id, pc in pairs(actions.pcTable) do
        if pc.pc_cmp then
            if pc.orientation then
                print("Orientation for PC ID " .. id .. " is already set to " .. pc.orientation)
            else
                local target_location = {x = pc.location.x, y = pc.location.y + 1, z = pc.location.z}
                local target_orientation = pc.orientation
                actions.go_to(target_location,target_orientation,'xyz',true)
                actions.detect_modem()
                actions.calibrate_turtle()
                actions.updateAndBroadcast()
                actions.a_all_cmd('o', id, self_id)
            end
        end
    end
end


if trtl_return == 'y' then
    actions.go_to(trtl_loc,trtl_ori,'zyx',true)
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
else
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
end
print("done!")
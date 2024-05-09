actions.getAllCompData()
print("select PC")
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


if dist_x >= dist_z then
    xyz_priority = 'zxy'
else
    xyz_priority = 'xzy'
end
print(xyz_priority)


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
                local function elevate_to(target_y)
                    while actions.pcTable[self_id]. location.y < target_y do
                        turtle.up()
                        actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y + 1
                        if actions.pcTable[self_id].location.y > 256 then break end
                    end
                end
                elevate_to(target_location.y + 3)
                if actions.go_to_axis('x', target_location.x, true) and actions.go_to_axis('z', target_location.z, true) then
                    elevate_to(target_location.y)
                    while actions.pcTable[self_id].location.y > target_location.y do
                        turtle.down()
                        actions.pcTable[self_id].location.y = actions.pcTable[self_id].location.y - 1
                    end
                    global_orientation = actions.detect_modem()
                    sleep(1)
                    local ax, ay, az = gps.locate()
                    local current_pos = {x = ax, y = ay, z = az}
                    actions.updateStateValue("location", current_pos)
                    actions.updateStateValue("orientation", global_orientation)
                    actions.updateAndBroadcast()
                    actions.a_all_cmd('o', id, self_id)
                    if global_orientation == 'north' then
                        global_path = 'xzy'
                    elseif global_orientation == 'south' then
                        global_path = 'xzy'
                    elseif global_orientation == 'east' then
                        global_path = 'zxy'
                    elseif global_orientation == 'west' then
                        global_path = 'zxy'
                    else
                        global_path = 'xzy'
                    end
                end
            end
        end
    end
end


if trtl_return == 'y' then
    actions.go_to(trtl_loc,trtl_ori,'xyz',true)
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
else
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
end
print("done!")
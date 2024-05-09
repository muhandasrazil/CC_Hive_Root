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
print(global_path)
actions.go_to(og_location,og_orientation,global_path,true)
actions.calibrate_turtle()
actions.updateAndBroadcast()
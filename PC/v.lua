self_id = os.getComputerID()
og_location = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
og_orientation = actions.pcTable[self_id].orientation
new_location = {x = actions.pcTable[self_id].location.x+10, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z-10}
new_orientation = 'west'
new_location_2 = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y+5, z = actions.pcTable[self_id].location.z}
new_orientation_2 = 'east'

function new_2_go()
nav_priority = actions.nav_priority(og_location,new_location_2)
actions.go_to(new_location_2,new_orientation_2,'yxzxzxzy')
actions.calibrate_turtle()
actions.updateAndBroadcast()
sleep(1)
end


function new_go()
nav_priority = actions.nav_priority(og_location,new_location)
actions.go_to(new_location,new_orientation,'xzxzxzy')
actions.calibrate_turtle()
actions.updateAndBroadcast()
end

function return_go()
if actions.detect['forward']() then
    actions.move_log('back')
    actions.move_log('back')
    actions.move_log('back')
end
actions.go_to(og_location,og_orientation,'xzxzxzy')
actions.calibrate_turtle()
actions.updateAndBroadcast()
end

--new_2_go()
new_go()
return_go()

term.clear()
term.setCursorPos(1,1)
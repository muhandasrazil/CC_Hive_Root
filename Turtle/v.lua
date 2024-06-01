self_id = os.getComputerID()
og_location = {x = status.pcTable[self_id].location.x, y = status.pcTable[self_id].location.y, z = status.pcTable[self_id].location.z}
og_orientation = status.pcTable[self_id].orientation
new_location = {x = status.pcTable[self_id].location.x+6, y = status.pcTable[self_id].location.y-5, z = status.pcTable[self_id].location.z-10}
new_orientation = 'west'
new_location_2 = {x = status.pcTable[self_id].location.x+10, y = status.pcTable[self_id].location.y+5, z = status.pcTable[self_id].location.z+2}
new_orientation_2 = 'east'

function new_2_go()
move.move_log('right')
move.move_log('right')
nav_priority = move.nav_priority(og_location,new_location_2)
move.go_to(new_location_2,new_orientation_2,nav_priority)
actions.calibrate_turtle()
actions.updateAndBroadcast()
sleep(1)
end


function new_go()
nav_priority = move.nav_priority(og_location,new_location)
move.go_to(new_location,new_orientation,'xzy')
actions.calibrate_turtle()
actions.updateAndBroadcast()
end

function return_go()
if status.detect['forward']() then
    move.move_log('back')
    move.move_log('back')
    move.move_log('back')
end
nav_priority = move.nav_priority(new_location,og_location)
move.go_to(og_location,og_orientation,'xyz')
actions.calibrate_turtle()
actions.updateAndBroadcast()
end

--new_2_go()
new_go()
return_go()

term.clear()
term.setCursorPos(1,1)
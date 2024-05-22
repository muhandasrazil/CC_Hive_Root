self_id = os.getComputerID()
og_location = {x = actions.pcTable[self_id].location.x, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z}
og_orientation = actions.pcTable[self_id].orientation

new_location = {x = actions.pcTable[self_id].location.x+5, y = actions.pcTable[self_id].location.y, z = actions.pcTable[self_id].location.z+5}
new_orientation = 'north'

nav_priority = actions.nav_priority(og_location,new_location)

actions.go_to(new_location,new_orientation,'yzxzxzxzxy')
actions.calibrate_turtle()
actions.updateAndBroadcast()
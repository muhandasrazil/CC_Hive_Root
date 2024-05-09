term.clear()
term.setCursorPos(1,1)
actions.getAllCompData()
print("Select target location:")
for id, pc in pairs(actions.pcTable) do
    term.write(id .. " ")
end
term.setCursorPos(1,3)
go_dest = tonumber(read())
trtl_loc = {x = -190, y = 63, z = 247}
pc_loc = {x = actions.pcTable[go_dest].location.x, y = actions.pcTable[go_dest].location.y+1, z = actions.pcTable[go_dest].location.z}
trtl_ori = 'south'
pc_ori = actions.pcTable[go_dest].orientation
xyz_priority = 'xyz'
dist_pc = {}
if go_dest == 17 then
    print("going to: "..trtl_loc.x..", "..trtl_loc.y..", "..trtl_loc.z)
    actions.go_to(trtl_loc,trtl_ori,xyz_priority,true)
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
else
    print("going to: "..pc_loc.x..", "..pc_loc.y..", "..pc_loc.z)
    actions.go_to(pc_loc,pc_ori,xyz_priority,true)
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
end
term.clear()
term.setCursorPos(1,1)
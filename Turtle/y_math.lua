bumps = {
    north = { 0,  0, -1},
    south = { 0,  0,  1},
    east  = { 1,  0,  0},
    west  = {-1,  0,  0},
}

print("select PC")
pc_selected = tonumber(read())
term.clear()
term.setCursorPos(1,1)

actions.getAllCompData()

trtl_loc = {x = actions.pcTable[17].location.x, y = actions.pcTable[17].location.y, z = actions.pcTable[17].location.z}
pc_loc = {x = actions.pcTable[pc_selected].location.x, y = actions.pcTable[pc_selected].location.y, z = actions.pcTable[pc_selected].location.z}
trtl_ori = actions.pcTable[17].orientation
pc_ori = actions.pcTable[pc_selected].orientation
xyz_priority = 'xyz'

print(trtl_loc.x,trtl_loc.y,trtl_loc.z)
print(pc_loc.x,pc_loc.y,pc_loc.z)
dist_x = math.abs(math.max(trtl_loc.x,pc_loc.x)-math.min(trtl_loc.x,pc_loc.x))
dist_y = math.abs(math.max(trtl_loc.y,pc_loc.y)-math.min(trtl_loc.y,pc_loc.y))
dist_z = math.abs(math.max(trtl_loc.z,pc_loc.z)-math.min(trtl_loc.z,pc_loc.z))

print("x: "..dist_x.." y: "..dist_y.." z: "..dist_z)

if dist_x >= dist_z then
    xyz_priority = 'zxy'
else
    xyz_priority = 'xzy'
end

print(xyz_priority)

print("calibrate pc orientation? y/n")
usr_go = read()

if usr_go == 'y' then
    term.clear()
    term.setCursorPos(1,1)
    shell.run("2_goto.lua")
end

print("done!")

print("go to pc? y/n")
usr_go = read()

ori = tostring(pc_ori)

print(ori)
read()

bump = bumps[ori]

if usr_go == 'y' then
    pc_loc = {x = pc_loc.x + bump[1],y = pc_loc.y + bump[2],z = pc_loc.z + bump[3]}
    term.clear()
    term.setCursorPos(1,1)
    print(xyz_priority)
    actions.go_to(pc_loc,pc_or,xyz_priority,false)

end
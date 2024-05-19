term.clear()
term.setCursorPos(1,1)
actions.getAllCompData()
print("Select target location:")
local ids = {}
for id, pc in pairs(actions.pcTable) do
    table.insert(ids, id)
end
table.sort(ids)
local self_id = os.getComputerID()
self_loc = actions.pcTable[self_id].location
trtl_loc = {x = -190, y = 63, z = 247}
local function displayIDs(selectedIndex)
    term.setCursorPos(1,2)
    term.clearLine()
    for i, id in ipairs(ids) do
        if id == self_id then
            term.setTextColor(colors.yellow)
        else
            term.setTextColor(colors.white)
        end
        if i == selectedIndex then
            term.setBackgroundColor(colors.gray)
        else
            term.setBackgroundColor(colors.black)
        end
        term.write(id .. " ")
    end
    term.setBackgroundColor(colors.black)
    term.setTextColor(colors.white)
    term.setCursorPos(1,3)
    term.clearLine()
    if selectedIndex and actions.pcTable[ids[selectedIndex]] and actions.pcTable[ids[selectedIndex]].location then
        pc_loc = actions.pcTable[ids[selectedIndex]].location
        term.write("x=" .. pc_loc.x .. ", y=" .. pc_loc.y .. ", z=" .. pc_loc.z)
    end
    if ids[selectedIndex] == self_id then
        pc_loc = trtl_loc
    end
    term.setCursorPos(1,4)
    term.clearLine()
    if pc_loc then
        local nav_priority = actions.nav_priority(self_loc, pc_loc)
        term.write("Nav Priority: " .. tostring(nav_priority))
    end
    term.setCursorPos(1,5)
    term.clearLine()
    if pc_loc then
        dist_sx = math.abs(self_loc.x - pc_loc.x)
        dist_sy = pc_loc.y - self_loc.y
        dist_sz = math.abs(self_loc.z - pc_loc.z)
        term.write("Distance to "..ids[selectedIndex]..": "..dist_sx..", "..dist_sy..", "..dist_sz)
    end
    term.setCursorPos(1,6)
    term.clearLine()
    if selectedIndex and actions.pcTable[ids[selectedIndex]] and actions.pcTable[ids[selectedIndex]].orientation then
        local pc_ori = actions.pcTable[ids[selectedIndex]].orientation
        if pc_ori then
            term.write("Orientation: " .. pc_ori)
        end
    end
end
local selectedIndex = 1
displayIDs(selectedIndex)
while true do
    local event, key = os.pullEvent("key")
    if key == keys.right and selectedIndex < #ids then
        selectedIndex = selectedIndex + 1
    elseif key == keys.left and selectedIndex > 1 then
        selectedIndex = selectedIndex - 1
    elseif key == keys.leftShift then
        term.clear()
        term.setCursorPos(1,1)
        usr_quit = true
        break
    elseif key == keys.enter then
        break
    end
    displayIDs(selectedIndex)
end
go_dest = tonumber(ids[selectedIndex])
term.clear()
term.setCursorPos(1,1)
if not usr_quit then
    print("Going to:", go_dest)
    if go_dest == self_id then
        pc_loc = trtl_loc
        pc_ori = 'south'
    else
        pc_loc = {x = actions.pcTable[go_dest].location.x, y = actions.pcTable[go_dest].location.y+1, z = actions.pcTable[go_dest].location.z}
        pc_ori = actions.pcTable[go_dest].orientation
    end
    nav_priority = actions.nav_priority(self_loc,pc_loc)
    xyz_priority = nav_priority
    dist_pc = {}
    print("going to: "..pc_loc.x..", "..pc_loc.y..", "..pc_loc.z)
    actions.go_to(pc_loc,pc_ori,xyz_priority)
    actions.calibrate_turtle()
    actions.updateAndBroadcast()
end
term.clear()
term.setCursorPos(1,1)
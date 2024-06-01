shell.run("set motd.enable false")
term.clear()
term.setCursorPos(1,1)
me = os.getComputerID()
comp_type = 'default'
if turtle then
    comp_type = 'Turtle'
elseif pocket then
    comp_type = 'Pocket PC'
elseif commands then
    comp_type = 'CMD PC'
else
    comp_type = 'PC'
end
os.setComputerLabel(comp_type .." ".. me)
sleep((1+me)/10)
if fs.exists('/apis') then
    fs.delete('/apis')
end
fs.makeDir('/apis')
fs.copy('/actions.lua', '/apis/actions')
os.loadAPI('/apis/actions')
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        modem_side = side
        rednet.open(side)
        break
    end
end
if turtle then
    actions.who_am_i.trtl = true
elseif pocket then
    actions.who_am_i.pckt_cmp = true
elseif commands then
    actions.who_am_i.cmd_cmp = true
else
    actions.who_am_i.pc_cmp = true
end
actions.updateStateValue('modem_side',modem_side)
for key, v in pairs(actions.who_am_i) do
    actions.updateStateValue(key,v)
end
local sx, sy, sz = gps.locate()
if not sx or not sy or not sz then
    print("no gps found retaining location info")
    sleep(2)
    os.reboot()
else
    if actions.who_am_i.trtl then
        actions.calibrate_turtle()
    else
        actions.calibrate_pc()
    end
end
sleep(1)
multishell.launch({}, '/1_all.lua')
multishell.setTitle(2, tostring(me))
if turtle then
    sleep(5)
end
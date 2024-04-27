shell.run("set motd.enable false")
term.clear()
term.setCursorPos(1,1)
-- SET LABEL
os.setComputerLabel('PC '.. os.getComputerID())

local me = os.getComputerID()
sleep((1+me)/10)

shell.run("state_check.lua")

-- INITIALIZE APIS
if fs.exists('/apis') then
    fs.delete('/apis')
end
fs.makeDir('/apis')
--fs.copy('/network.lua', '/apis/network')
fs.copy('/state.lua', '/apis/state')
--os.loadAPI('/apis/network')
os.loadAPI('/apis/state')


-- OPEN REDNET
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end

-- LAUNCH PROGRAMS AS SEPARATE THREADS
--multishell.launch({}, '/find_me.lua')
--multishell.setTitle(2, 'find_me')
--multishell.launch({}, '/who_are_you.lua')
--multishell.setTitle(3, 'whoru')
multishell.launch({}, '/1_all.lua')
multishell.setTitle(2, 'all')

--sleep(2)
--my_loc_val = {x = state.location.x, y = state.location.y, z = state.location.z}
--rednet.broadcast(my_loc_val,'find_me')

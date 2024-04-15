-- SET LABEL
os.setComputerLabel('PC '.. os.getComputerID())

local me = os.getComputerID()
sleep((1+me)/10)

-- INITIALIZE APIS
if fs.exists('/apis') then
    fs.delete('/apis')
end
fs.makeDir('/apis')
fs.copy('/network.lua', '/apis/network')
os.loadAPI('/apis/network')


-- OPEN REDNET
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end

-- LAUNCH PROGRAMS AS SEPARATE THREADS
multishell.launch({}, '/find_me.lua')
multishell.setTitle(2, 'find_me')
multishell.launch({}, '/usr_cmd.lua')
multishell.setTitle(3, 'usr_cmd')
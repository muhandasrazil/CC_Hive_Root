-- SET LABEL
os.setComputerLabel('Turtle ' .. os.getComputerID())

local me = os.getComputerID()
sleep((1+me)/10)

-- INITIALIZE APIS
if fs.exists('/apis') then
    fs.delete('/apis')
end
fs.makeDir('/apis')
fs.copy('/config.lua', '/apis/config')
fs.copy('/state.lua', '/apis/state')
fs.copy('/basics.lua', '/apis/basics')
fs.copy('/actions.lua', '/apis/actions')
fs.copy('/network.lua', '/apis/network')
os.loadAPI('/apis/config')
os.loadAPI('/apis/state')
os.loadAPI('/apis/basics')
os.loadAPI('/apis/actions')
os.loadAPI('/apis/network')


-- OPEN REDNET
for _, side in pairs({'back', 'top', 'left', 'right'}) do
    if peripheral.getType(side) == 'modem' then
        rednet.open(side)
        break
    end
end



-- LAUNCH PROGRAMS AS SEPARATE THREADS
multishell.launch({}, '/who_are_you.lua')
multishell.setTitle(2, 'whoru')
multishell.launch({}, '/usr_cmd.lua')
multishell.setTitle(3, 'usr_cmd')
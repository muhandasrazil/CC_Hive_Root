pc = {}

brd_msg = {}

function receiveBroadcast()
    local senderId, message, protocol = rednet.receive('find_me')
    if protocol == 'find_me' then
        local found = false
        for _, step in pairs(pc) do
            if senderId == step.id then
                found = true
                break                
            end
        end
        if not found then
            table.insert(network.pc, {id = senderId, x = message[1], y = message[2], z = message[3]})
        end
    end
end



function viewPC()
    for key, value in pairs(network.pc) do
        local id = value.id
        local x = value.x
        local y = value.y
        local z = value.z
        print(id, x, y, z)
    end
end


function find_me()
    x, y, z = gps.locate()
    rednet.broadcast({x, y, z}, 'find_me')
    me = os.getComputerID()
    local found = false
    for _, step in pairs(brd_msg) do
        if me == step.id then
           found = true
           break
        end
    end
    if not found then
        table.insert(brd_msg,{id = me, x= x, y = y, z = z })
    end
end
while true do
    senderid, message, protocol = rednet.receive('find_me')
    print(message)
    my_loc = {x = state.location.x, y = state.location.y, z = state.location.z}
    term.clear()
    term.setCursorPos(1,1)
    print(my_loc)
    sleep(2)
    rednet.send(senderid,my_loc,'find_me')
end
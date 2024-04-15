while true do
    network.receiveBroadcast()
    term.clear()
    term.setCursorPos(1,1)
    network.viewPC()
    sleep(6)
end
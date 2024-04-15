while true do
    network.find_me()
    term.clear()
    term.setCursorPos(1,1)
    for _, step in pairs(network.brd_msg) do
        print(string.format("Current location: x: %d, y: %d, z: %d", step.x, step.y, step.z))
    end
    sleep(5)
end
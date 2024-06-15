pcTable = {}
me = os.getComputerID()
who_am_i = {
    trtl = false,
    pckt_cmp = false,
    cmd_cmp = false,
    pc_cmp = false,
    my_id = os.getComputerID(),
    my_name = os.getComputerLabel()
}
if turtle then
    move = {
        forward = turtle.forward,
        up      = turtle.up,
        down    = turtle.down,
        back    = turtle.back,
        left    = turtle.turnLeft,
        right   = turtle.turnRight
    }
    bumps = {
        north = { 0,  0, -1},
        south = { 0,  0,  1},
        east  = { 1,  0,  0},
        west  = {-1,  0,  0},
    }
    left_shift = {
        north = 'west',
        south = 'east',
        east  = 'north',
        west  = 'south',
    }
    right_shift = {
        north = 'east',
        south = 'west',
        east  = 'south',
        west  = 'north',
    }
    reverse_shift = {
        north = 'south',
        south = 'north',
        east  = 'west',
        west  = 'east',
    }
    detect = {
        forward = turtle.detect,
        up      = turtle.detectUp,
        down    = turtle.detectDown
    }
    inspect = {
        forward = turtle.inspect,
        up      = turtle.inspectUp,
        down    = turtle.inspectDown
    }
end
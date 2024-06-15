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
    going = {
--                                                                                                                                                 <>
        --| Recording the statistics of the turtle throughout it's entire travels.
--                                                                                                                                                 <>
    stats = {
        key_order = {"move","detect","vars"},
        --| Total times we performed this
            --- Move actions
        move = {
                --- key order is to allow us to work in the correct order in a for loop
            key_order = {"total","pos_x","pos_y","pos_z","neg_x","neg_y","neg_z","north","south","east","west","up","down","left","right","forward","back"},
                --- Total movements performed
            total = 0,
                --- Movement of axis. This would be if the previous position = current position +-1.
            pos_x = 0,
            pos_y = 0,
            pos_z = 0,
            neg_x = 0,
            neg_y = 0,
            neg_z = 0,
                --- Movement of cardinal direction.
            north = 0,
            south = 0,
            east = 0,
            west = 0,
                --- Movement of direction. This is the direction syntax for go(direction)
            up = 0,
            down = 0,
            left = 0,
            right = 0,
            forward = 0,
            back = 0,
        },
            --- Detect actions
        detect = {
                --- key order is to allow us to work in the correct order in a for loop
            key_order = {"total","up","down","forward"},
                --- Total detections made
            total = 0,
                --- detections made in direction
            up = 0,
            down = 0,
            forward = 0,
        },
        --| Total times a thing happened. variables, functions called, updates maybe.
        vars = {
                --- key order is to allow us to work in the correct order in a for loop
            key_order = {"tru","fls","go","up","down","forward","larg_x","larg_y","larg_z","smal_x","smal_y","smal_z"},
                --- Total number of times go returned a true or false
            tru = 0,
            fls = 0,
                --- Total number of times go is called.
                --- Total number of times a direction is called. This is for things after we detect. 
            go = 0,
            up = 0,
            down = 0,
            forward = 0,
                --- The xyz boundries. Largest xyz, smallest xyz. Fun to have if we end up at world height
            larg_x = 0,
            larg_y = 0,
            larg_z = 0,
            smal_x = 0,
            smal_y = 0,
            smal_z = 0,
        },
    },
--                                                                                                                                                 <>
        --| This is the variable key for what a variable means. It's allowed to be called
        --| This key is used for the recoding logic below.
        --| Each letter in the variables mapps to the key
--                                                                                                                                                 <>
            --- Sub Key Order is a global variable to be able to define the navigation xyz in a for loop
        sub_order = {"x","y","z"},
        var_key ={
            key_order = {"abs","axis","bck","clo","c","dir","dwn","e","fc","fwd","fur","h","lft","loc","nav","n","rit","s","up"},
            abs = 'absolute',
            axis = 'single xyz axis',
            bck = 'back',
            clo = 'closest',
            c = 'center',
            dir = 'cardinal direction',
            dwn = 'down',
            e = 'end',
            fc = 'facing',
            fwd = 'forward',
            fur = 'furthest',
            h = 'halt',
            lft = 'left',
            loc = 'location',
            nav = 'navigation distance',
            n = 'now',
            rit = 'right',
            s = 'start',
            up = 'up',
        },
--                                                                                                                                                 <>
        --| recording all general information. My position where I'm going the math involved ETC
--                                                                                                                                                 <>
        --| recording static data. These inputs can come from the "status'. 
        --| api and/or the "goto" function directly, but we are just saving them here just in case.
    static = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"sloc","eloc","sloc_nav","sloc_nav_abs","eloc_nav","eloc_nav_abs","nav_priority_input","sdir","edir"},
            --- starting location xyz
        sloc = nil,                                             --* positive and negative xyz
            --- end locaiton xyz
        eloc = nil,                                             --* positive and negative xyz
            --- optimal pathing that the turtle records on start
            --- strtloc optimal is the xyz turtle thinks it needs to go
            --- strtloc optimal abs is the absolute the turtle thinks it needs to go.
        sloc_nav = nil,                                         --* positive and negative xyz
        sloc_nav_abs = nil,                                     --+ absolute value of distance
            --- endloc optimal is the xyz distance to be traveled from the perspective of the end destination
            --- endloc optimal abs is the absolute value the end thinks the turtle should go
        eloc_nav = nil,                                         --* positive and negative xyz
        eloc_nav_abs = nil,                                     --+ absolute value of distance
            --- storing strings for the nav priority and the compass directions
        nav_priority_input = nil,                               --+ STRING
            --- cardinal direction start to end
            --- cardinal direction end to start
        sdir = nil,                                             --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil                                              --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
    },
--                                                                                                                                                 <>
        --| Mapping the dynamic distance for the turtle movement directly. This is outside of the Maze solver
    dynmc = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"slocn","slocn_nav","slocn_nav_abs","elocn","elocn_nav","elocn_nav_abs","nav","nav_abs","dirn","sdirn","edirn","axisn"},
            --- This is to record the where in the world we are. sanity check against the API "status.pctable[who_am_i.my_id].location"
            --- now dist is the xyz of the distance from right now to the end. sanity check against static
            --- now dist abs is the distance we have left to go to get to the end position.
        slocn = nil,                                            --+ positive and negative xyz
        slocn_nav = nil,                                        --* positive and negative xyz
        slocn_nav_abs = nil,                                    --+ absolute value of distance
            --- this records where the end location is. Use to sanity check against the end location static. 
            --- now dist is where we THINK the end destination is. Used as sanity check to compare against static.
            --- now dist abs is the absolute of how far away we are from the end destination. Used as comparison for sanity check
        elocn = nil,                                            --+ positive and negative xyz
        elocn_nav = nil,                                        --* positive and negative xyz
        elocn_nav_abs = nil,                                    --+ absolute value of distance
            --- Tracking the actual movement the turle has made. 
            --- Dist by axis is the xyz real world we have gone. +x will increment x, -x will decrement x
            --- dist by axis abs is the total times the turtle moves ever by the axis.
        nav = nil,                                              --+ positive and negative xyz
        nav_abs = nil,                                          --* absolute value of distance
            --- cardinal direction we are currently facing
            --- cardinal direction from now to start
            --- cardinal direction from now to end
            --- axis we are currently on
        dirn = nil,                                             --+ STRING
        sdirn = nil,                                            --* STRING
        edirn = nil,                                            --+ STRING
        axisn = nil                                             --* STRING
    },
--                                                                                                                                                 <>
        --| Recording the information to detect when we have encountered a block
--                                                                                                                                                 <>
        --| Forward
        --| Axis of x or z will always "detect forward" and update the distance from center as 0,0,0
        --| We want to go forward, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
    fwd = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"dirfc","sdir","edir","hloc","hs_nav","hs_nav_abs","he_nav","he_nav_abs","nav_sh","nav_sh_abs","nav_he","nav_he_abs","h_nav_c","h_nav_c_abs","clos_sloc","clos_nav_s","clo_nav_s_abs","clo_eloc","clo_nav_e","clo_nav_e_abs","fur_sloc","fur_nav_s","fur_nav_s_abs","fur_eloc","fur_nav_e","fur_nav_e_abs"},
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        hloc = nil,                                         --+ positive and negative xyz
        hs_nav = nil,                                       --* positive and negative xyz
        hs_nav_abs = nil,                                   --+ absolute value of distance
        he_nav = nil,                                       --* positive and negative xyz
        he_nav_abs = nil,                                   --+ absolute value of distance
        nav_sh = nil,                                       --* positive and negative xyz
        nav_sh_abs = nil,                                   --+ absolute value of distance
        nav_he = nil,                                       --* positive and negative xyz
        nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        h_nav_c = nil,                                      --* positive and negative xyz
        h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        clos_sloc = nil,                                    --* positive and negative xyz
        clos_nav_s = nil,                                   --+ positive and negative xyz
        clo_nav_s_abs = nil,                                --* absolute value of distance
        clo_eloc = nil,                                     --+ positive and negative xyz
        clo_nav_e = nil,                                    --* positive and negative xyz
        clo_nav_e_abs = nil,                                --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        fur_sloc = nil,                                     --* positive and negative xyz
        fur_nav_s = nil,                                    --+ positive and negative xyz
        fur_nav_s_abs = nil,                                --* absolute value of distance
        fur_eloc = nil,                                     --+ positive and negative xyz
        fur_nav_e = nil,                                    --* positive and negative xyz
        fur_nav_e_abs = nil                                 --+ absolute value of distance
    },
--                                                                                                                                                 <>
        --| Up
        --| Axis of a POSITIVE y will always "detect up" and update the distance from center as 0,0,0
        --| We want to go up, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
    up = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"dirfc","sdir","edir","hloc","hs_nav","hs_nav_abs","he_nav","he_nav_abs","nav_sh","nav_sh_abs","nav_he","nav_he_abs","h_nav_c","h_nav_c_abs","clos_sloc","clos_nav_s","clo_nav_s_abs","clo_eloc","clo_nav_e","clo_nav_e_abs","fur_sloc","fur_nav_s","fur_nav_s_abs","fur_eloc","fur_nav_e","fur_nav_e_abs"},
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dirfc = nil,                                        --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        sdir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        hloc = nil,                                         --* positive and negative xyz
        hs_nav = nil,                                       --+ positive and negative xyz
        hs_nav_abs = nil,                                   --* absolute value of distance
        he_nav = nil,                                       --+ positive and negative xyz
        he_nav_abs = nil,                                   --* absolute value of distance
        nav_sh = nil,                                       --+ positive and negative xyz
        nav_sh_abs = nil,                                   --* absolute value of distance
        nav_he = nil,                                       --+ positive and negative xyz
        nav_he_abs = nil,                                   --* absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        h_nav_c = nil,                                      --+ positive and negative xyz
        h_nav_c_abs = nil,                                  --* absolute value of distance
            --- closest position to start 
            --- closest position to end 
        clos_sloc = nil,                                    --+ positive and negative xyz
        clos_nav_s = nil,                                   --* positive and negative xyz
        clo_nav_s_abs = nil,                                --+ absolute value of distance
        clo_eloc = nil,                                     --* positive and negative xyz
        clo_nav_e = nil,                                    --+ positive and negative xyz
        clo_nav_e_abs = nil,                                --* absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        fur_sloc = nil,                                     --+ positive and negative xyz
        fur_nav_s = nil,                                    --* positive and negative xyz
        fur_nav_s_abs = nil,                                --+ absolute value of distance
        fur_eloc = nil,                                     --* positive and negative xyz
        fur_nav_e = nil,                                    --+ positive and negative xyz
        fur_nav_e_abs = nil                                 --* absolute value of distance
    },
--                                                                                                                                                 <>
        --| Down
        --| Axis of a NEGATIVE y will always "detect down" and update the distance from center as 0,0,0
        --| We want to go down, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
    dwn = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"dirfc","sdir","edir","hloc","hs_nav","hs_nav_abs","he_nav","he_nav_abs","nav_sh","nav_sh_abs","nav_he","nav_he_abs","h_nav_c","h_nav_c_abs","clos_sloc","clos_nav_s","clo_nav_s_abs","clo_eloc","clo_nav_e","clo_nav_e_abs","fur_sloc","fur_nav_s","fur_nav_s_abs","fur_eloc","fur_nav_e","fur_nav_e_abs"},
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        hloc = nil,                                         --+ positive and negative xyz
        hs_nav = nil,                                       --* positive and negative xyz
        hs_nav_abs = nil,                                   --+ absolute value of distance
        he_nav = nil,                                       --* positive and negative xyz
        he_nav_abs = nil,                                   --+ absolute value of distance
        nav_sh = nil,                                       --* positive and negative xyz
        nav_sh_abs = nil,                                   --+ absolute value of distance
        nav_he = nil,                                       --* positive and negative xyz
        nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        h_nav_c = nil,                                      --* positive and negative xyz
        h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        clos_sloc = nil,                                    --* positive and negative xyz
        clos_nav_s = nil,                                   --+ positive and negative xyz
        clo_nav_s_abs = nil,                                --* absolute value of distance
        clo_eloc = nil,                                     --+ positive and negative xyz
        clo_nav_e = nil,                                    --* positive and negative xyz
        clo_nav_e_abs = nil,                                --+ absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        fur_sloc = nil,                                     --* positive and negative xyz
        fur_nav_s = nil,                                    --+ positive and negative xyz
        fur_nav_s_abs = nil,                                --* absolute value of distance
        fur_eloc = nil,                                     --+ positive and negative xyz
        fur_nav_e = nil,                                    --* positive and negative xyz
        fur_nav_e_abs = nil                                 --+ absolute value of distance
    },
--                                                                                                                                                 <>
        --| Left
        --| Left will always require a turn command for movement.
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
    lft = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"dirfc","sdir","edir","hloc","hs_nav","hs_nav_abs","he_nav","he_nav_abs","nav_sh","nav_sh_abs","nav_he","nav_he_abs","h_nav_c","h_nav_c_abs","clos_sloc","clos_nav_s","clo_nav_s_abs","clo_eloc","clo_nav_e","clo_nav_e_abs","fur_sloc","fur_nav_s","fur_nav_s_abs","fur_eloc","fur_nav_e","fur_nav_e_abs"},
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dirfc = nil,                                        --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        sdir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        hloc = nil,                                         --* positive and negative xyz
        hs_nav = nil,                                       --+ positive and negative xyz
        hs_nav_abs = nil,                                   --* absolute value of distance
        he_nav = nil,                                       --+ positive and negative xyz
        he_nav_abs = nil,                                   --* absolute value of distance
        nav_sh = nil,                                       --+ positive and negative xyz
        nav_sh_abs = nil,                                   --* absolute value of distance
        nav_he = nil,                                       --+ positive and negative xyz
        nav_he_abs = nil,                                   --* absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        h_nav_c = nil,                                      --+ positive and negative xyz
        h_nav_c_abs = nil,                                  --* absolute value of distance
            --- closest position to start 
            --- closest position to end 
        clos_sloc = nil,                                    --+ positive and negative xyz
        clos_nav_s = nil,                                   --* positive and negative xyz
        clo_nav_s_abs = nil,                                --+ absolute value of distance
        clo_eloc = nil,                                     --* positive and negative xyz
        clo_nav_e = nil,                                    --+ positive and negative xyz
        clo_nav_e_abs = nil,                                --* absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        fur_sloc = nil,                                     --+ positive and negative xyz
        fur_nav_s = nil,                                    --* positive and negative xyz
        fur_nav_s_abs = nil,                                --+ absolute value of distance
        fur_eloc = nil,                                     --* positive and negative xyz
        fur_nav_e = nil,                                    --+ positive and negative xyz
        fur_nav_e_abs = nil                                 --* absolute value of distance
    },
--                                                                                                                                                 <>
        --| Right
        --| Right will always require a turn command for movement.
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
    rit = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"dirfc","sdir","edir","hloc","hs_nav","hs_nav_abs","he_nav","he_nav_abs","nav_sh","nav_sh_abs","nav_he","nav_he_abs","h_nav_c","h_nav_c_abs","clos_sloc","clos_nav_s","clo_nav_s_abs","clo_eloc","clo_nav_e","clo_nav_e_abs","fur_sloc","fur_nav_s","fur_nav_s_abs","fur_eloc","fur_nav_e","fur_nav_e_abs"},
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        hloc = nil,                                         --+ positive and negative xyz
        hs_nav = nil,                                       --* positive and negative xyz
        hs_nav_abs = nil,                                   --+ absolute value of distance
        he_nav = nil,                                       --* positive and negative xyz
        he_nav_abs = nil,                                   --+ absolute value of distance
        nav_sh = nil,                                       --* positive and negative xyz
        nav_sh_abs = nil,                                   --+ absolute value of distance
        nav_he = nil,                                       --* positive and negative xyz
        nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        h_nav_c = nil,                                      --* positive and negative xyz
        h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        clos_sloc = nil,                                    --* positive and negative xyz
        clos_nav_s = nil,                                   --+ positive and negative xyz
        clo_nav_s_abs = nil,                                --* absolute value of distance
        clo_eloc = nil,                                     --+ positive and negative xyz
        clo_nav_e = nil,                                    --* positive and negative xyz
        clo_nav_e_abs = nil,                                --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        fur_sloc = nil,                                     --* positive and negative xyz
        fur_nav_s = nil,                                    --+ positive and negative xyz
        fur_nav_s_abs = nil,                                --* absolute value of distance
        fur_eloc = nil,                                     --+ positive and negative xyz
        fur_nav_e = nil,                                    --* positive and negative xyz
        fur_nav_e_abs = nil                                 --+ absolute value of distance
    },
--                                                                                                                                                 <>
        --| Back
        --| Back direction typically only works for Y axis. X or Z axis moving back just returns to starting position
        --| Back direction requires turns
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
    bck = {
            --- key order is to allow us to work in the correct order in a for loop
        key_order = {"dirfc","sdir","edir","hloc","hs_nav","hs_nav_abs","he_nav","he_nav_abs","nav_sh","nav_sh_abs","nav_he","nav_he_abs","h_nav_c","h_nav_c_abs","clos_sloc","clos_nav_s","clo_nav_s_abs","clo_eloc","clo_nav_e","clo_nav_e_abs","fur_sloc","fur_nav_s","fur_nav_s_abs","fur_eloc","fur_nav_e","fur_nav_e_abs"},
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        hloc = nil,                                         --+ positive and negative xyz
        hs_nav = nil,                                       --* positive and negative xyz
        hs_nav_abs = nil,                                   --+ absolute value of distance
        he_nav = nil,                                       --* positive and negative xyz
        he_nav_abs = nil,                                   --+ absolute value of distance
        nav_sh = nil,                                       --* positive and negative xyz
        nav_sh_abs = nil,                                   --+ absolute value of distance
        nav_he = nil,                                       --* positive and negative xyz
        nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        h_nav_c = nil,                                      --* positive and negative xyz
        h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        clos_sloc = nil,                                    --* positive and negative xyz
        clos_nav_s = nil,                                   --+ positive and negative xyz
        clo_nav_s_abs = nil,                                --* absolute value of distance
        clo_eloc = nil,                                     --+ positive and negative xyz
        clo_nav_e = nil,                                    --* positive and negative xyz
        clo_nav_e_abs = nil,                                --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        fur_sloc = nil,                                     --* positive and negative xyz
        fur_nav_s = nil,                                    --+ positive and negative xyz
        fur_nav_s_abs = nil,                                --* absolute value of distance
        fur_eloc = nil,                                     --+ positive and negative xyz
        fur_nav_e = nil,                                    --* positive and negative xyz
        fur_nav_e_abs = nil                                --+ absolute value of distance
    }
    }
end
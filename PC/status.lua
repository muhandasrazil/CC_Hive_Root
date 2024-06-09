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
        --| Total times we performed this
        move = {
                --- Total movements performed
            total = nil,
                --- Movement of axis. This would be if the previous position = current position +-1.
            pos_x = nil,
            pos_y = nil,
            pos_z = nil,
            neg_x = nil,
            neg_y = nil,
            neg_z = nil,
                --- Movement of cardinal direction.
            north = nil,
            south = nil,
            east = nil,
            west = nil,
                --- Movement of direction. This is the direction syntax for go(direction)
            up = nil,
            down = nil,
            left = nil,
            right = nil,
            forward = nil,
            back = nil,
        },
        detect = {
                --- Total detections made
            total = nil,
                --- detections made in direction
            up = nil,
            down = nil,
            forward = nil,
        },
        --| Total times a thing happened. variables, functions called, updates maybe.
        vars = {
                --- Total number of times go returned a true or false
            tru = nil,
            fls = nil,
                --- Total number of times go is called.
                --- Total number of times a direction is called. This is for things after we detect. 
            go = nil,
            up = nil,
            down = nil,
            forward = nil,
                --- The xyz boundries. Largest xyz, smallest xyz. Fun to have if we end up at world height
            larg_x = nil,
            larg_y = nil,
            larg_z = nil,
            smal_x = nil,
            smal_y = nil,
            smal_z = nil,
        },
    },
--                                                                                                                                                 <>
        --| This is the variable key for what a variable means. It's allowed to be called
        --| This key is used for the recoding logic below.
        --| Each letter in the variables mapps to the key
--                                                                                                                                                 <>
        var_key ={
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
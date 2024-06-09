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
        sdir = nil,                                             --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        edir = nil,                                             --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
--                                                                                                                                                 <>
        --| Mapping the dynamic distance for the turtle movement directly. This is outside of the Maze solver
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
        dirn = nil,
        sdirn = nil,
        edirn = nil,
        axisn = nil,
--                                                                                                                                                 <>
        --| Recording the information to detect when we have encountered a block
--                                                                                                                                                 <>
        --| Forward
        --| Axis of x or z will always "detect forward" and update the distance from center as 0,0,0
        --| We want to go forward, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        fwd_dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        fwd_sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        fwd_edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        fwd_hloc = nil,                                         --+ positive and negative xyz
        fwd_hs_nav = nil,                                       --* positive and negative xyz
        fwd_hs_nav_abs = nil,                                   --+ absolute value of distance
        fwd_he_nav = nil,                                       --* positive and negative xyz
        fwd_he_nav_abs = nil,                                   --+ absolute value of distance
        fwd_nav_sh = nil,                                       --* positive and negative xyz
        fwd_nav_sh_abs = nil,                                   --+ absolute value of distance
        fwd_nav_he = nil,                                       --* positive and negative xyz
        fwd_nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        fwd_h_nav_c = nil,                                      --* positive and negative xyz
        fwd_h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        fwd_clos_sloc = nil,                                    --* positive and negative xyz
        fwd_clos_nav_s = nil,                                   --+ positive and negative xyz
        fwd_clo_nav_s_abs = nil,                                --* absolute value of distance
        fwd_clo_eloc = nil,                                     --+ positive and negative xyz
        fwd_clo_nav_e = nil,                                    --* positive and negative xyz
        fwd_clo_nav_e_abs = nil,                                --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        fwd_fur_sloc = nil,                                     --* positive and negative xyz
        fwd_fur_nav_s = nil,                                    --+ positive and negative xyz
        fwd_fur_nav_s_abs = nil,                                --* absolute value of distance
        fwd_fur_eloc = nil,                                     --+ positive and negative xyz
        fwd_fur_nav_e = nil,                                    --* positive and negative xyz
        fwd_fur_nav_e_abs = nil,                                --+ absolute value of distance
--                                                                                                                                                 <>
        --| Up
        --| Axis of a POSITIVE y will always "detect up" and update the distance from center as 0,0,0
        --| We want to go up, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        up_dirfc = nil,                                        --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        up_sdir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        up_edir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        up_hloc = nil,                                         --* positive and negative xyz
        up_hs_nav = nil,                                       --+ positive and negative xyz
        up_hs_nav_abs = nil,                                   --* absolute value of distance
        up_he_nav = nil,                                       --+ positive and negative xyz
        up_he_nav_abs = nil,                                   --* absolute value of distance
        up_nav_sh = nil,                                       --+ positive and negative xyz
        up_nav_sh_abs = nil,                                   --* absolute value of distance
        up_nav_he = nil,                                       --+ positive and negative xyz
        up_nav_he_abs = nil,                                   --* absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        up_h_nav_c = nil,                                      --+ positive and negative xyz
        up_h_nav_c_abs = nil,                                  --* absolute value of distance
            --- closest position to start 
            --- closest position to end 
        up_clos_sloc = nil,                                    --+ positive and negative xyz
        up_clos_nav_s = nil,                                   --* positive and negative xyz
        up_clo_nav_s_abs = nil,                                --+ absolute value of distance
        up_clo_eloc = nil,                                     --* positive and negative xyz
        up_clo_nav_e = nil,                                    --+ positive and negative xyz
        up_clo_nav_e_abs = nil,                                --* absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        up_fur_sloc = nil,                                     --+ positive and negative xyz
        up_fur_nav_s = nil,                                    --* positive and negative xyz
        up_fur_nav_s_abs = nil,                                --+ absolute value of distance
        up_fur_eloc = nil,                                     --* positive and negative xyz
        up_fur_nav_e = nil,                                    --+ positive and negative xyz
        up_fur_nav_e_abs = nil,                                --* absolute value of distance
--                                                                                                                                                 <>
        --| Down
        --| Axis of a NEGATIVE y will always "detect down" and update the distance from center as 0,0,0
        --| We want to go down, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dwn_dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        dwn_sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        dwn_edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        dwn_hloc = nil,                                         --+ positive and negative xyz
        dwn_hs_nav = nil,                                       --* positive and negative xyz
        dwn_hs_nav_abs = nil,                                   --+ absolute value of distance
        dwn_he_nav = nil,                                       --* positive and negative xyz
        dwn_he_nav_abs = nil,                                   --+ absolute value of distance
        dwn_nav_sh = nil,                                       --* positive and negative xyz
        dwn_nav_sh_abs = nil,                                   --+ absolute value of distance
        dwn_nav_he = nil,                                       --* positive and negative xyz
        dwn_nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        dwn_h_nav_c = nil,                                      --* positive and negative xyz
        dwn_h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        dwn_clos_sloc = nil,                                    --* positive and negative xyz
        dwn_clos_nav_s = nil,                                   --+ positive and negative xyz
        dwn_clo_nav_s_abs = nil,                                --* absolute value of distance
        dwn_clo_eloc = nil,                                     --+ positive and negative xyz
        dwn_clo_nav_e = nil,                                    --* positive and negative xyz
        dwn_clo_nav_e_abs = nil,                                --+ absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        dwn_fur_sloc = nil,                                     --* positive and negative xyz
        dwn_fur_nav_s = nil,                                    --+ positive and negative xyz
        dwn_fur_nav_s_abs = nil,                                --* absolute value of distance
        dwn_fur_eloc = nil,                                     --+ positive and negative xyz
        dwn_fur_nav_e = nil,                                    --* positive and negative xyz
        dwn_fur_nav_e_abs = nil,                                --+ absolute value of distance
--                                                                                                                                                 <>
        --| Left
        --| Left will always require a turn command for movement.
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        lft_dirfc = nil,                                        --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        lft_sdir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        lft_edir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        lft_hloc = nil,                                         --* positive and negative xyz
        lft_hs_nav = nil,                                       --+ positive and negative xyz
        lft_hs_nav_abs = nil,                                   --* absolute value of distance
        lft_he_nav = nil,                                       --+ positive and negative xyz
        lft_he_nav_abs = nil,                                   --* absolute value of distance
        lft_nav_sh = nil,                                       --+ positive and negative xyz
        lft_nav_sh_abs = nil,                                   --* absolute value of distance
        lft_nav_he = nil,                                       --+ positive and negative xyz
        lft_nav_he_abs = nil,                                   --* absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        lft_h_nav_c = nil,                                      --+ positive and negative xyz
        lft_h_nav_c_abs = nil,                                  --* absolute value of distance
            --- closest position to start 
            --- closest position to end 
        lft_clos_sloc = nil,                                    --+ positive and negative xyz
        lft_clos_nav_s = nil,                                   --* positive and negative xyz
        lft_clo_nav_s_abs = nil,                                --+ absolute value of distance
        lft_clo_eloc = nil,                                     --* positive and negative xyz
        lft_clo_nav_e = nil,                                    --+ positive and negative xyz
        lft_clo_nav_e_abs = nil,                                --* absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        lft_fur_sloc = nil,                                     --+ positive and negative xyz
        lft_fur_nav_s = nil,                                    --* positive and negative xyz
        lft_fur_nav_s_abs = nil,                                --+ absolute value of distance
        lft_fur_eloc = nil,                                     --* positive and negative xyz
        lft_fur_nav_e = nil,                                    --+ positive and negative xyz
        lft_fur_nav_e_abs = nil,                                --* absolute value of distance
--                                                                                                                                                 <>
        --| Right
        --| Right will always require a turn command for movement.
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        rit_dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        rit_sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        rit_edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        rit_hloc = nil,                                         --+ positive and negative xyz
        rit_hs_nav = nil,                                       --* positive and negative xyz
        rit_hs_nav_abs = nil,                                   --+ absolute value of distance
        rit_he_nav = nil,                                       --* positive and negative xyz
        rit_he_nav_abs = nil,                                   --+ absolute value of distance
        rit_nav_sh = nil,                                       --* positive and negative xyz
        rit_nav_sh_abs = nil,                                   --+ absolute value of distance
        rit_nav_he = nil,                                       --* positive and negative xyz
        rit_nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        rit_h_nav_c = nil,                                      --* positive and negative xyz
        rit_h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        rit_clos_sloc = nil,                                    --* positive and negative xyz
        rit_clos_nav_s = nil,                                   --+ positive and negative xyz
        rit_clo_nav_s_abs = nil,                                --* absolute value of distance
        rit_clo_eloc = nil,                                     --+ positive and negative xyz
        rit_clo_nav_e = nil,                                    --* positive and negative xyz
        rit_clo_nav_e_abs = nil,                                --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        rit_fur_sloc = nil,                                     --* positive and negative xyz
        rit_fur_nav_s = nil,                                    --+ positive and negative xyz
        rit_fur_nav_s_abs = nil,                                --* absolute value of distance
        rit_fur_eloc = nil,                                     --+ positive and negative xyz
        rit_fur_nav_e = nil,                                    --* positive and negative xyz
        rit_fur_nav_e_abs = nil,                                --+ absolute value of distance
--                                                                                                                                                 <>
        --| Back
        --| Back direction typically only works for Y axis. X or Z axis moving back just returns to starting position
        --| Back direction requires turns
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        bck_dirfc = nil,                                        --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        bck_sdir = nil,                                         --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        bck_edir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        bck_hloc = nil,                                         --+ positive and negative xyz
        bck_hs_nav = nil,                                       --* positive and negative xyz
        bck_hs_nav_abs = nil,                                   --+ absolute value of distance
        bck_he_nav = nil,                                       --* positive and negative xyz
        bck_he_nav_abs = nil,                                   --+ absolute value of distance
        bck_nav_sh = nil,                                       --* positive and negative xyz
        bck_nav_sh_abs = nil,                                   --+ absolute value of distance
        bck_nav_he = nil,                                       --* positive and negative xyz
        bck_nav_he_abs = nil,                                   --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        bck_h_nav_c = nil,                                      --* positive and negative xyz
        bck_h_nav_c_abs = nil,                                  --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        bck_clos_sloc = nil,                                    --* positive and negative xyz
        bck_clos_nav_s = nil,                                   --+ positive and negative xyz
        bck_clo_nav_s_abs = nil,                                --* absolute value of distance
        bck_clo_eloc = nil,                                     --+ positive and negative xyz
        bck_clo_nav_e = nil,                                    --* positive and negative xyz
        bck_clo_nav_e_abs = nil,                                --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        bck_fur_sloc = nil,                                     --* positive and negative xyz
        bck_fur_nav_s = nil,                                    --+ positive and negative xyz
        bck_fur_nav_s_abs = nil,                                --* absolute value of distance
        bck_fur_eloc = nil,                                     --+ positive and negative xyz
        bck_fur_nav_e = nil,                                    --* positive and negative xyz
        bck_fur_nav_e_abs = nil,                                --+ absolute value of distance
    }
end
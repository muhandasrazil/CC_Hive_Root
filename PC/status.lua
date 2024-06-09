pcTable = {}
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
        --| recording all general information. My position where I'm going the math involved ETC
--                                                                                                                                                 <>
        --| recording static data. These inputs can come from the "status'. 
        --| api and/or the "goto" function directly, but we are just saving them here just in case.
            --- starKsting location xyz
        strtloc = nil,                                          --* positive and negative xyz
            --- end locaiton xyz
        endloc = nil,                                           --* positive and negative xyz
            --- optimal pathing that the turtle records on start
            --- strtloc optimal is the xyz turtle thinks it needs to go
            --- strtloc optimal abs is the absolute the turtle thinks it needs to go.
        strtloc_optimal = nil,                                  --* positive and negative xyz
        strtloc_optimal_abs = nil,                              --+ absolute value of distance
            --- endloc optimal is the xyz distance to be traveled from the perspective of the end destination
            --- endloc optimal abs is the absolute value the end thinks the turtle should go
        endloc_optimal = nil,                                   --* positive and negative xyz
        endloc_optimal_abs = nil,                               --+ absolute value of distance
            --- storing strings for the nav priority and the compass directions
        nav_priority_input = nil,                               --+ STRING
            --- cardinal direction start to end
            --- cardinal direction end to start
        cardinal_direc_strt = nil,                              --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        cardinal_direc_end = nil,                               --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
--                                                                                                                                                 <>
        --| Mapping the dynamic distance for the turtle movement directly. This is outside of the Maze solver
            --- This is to record the where in the world we are. sanity check against the API "status.pctable[who_am_i.my_id].location"
            --- now dist is the xyz of the distance from right now to the end. sanity check against static
            --- now dist abs is the distance we have left to go to get to the end position.
        strtloc_now = nil,                                      --+ positive and negative xyz
        strtloc_now_dist = nil,                                 --* positive and negative xyz
        strtloc_now_dist_abs = nil,                             --+ absolute value of distance
            --- this records where the end location is. Use to sanity check against the end location static. 
            --- now dist is where we THINK the end destination is. Used as sanity check to compare against static.
            --- now dist abs is the absolute of how far away we are from the end destination. Used as comparison for sanity check
        endloc_now = nil,                                       --+ positive and negative xyz
        endloc_now_dist = nil,                                  --* positive and negative xyz
        endloc_now_dist_abs = nil,                              --+ absolute value of distance
            --- Tracking the actual movement the turle has made. 
            --- Dist by axis is the xyz real world we have gone. +x will increment x, -x will decrement x
            --- dist by axis abs is the total times the turtle moves ever by the axis.
        dist_by_axis = nil,                                     --+ positive and negative xyz
        dist_by_axis_abs = nil,                                 --* absolute value of distance
            --- cardinal direction we are currently facing
            --- cardinal direction from now to start
            --- cardinal direction from now to end
            --- axis we are currently on
        cardinal_direc_now = nil,
        cardinal_direc_now_strt = nil,
        cardinal_direc_now_end = nil,
        curr_axis_now = nil,
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
        fwd_cardinal_face = nil,                                --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        fwd_cardinal_strt = nil,                                --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        fwd_cardinal_end = nil,                                 --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        fwd_mvmnt_halt_loc = nil,                               --+ positive and negative xyz
        fwd_mvmnt_halt_strt_dist = nil,                         --* positive and negative xyz
        fwd_mvmnt_halt_strt_dist_abs = nil,                     --+ absolute value of distance
        fwd_mvmnt_halt_end_dist = nil,                          --* positive and negative xyz
        fwd_mvmnt_halt_end_dist_abs = nil,                      --+ absolute value of distance
        fwd_mvmnt_halt_dist_strt = nil,                         --* positive and negative xyz
        fwd_mvmnt_halt_dist_strt_abs = nil,                     --+ absolute value of distance
        fwd_mvmnt_halt_dist_end = nil,                          --* positive and negative xyz
        fwd_mvmnt_halt_dist_end_abs = nil,                      --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        fwd_mvmnt_halt_dist_from_center = nil,                  --* positive and negative xyz
        fwd_mvmnt_halt_dist_from_center_abs = nil,              --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        fwd_closest_loc_strt = nil,                             --* positive and negative xyz
        fwd_closest_dist_strt = nil,                            --+ positive and negative xyz
        fwd_closest_dist_strt_abs = nil,                        --* absolute value of distance
        fwd_closest_loc_end = nil,                              --+ positive and negative xyz
        fwd_closest_dist_end = nil,                             --* positive and negative xyz
        fwd_closest_dist_end_abs = nil,                         --+ absolute value of distance
           --- furthest position from the start
           --- furthest position from the end
        fwd_furthest_loc_strt = nil,                            --* positive and negative xyz
        fwd_furthest_dist_strt = nil,                           --+ positive and negative xyz
        fwd_furthest_dist_strt_abs = nil,                       --* absolute value of distance
        fwd_furthest_loc_end = nil,                             --+ positive and negative xyz
        fwd_furthest_dist_end = nil,                            --* positive and negative xyz
        fwd_furthest_dist_end_abs = nil,                        --+ absolute value of distance
--                                                                                                                                                 <>
        --| Up
        --| Axis of a POSITIVE y will always "detect up" and update the distance from center as 0,0,0
        --| We want to go up, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        up_cardinal_face = nil,                                 --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        up_cardinal_strt = nil,                                 --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        up_cardinal_end = nil,                                  --* STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        up_mvmnt_halt_loc = nil,                                --* positive and negative xyz
        up_mvmnt_halt_strt_dist = nil,                          --+ positive and negative xyz
        up_mvmnt_halt_strt_dist_abs = nil,                      --* absolute value of distance
        up_mvmnt_halt_end_dist = nil,                           --+ positive and negative xyz
        up_mvmnt_halt_end_dist_abs = nil,                       --* absolute value of distance
        up_mvmnt_halt_dist_strt = nil,                          --+ positive and negative xyz
        up_mvmnt_halt_dist_strt_abs = nil,                      --* absolute value of distance
        up_mvmnt_halt_dist_end = nil,                           --+ positive and negative xyz
        up_mvmnt_halt_dist_end_abs = nil,                       --* absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        up_mvmnt_halt_dist_from_center = nil,                   --+ positive and negative xyz
        up_mvmnt_halt_dist_from_center_abs = nil,               --* absolute value of distance
            --- closest position to start 
            --- closest position to end 
        up_closest_loc_strt = nil,                              --+ positive and negative xyz
        up_closest_dist_strt = nil,                             --* positive and negative xyz
        up_closest_dist_strt_abs = nil,                         --+ absolute value of distance
        up_closest_loc_end = nil,                               --* positive and negative xyz
        up_closest_dist_end = nil,                              --+ positive and negative xyz
        up_closest_dist_end_abs = nil,                          --* absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        up_furthest_loc_strt = nil,                             --+ positive and negative xyz
        up_furthest_dist_strt = nil,                            --* positive and negative xyz
        up_furthest_dist_strt_abs = nil,                        --+ absolute value of distance
        up_furthest_loc_end = nil,                              --* positive and negative xyz
        up_furthest_dist_end = nil,                             --+ positive and negative xyz
        up_furthest_dist_end_abs = nil,                         --* absolute value of distance
--                                                                                                                                                 <>
        --| Down
        --| Axis of a NEGATIVE y will always "detect down" and update the distance from center as 0,0,0
        --| We want to go down, so if we are blocked, deviations from this origin point are not normal paths
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        dwn_cardinal_face = nil,                                --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        dwn_cardinal_strt = nil,                                --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        dwn_cardinal_end = nil,                                 --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        dwn_mvmnt_halt_loc = nil,                               --+ positive and negative xyz
        dwn_mvmnt_halt_strt_dist = nil,                         --* positive and negative xyz
        dwn_mvmnt_halt_strt_dist_abs = nil,                     --+ absolute value of distance
        dwn_mvmnt_halt_end_dist = nil,                          --* positive and negative xyz
        dwn_mvmnt_halt_end_dist_abs = nil,                      --+ absolute value of distance
        dwn_mvmnt_halt_dist_strt = nil,                         --* positive and negative xyz
        dwn_mvmnt_halt_dist_strt_abs = nil,                     --+ absolute value of distance
        dwn_mvmnt_halt_dist_end = nil,                          --* positive and negative xyz
        dwn_mvmnt_halt_dist_end_abs = nil,                      --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        dwn_mvmnt_halt_dist_from_center = nil,                  --* positive and negative xyz
        dwn_mvmnt_halt_dist_from_center_abs = nil,              --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        dwn_closest_loc_strt = nil,                             --* positive and negative xyz
        dwn_closest_dist_strt = nil,                            --+ positive and negative xyz
        dwn_closest_dist_strt_abs = nil,                        --* absolute value of distance
        dwn_closest_loc_end = nil,                              --+ positive and negative xyz
        dwn_closest_dist_end = nil,                             --* positive and negative xyz
        dwn_closest_dist_end_abs = nil,                         --+ absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        dwn_furthest_loc_strt = nil,                            --* positive and negative xyz
        dwn_furthest_dist_strt = nil,                           --+ positive and negative xyz
        dwn_furthest_dist_strt_abs = nil,                       --* absolute value of distance
        dwn_furthest_loc_end = nil,                             --+ positive and negative xyz
        dwn_furthest_dist_end = nil,                            --* positive and negative xyz
        dwn_furthest_dist_end_abs = nil,                        --+ absolute value of distance
--                                                                                                                                                 <>
        --| Left
        --| Left will always require a turn command for movement.
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        lft_cardinal_face = nil,                                --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        lft_cardinal_strt = nil,                                --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        lft_cardinal_end = nil,                                 --* STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        lft_mvmnt_halt_loc = nil,                               --* positive and negative xyz
        lft_mvmnt_halt_strt_dist = nil,                         --+ positive and negative xyz
        lft_mvmnt_halt_strt_dist_abs = nil,                     --* absolute value of distance
        lft_mvmnt_halt_end_dist = nil,                          --+ positive and negative xyz
        lft_mvmnt_halt_end_dist_abs = nil,                      --* absolute value of distance
        lft_mvmnt_halt_dist_strt = nil,                         --+ positive and negative xyz
        lft_mvmnt_halt_dist_strt_abs = nil,                     --* absolute value of distance
        lft_mvmnt_halt_dist_end = nil,                          --+ positive and negative xyz
        lft_mvmnt_halt_dist_end_abs = nil,                      --* absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        lft_mvmnt_halt_dist_from_center = nil,                  --+ positive and negative xyz
        lft_mvmnt_halt_dist_from_center_abs = nil,              --* absolute value of distance
            --- closest position to start 
            --- closest position to end 
        lft_closest_loc_strt = nil,                             --+ positive and negative xyz
        lft_closest_dist_strt = nil,                            --* positive and negative xyz
        lft_closest_dist_strt_abs = nil,                        --+ absolute value of distance
        lft_closest_loc_end = nil,                              --* positive and negative xyz
        lft_closest_dist_end = nil,                             --+ positive and negative xyz
        lft_closest_dist_end_abs = nil,                         --* absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        lft_furthest_loc_strt = nil,                            --+ positive and negative xyz
        lft_furthest_dist_strt = nil,                           --* positive and negative xyz
        lft_furthest_dist_strt_abs = nil,                       --+ absolute value of distance
        lft_furthest_loc_end = nil,                             --* positive and negative xyz
        lft_furthest_dist_end = nil,                            --+ positive and negative xyz
        lft_furthest_dist_end_abs = nil,                        --* absolute value of distance
--                                                                                                                                                 <>
        --| Right
        --| Right will always require a turn command for movement.
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        rit_cardinal_face = nil,                                --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        rit_cardinal_strt = nil,                                --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        rit_cardinal_end = nil,                                 --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        rit_mvmnt_halt_loc = nil,                               --+ positive and negative xyz
        rit_mvmnt_halt_strt_dist = nil,                         --* positive and negative xyz
        rit_mvmnt_halt_strt_dist_abs = nil,                     --+ absolute value of distance
        rit_mvmnt_halt_end_dist = nil,                          --* positive and negative xyz
        rit_mvmnt_halt_end_dist_abs = nil,                      --+ absolute value of distance
        rit_mvmnt_halt_dist_strt = nil,                         --* positive and negative xyz
        rit_mvmnt_halt_dist_strt_abs = nil,                     --+ absolute value of distance
        rit_mvmnt_halt_dist_end = nil,                          --* positive and negative xyz
        rit_mvmnt_halt_dist_end_abs = nil,                      --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        rit_mvmnt_halt_dist_from_center = nil,                  --* positive and negative xyz
        rit_mvmnt_halt_dist_from_center_abs = nil,              --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        rit_closest_loc_strt = nil,                             --* positive and negative xyz
        rit_closest_dist_strt = nil,                            --+ positive and negative xyz
        rit_closest_dist_strt_abs = nil,                        --* absolute value of distance
        rit_closest_loc_end = nil,                              --+ positive and negative xyz
        rit_closest_dist_end = nil,                             --* positive and negative xyz
        rit_closest_dist_end_abs = nil,                         --+ absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        rit_furthest_loc_strt = nil,                            --* positive and negative xyz
        rit_furthest_dist_strt = nil,                           --+ positive and negative xyz
        rit_furthest_dist_strt_abs = nil,                       --* absolute value of distance
        rit_furthest_loc_end = nil,                             --+ positive and negative xyz
        rit_furthest_dist_end = nil,                            --* positive and negative xyz
        rit_furthest_dist_end_abs = nil,                        --+ absolute value of distance
--                                                                                                                                                 <>
        --| Back
        --| Back direction typically only works for Y axis. X or Z axis moving back just returns to starting position
        --| Back direction requires turns
        --| The center point will be applied to the above forward, up, down and then mathed here
        --| static variables for halt
            --- Direction we were facing at the time we were halted. Used to determine: up,down,left,right,back.forward
            --- halt cardinal direction from start
            --- halt cardinal direction from end
        bck_cardinal_face = nil,                                --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
        bck_cardinal_strt = nil,                                --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        bck_cardinal_end = nil,                                 --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}    
            --- This is the xyz when we encountered a block and now we have halted. position halt
            --- distance from the staring position to the halt position. And absolute version
            --- distance from the end position to the halt position. And absolute version
            --- distance from the halt position to the start position
            --- distance from the halt position to the end
        bck_mvmnt_halt_loc = nil,                               --+ positive and negative xyz
        bck_mvmnt_halt_strt_dist = nil,                         --* positive and negative xyz
        bck_mvmnt_halt_strt_dist_abs = nil,                     --+ absolute value of distance
        bck_mvmnt_halt_end_dist = nil,                          --* positive and negative xyz
        bck_mvmnt_halt_end_dist_abs = nil,                      --+ absolute value of distance
        bck_mvmnt_halt_dist_strt = nil,                         --* positive and negative xyz
        bck_mvmnt_halt_dist_strt_abs = nil,                     --+ absolute value of distance
        bck_mvmnt_halt_dist_end = nil,                          --* positive and negative xyz
        bck_mvmnt_halt_dist_end_abs = nil,                      --+ absolute value of distance
        --| dynamic variables for our relation with halt
            --- distance we are from the halt position
        bck_mvmnt_halt_dist_from_center = nil,                  --* positive and negative xyz
        bck_mvmnt_halt_dist_from_center_abs = nil,              --+ absolute value of distance
            --- closest position to start 
            --- closest position to end 
        bck_closest_loc_strt = nil,                             --* positive and negative xyz
        bck_closest_dist_strt = nil,                            --+ positive and negative xyz
        bck_closest_dist_strt_abs = nil,                        --* absolute value of distance
        bck_closest_loc_end = nil,                              --+ positive and negative xyz
        bck_closest_dist_end = nil,                             --* positive and negative xyz
        bck_closest_dist_end_abs = nil,                         --+ absolute value of distance
            --- furthest position from the start
            --- furthest position from the end
        bck_furthest_loc_strt = nil,                            --* positive and negative xyz
        bck_furthest_dist_strt = nil,                           --+ positive and negative xyz
        bck_furthest_dist_strt_abs = nil,                       --* absolute value of distance
        bck_furthest_loc_end = nil,                             --+ positive and negative xyz
        bck_furthest_dist_end = nil,                            --* positive and negative xyz
        bck_furthest_dist_end_abs = nil,                        --+ absolute value of distance


    }
end
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
            sloc = nil,                                         --+ positive and negative xyz
                --- end locaiton xyz
            eloc = nil,                                         --+ positive and negative xyz
                --- optimal pathing that the turtle records on start
                --- strtloc optimal is the xyz turtle thinks it needs to go
                --- strtloc optimal abs is the absolute the turtle thinks it needs to go.
            sloc_nav = nil,                                     --+ positive and negative xyz
            sloc_nav_abs = nil,                                 --* absolute value of distance
                --- endloc optimal is the xyz distance to be traveled from the perspective of the end destination
                --- endloc optimal abs is the absolute value the end thinks the turtle should go
            eloc_nav = nil,                                     --+ positive and negative xyz
            eloc_nav_abs = nil,                                 --* absolute value of distance
                --- storing strings for the nav priority and the compass directions
            nav_priority_input = nil,                           --* STRING
                --- cardinal direction start to end
                --- cardinal direction end to start
            sdir = nil,                                         --+ STRING ex cardinal_direc = { x = 'east', z = 'north'}
            edir = nil                                          --* STRING ex cardinal_direc = { x = 'east', z = 'north'}
        },
    --                                                                                                                                                 <>
            --| Mapping the dynamic distance for the turtle movement directly. This is outside of the Maze solver
        dynmc = {
                --- key order is to allow us to work in the correct order in a for loop
            key_order = {"slocn","slocn_nav","slocn_nav_abs","elocn","elocn_nav","elocn_nav_abs","nav","nav_abs","dirn","sdirn","edirn","axisn"},
                --- This is to record the where in the world we are. sanity check against the API "status.pctable[who_am_i.my_id].location"
                --- now dist is the xyz of the distance from right now to the end. sanity check against static
                --- now dist abs is the distance we have left to go to get to the end position.
            slocn = nil,                                        --* positive and negative xyz
            slocn_nav = nil,                                    --+ positive and negative xyz
            slocn_nav_abs = nil,                                --* absolute value of distance
                --- this records where the end location is. Use to sanity check against the end location static. 
                --- now dist is where we THINK the end destination is. Used as sanity check to compare against static.
                --- now dist abs is the absolute of how far away we are from the end destination. Used as comparison for sanity check
            elocn = nil,                                        --* positive and negative xyz
            elocn_nav = nil,                                    --+ positive and negative xyz
            elocn_nav_abs = nil,                                --* absolute value of distance
                --- Tracking the actual movement the turle has made. 
                --- Dist by axis is the xyz real world we have gone. +x will increment x, -x will decrement x
                --- dist by axis abs is the total times the turtle moves ever by the axis.
            nav = nil,                                          --* positive and negative xyz
            nav_abs = nil,                                      --+ absolute value of distance
                --- cardinal direction we are currently facing
                --- cardinal direction from now to start
                --- cardinal direction from now to end
                --- axis we are currently on
            dirn = nil,                                         --* STRING
            sdirn = nil,                                        --+ STRING
            edirn = nil,                                        --* STRING
            axisn = nil                                         --+ STRING
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
        }
}
function updateStateStatsValue(stateKey, newValue)
    local filename = "/state_stats"
    local lines = {}
    local found = false
    local file = fs.open(filename, "r")
    local newValueString
    if type(newValue) == "string" then
        newValueString = "'" .. newValue .. "'"
    elseif type(newValue) == "table" then
        if (type(newValue.x) == "string" or type(newValue.y) == "string" or type(newValue.z) == "string") then
            newValueString = "{".."x = ".."'"..tostring(newValue.x).."'"..", y = ".."'"..tostring(newValue.y).."'"..", z = ".."'"..tostring(newValue.z).."'".."}"
        else
            newValueString = "{".."x = "..tostring(newValue.x)..", y = "..tostring(newValue.y)..", z = "..tostring(newValue.z).."}"
        end
    else
        newValueString = tostring(newValue)
    end
    if file then
        while true do
            local line = file.readLine()
            if line == nil then break end
            if line:find("^" .. stateKey .. " =") then
                line = stateKey .. " = " .. newValueString
                found = true
            end
            table.insert(lines, line)
        end
        file.close()
    end
    if not found then
        table.insert(lines, stateKey .. " = " .. newValueString)
    end
    file = fs.open(filename, "w")
    if file then
        for _, line in ipairs(lines) do
            file.writeLine(line)
        end
        file.close()
    end
end
function clear_all_stats()
    local function update_move(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.stats.move[key] = value stats.updateStateStatsValue("stats_move_" .. key, value) end
        local key_order = stats.going.stats.move.key_order
        local updates = {
            function() setAndUpdate(key_order[1], 0) end,
            function() setAndUpdate(key_order[2], 0) end,
            function() setAndUpdate(key_order[3], 0) end,
            function() setAndUpdate(key_order[4], 0) end,
            function() setAndUpdate(key_order[5], 0) end,
            function() setAndUpdate(key_order[6], 0) end,
            function() setAndUpdate(key_order[7], 0) end,
            function() setAndUpdate(key_order[8], 0) end,
            function() setAndUpdate(key_order[9], 0) end,
            function() setAndUpdate(key_order[10], 0) end,
            function() setAndUpdate(key_order[11], 0) end,
            function() setAndUpdate(key_order[12], 0) end,
            function() setAndUpdate(key_order[13], 0) end,
            function() setAndUpdate(key_order[14], 0) end,
            function() setAndUpdate(key_order[15], 0) end,
            function() setAndUpdate(key_order[16], 0) end,
            function() setAndUpdate(key_order[17], 0) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_detect(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.stats.detect[key] = value; stats.updateStateStatsValue("stats_detect_" .. key, value) end
        local key_order = stats.going.stats.detect.key_order
        local updates = {
            function() setAndUpdate(key_order[1], 0) end,
            function() setAndUpdate(key_order[2], 0) end,
            function() setAndUpdate(key_order[3], 0) end,
            function() setAndUpdate(key_order[4], 0) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_vars(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.stats.vars[key] = value; stats.updateStateStatsValue("stats_vars_" .. key, value) end
        local key_order = stats.going.stats.vars.key_order
        local updates = {
            function() setAndUpdate(key_order[1], 0) end,
            function() setAndUpdate(key_order[2], 0) end,
            function() setAndUpdate(key_order[3], 0) end,
            function() setAndUpdate(key_order[4], 0) end,
            function() setAndUpdate(key_order[5], 0) end,
            function() setAndUpdate(key_order[6], 0) end,
            function() setAndUpdate(key_order[7], 0) end,
            function() setAndUpdate(key_order[8], 0) end,
            function() setAndUpdate(key_order[9], 0) end,
            function() setAndUpdate(key_order[10], 0) end,
            function() setAndUpdate(key_order[11], 0) end,
            function() setAndUpdate(key_order[12], 0) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_static(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.static[key] = value stats.updateStateStatsValue("static_" .. key, value) end
        local key_order = stats.going.static.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[4], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], nil) end,
            function() setAndUpdate(key_order[8], nil) end,
            function() setAndUpdate(key_order[9], nil) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_dynmc(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.dynmc[key] = value; stats.updateStateStatsValue("dynmc_" .. key, value) end
        local key_order = stats.going.dynmc.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[3], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], nil) end,
            function() setAndUpdate(key_order[10], nil) end,
            function() setAndUpdate(key_order[11], nil) end,
            function() setAndUpdate(key_order[12], nil) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_fwd(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.fwd[key] = value; stats.updateStateStatsValue("fwd_" .. key, value) end
        local key_order = stats.going.fwd.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], nil) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[15], nil) end,
            function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[18], nil) end,
            function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[21], nil) end,
            function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[24], nil) end,
            function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_up(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.up[key] = value; stats.updateStateStatsValue("up_" .. key, value) end
        local key_order = stats.going.up.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], nil) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[15], nil) end,
            function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[18], nil) end,
            function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[21], nil) end,
            function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[24], nil) end,
            function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_dwn(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.dwn[key] = value; stats.updateStateStatsValue("dwn_" .. key, value) end
        local key_order = stats.going.dwn.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], nil) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[15], nil) end,
            function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[18], nil) end,
            function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[21], nil) end,
            function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[24], nil) end,
            function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_lft(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.lft[key] = value; stats.updateStateStatsValue("lft_" .. key, value) end
        local key_order = stats.going.lft.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], nil) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[15], nil) end,
            function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[18], nil) end,
            function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[21], nil) end,
            function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[24], nil) end,
            function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_rit(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.rit[key] = value; stats.updateStateStatsValue("rit_" .. key, value) end
        local key_order = stats.going.rit.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], nil) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[15], nil) end,
            function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[18], nil) end,
            function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[21], nil) end,
            function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[24], nil) end,
            function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    local function update_bck(skp_lst)
        local skp = {}
        if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
        local function setAndUpdate(key, value) stats.going.bck[key] = value; stats.updateStateStatsValue("bck_" .. key, value) end
        local key_order = stats.going.bck.key_order
        local updates = {
            function() setAndUpdate(key_order[1], nil) end,
            function() setAndUpdate(key_order[2], nil) end,
            function() setAndUpdate(key_order[3], nil) end,
            function() setAndUpdate(key_order[4], nil) end,
            function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[15], nil) end,
            function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[18], nil) end,
            function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[21], nil) end,
            function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[24], nil) end,
            function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
            function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
        }
        for i, func in ipairs(updates) do if not skp[i] then func() end end
    end
    update_move({})
    update_detect({})
    update_vars({})
    update_static({})
    --update_dynmc({})
    --update_fwd({})
    --update_up({})
    --update_dwn({})
    --update_lft({})
    --update_rit({})
    --update_bck({})
end
function print_going_status(t)
    term.clear()
    term.setCursorPos(1,1)
    print(t..":")
    local function resolveTablePath(tbl, path)
        local scope = tbl
        for part in string.gmatch(path, "[^.]+") do
            scope = scope[part]
            if not scope then return nil end
        end
        return scope
    end
    local resolvedTable = resolveTablePath(stats.going, t)
    for _, key in ipairs(resolvedTable.key_order) do
        local val = resolvedTable[key]
        term.write(key..":  ")
        if type(val) == "table" then
            if val.key_order then
                for _, k in ipairs(val.key_order) do
                    local v = val[k]
                    print(k..":  ")
                    if type(v) == "table" then
                        for _, subkey in ipairs(stats.going.sub_order) do
                            term.write(tostring(subkey)..": "..tostring(v[subkey]).." ")
                        end
                    end
                end
            else
                for _, subkey in ipairs(stats.going.sub_order) do
                    term.write(tostring(subkey)..": "..tostring(val[subkey]).." ")
                end
            end
        else
            term.write(tostring(val))
        end
        print()
    end
end
--| Just making a simple way to update the largest and smallest xyz values.
--| If I fill out these variables like a check list I can do fun things later maybe
function first_min_max_xyz()
    stats.going.stats.vars.larg_x = status.pcTable[status.me].location.x
    stats.updateStateStatsValue("stats_vars_larg_x",status.pcTable[status.me].location.x)
    stats.going.stats.vars.larg_y = status.pcTable[status.me].location.y
    stats.updateStateStatsValue("stats_vars_larg_y",status.pcTable[status.me].location.y)
    stats.going.stats.vars.larg_z = status.pcTable[status.me].location.z
    stats.updateStateStatsValue("stats_vars_larg_z",status.pcTable[status.me].location.z)
    stats.going.stats.vars.smal_x = status.pcTable[status.me].location.x
    stats.updateStateStatsValue("stats_vars_smal_x",status.pcTable[status.me].location.x)
    stats.going.stats.vars.smal_y = status.pcTable[status.me].location.y
    stats.updateStateStatsValue("stats_vars_smal_y",status.pcTable[status.me].location.y)
    stats.going.stats.vars.smal_z = status.pcTable[status.me].location.z
    stats.updateStateStatsValue("stats_vars_smal_z",status.pcTable[status.me].location.z)
end
--| use the point a to point b system for the location information
--| this is to calculate which cardinal direction turtle must go to get to point B from point A
function d_math(pointA_xyz,pointB_xyz)
    local nx
    local ny
    local nz
    if pointA_xyz.x > pointB_xyz.x then nx = 'west' elseif pointA_xyz.x < pointB_xyz.x then nx = 'east' else nx = 'axis' end
    if pointA_xyz.y > pointB_xyz.y then ny = 'down' elseif pointA_xyz.y < pointB_xyz.y then ny = 'up' else ny = 'axis' end
    if pointA_xyz.z > pointB_xyz.z then nz = 'north' elseif pointA_xyz.z < pointB_xyz.z then nz = 'south' else nz = 'axis' end
    return {x = nx, y = ny, z = nz}
end
function update_move(print, skp_lst)
    -- stats.update_move(false,{1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17})
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.stats.move[key] = value stats.updateStateStatsValue("stats_move_" .. key, value) end
    local key_order = stats.going.stats.move.key_order
    local updates = {
        function() setAndUpdate(key_order[1], stats.going.stats.move.total + 1) end,        --+ 1|total
        function() setAndUpdate(key_order[2], stats.going.stats.move.pos_x + 1) end,        --* 2|pos_x
        function() setAndUpdate(key_order[3], stats.going.stats.move.pos_y + 1) end,        --+ 3|pos_y
        function() setAndUpdate(key_order[4], stats.going.stats.move.pos_z + 1) end,        --* 4|pos_z
        function() setAndUpdate(key_order[5], stats.going.stats.move.neg_x + 1) end,        --+ 5|neg_x
        function() setAndUpdate(key_order[6], stats.going.stats.move.neg_y + 1) end,        --* 6|neg_y
        function() setAndUpdate(key_order[7], stats.going.stats.move.neg_z + 1) end,        --+ 7|neg_z
        function() setAndUpdate(key_order[8], stats.going.stats.move.north + 1) end,        --* 8|north
        function() setAndUpdate(key_order[9], stats.going.stats.move.south + 1) end,        --+ 9|south
        function() setAndUpdate(key_order[10], stats.going.stats.move.east + 1) end,        --* 10|east
        function() setAndUpdate(key_order[11], stats.going.stats.move.west + 1) end,        --+ 11|west
        function() setAndUpdate(key_order[12], stats.going.stats.move.up + 1) end,          --* 12|up
        function() setAndUpdate(key_order[13], stats.going.stats.move.down + 1) end,        --+ 13|down
        function() setAndUpdate(key_order[14], stats.going.stats.move.left + 1) end,        --* 14|left
        function() setAndUpdate(key_order[15], stats.going.stats.move.right + 1) end,       --+ 15|right
        function() setAndUpdate(key_order[16], stats.going.stats.move.forward + 1) end,     --* 16|forward
        function() setAndUpdate(key_order[17], stats.going.stats.move.back + 1) end,        --+ 17|back
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('stats.move') end
end
function update_detect(print, skp_lst)
    -- stats.update_detect(false,{1,2,3,4})
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.stats.detect[key] = value; stats.updateStateStatsValue("stats_detect_" .. key, value) end
    local key_order = stats.going.stats.detect.key_order
    local updates = {
        function() setAndUpdate(key_order[1], stats.going.stats.detect.total + 1) end,      --+ 1|total
        function() setAndUpdate(key_order[2], stats.going.stats.detect.up + 1) end,         --* 2|up
        function() setAndUpdate(key_order[3], stats.going.stats.detect.down + 1) end,       --+ 3|down
        function() setAndUpdate(key_order[4], stats.going.stats.detect.forward + 1) end,    --* 4|forward
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('stats.detect') end
end
function update_vars(print, skp_lst)
    -- stats.update_vars(false,{1,2,3,4,5,6,7,8,9,10,11,12})
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.stats.vars[key] = value; stats.updateStateStatsValue("stats_vars_" .. key, value) end
    local key_order = stats.going.stats.vars.key_order
    local updates = {
        function() setAndUpdate(key_order[1], stats.going.stats.vars.tru + 1) end,          --* 1|tru
        function() setAndUpdate(key_order[2], stats.going.stats.vars.fls + 1) end,          --+ 2|fls
        function() setAndUpdate(key_order[3], stats.going.stats.vars.go + 1) end,           --* 3|go
        function() setAndUpdate(key_order[4], stats.going.stats.vars.up + 1) end,           --+ 4|up
        function() setAndUpdate(key_order[5], stats.going.stats.vars.down + 1) end,         --* 5|down
        function() setAndUpdate(key_order[6], stats.going.stats.vars.forward + 1) end,      --+ 6|forward
        function()
            if status.pcTable[status.me].location.x > stats.going.stats.vars.larg_x then
                setAndUpdate(key_order[7], status.pcTable[status.me].location.x)            --* 7|larg_x
            end
        end,
        function()
            if status.pcTable[status.me].location.y > stats.going.stats.vars.larg_y then
                setAndUpdate(key_order[8], status.pcTable[status.me].location.y)            --+ 8|larg_y
            end
        end,
        function()
            if status.pcTable[status.me].location.z > stats.going.stats.vars.larg_z then
                setAndUpdate(key_order[9], status.pcTable[status.me].location.z)            --* 9|larg_z
            end
        end,
        function()
            if status.pcTable[status.me].location.x < stats.going.stats.vars.smal_x then
                setAndUpdate(key_order[10], status.pcTable[status.me].location.x)           --+ 10|smal_x
            end
        end,
        function()
            if status.pcTable[status.me].location.y < stats.going.stats.vars.smal_y then
                setAndUpdate(key_order[11], status.pcTable[status.me].location.y)           --* 11|smal_y
            end
        end,
        function()
            if status.pcTable[status.me].location.z < stats.going.stats.vars.smal_z then
                setAndUpdate(key_order[12], status.pcTable[status.me].location.z)           --+ 12|smal_z
            end
        end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('stats.vars') end
end
function update_static(end_loc, path, print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.static[key] = value stats.updateStateStatsValue("static_" .. key, value) end
    local key_order = stats.going.static.key_order
    local updates = {
        --- sloc
        function() setAndUpdate(key_order[1], status.pcTable[status.me].location) end,
        --- eloc
        function() setAndUpdate(key_order[2], end_loc) end,
        --- sloc_nav
        function() setAndUpdate(key_order[3], {x = status.pcTable[status.me].location.x - end_loc.x, y = status.pcTable[status.me].location.y - end_loc.y, z = status.pcTable[status.me].location.z - end_loc.z}) end,
        --- sloc_nav_abs
        function() setAndUpdate(key_order[4], {x = math.abs(status.pcTable[status.me].location.x - end_loc.x), y = math.abs(status.pcTable[status.me].location.y - end_loc.y), z = math.abs(status.pcTable[status.me].location.z - end_loc.z)}) end,
        --- eloc_nav
        function() setAndUpdate(key_order[5], {x = end_loc.x - status.pcTable[status.me].location.x, y = end_loc.y - status.pcTable[status.me].location.y, z = end_loc.z - status.pcTable[status.me].location.z}) end,
        --- eloc_nav_abs
        function() setAndUpdate(key_order[6], {x = math.abs(end_loc.x - status.pcTable[status.me].location.x), y = math.abs(end_loc.y - status.pcTable[status.me].location.y), z = math.abs(end_loc.z - status.pcTable[status.me].location.z)}) end,
        --- nav_priority_input
        function() setAndUpdate(key_order[7], path) end,
        --- sdir
        function() setAndUpdate(key_order[8], stats.d_math(status.pcTable[status.me].location,end_loc)) end,
        --- edir
        function() setAndUpdate(key_order[9], stats.d_math(end_loc,status.pcTable[status.me].location)) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('static') end
end
function update_dynmc(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.dynmc[key] = value; stats.updateStateStatsValue("dynmc_" .. key, value) end
    local key_order = stats.going.dynmc.key_order
    local updates = {
        --- slocn
        function() setAndUpdate(key_order[1], status.pcTable[status.me].location) end,
        --- slocn_nav
        function() setAndUpdate(key_order[2], {x = nil, y = nil, z = nil}) end,
        --- slocn_nav_abs
        function() setAndUpdate(key_order[3], {x = nil, y = nil, z = nil}) end,
        --- elocn
        function() setAndUpdate(key_order[4], nil) end,
        --- elocn_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- elocn_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- dirn
        function() setAndUpdate(key_order[9], nil) end,
        --- sdirn
        function() setAndUpdate(key_order[10], nil) end,
        --- edirn
        function() setAndUpdate(key_order[11], nil) end,
        --- axisn
        function() setAndUpdate(key_order[12], nil) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('dynmc') end
end
function update_fwd(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.fwd[key] = value; stats.updateStateStatsValue("fwd_" .. key, value) end
    local key_order = stats.going.fwd.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('fwd') end
end
function update_up(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.up[key] = value; stats.updateStateStatsValue("up_" .. key, value) end
    local key_order = stats.going.up.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('up') end
end
function update_dwn(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.dwn[key] = value; stats.updateStateStatsValue("dwn_" .. key, value) end
    local key_order = stats.going.dwn.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('dwn') end
end
function update_lft(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.lft[key] = value; stats.updateStateStatsValue("lft_" .. key, value) end
    local key_order = stats.going.lft.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('lft') end
end
function update_rit(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.rit[key] = value; stats.updateStateStatsValue("rit_" .. key, value) end
    local key_order = stats.going.rit.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('rit') end
end
function update_bck(print, skp_lst)
    local skp = {}
    if skp_lst then for _, i in ipairs(skp_lst) do skp[i] = true end end
    local function setAndUpdate(key, value) stats.going.bck[key] = value; stats.updateStateStatsValue("bck_" .. key, value) end
    local key_order = stats.going.bck.key_order
    local updates = {
        --- dirfc
        function() setAndUpdate(key_order[1], nil) end,
        --- sdir
        function() setAndUpdate(key_order[2], nil) end,
        --- edir
        function() setAndUpdate(key_order[3], nil) end,
        --- hloc
        function() setAndUpdate(key_order[4], nil) end,
        --- hs_nav
        function() setAndUpdate(key_order[5], {x = nil, y = nil, z = nil}) end,
        --- hs_nav_abs
        function() setAndUpdate(key_order[6], {x = nil, y = nil, z = nil}) end,
        --- he_nav
        function() setAndUpdate(key_order[7], {x = nil, y = nil, z = nil}) end,
        --- he_nav_abs
        function() setAndUpdate(key_order[8], {x = nil, y = nil, z = nil}) end,
        --- nav_sh
        function() setAndUpdate(key_order[9], {x = nil, y = nil, z = nil}) end,
        --- nav_sh_abs
        function() setAndUpdate(key_order[10], {x = nil, y = nil, z = nil}) end,
        --- nav_he
        function() setAndUpdate(key_order[11], {x = nil, y = nil, z = nil}) end,
        --- nav_he_abs
        function() setAndUpdate(key_order[12], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c
        function() setAndUpdate(key_order[13], {x = nil, y = nil, z = nil}) end,
        --- h_nav_c_abs
        function() setAndUpdate(key_order[14], {x = nil, y = nil, z = nil}) end,
        --- clos_sloc
        function() setAndUpdate(key_order[15], nil) end,
        --- clos_nav_s
        function() setAndUpdate(key_order[16], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_s_abs
        function() setAndUpdate(key_order[17], {x = nil, y = nil, z = nil}) end,
        --- clo_eloc
        function() setAndUpdate(key_order[18], nil) end,
        --- clo_nav_e
        function() setAndUpdate(key_order[19], {x = nil, y = nil, z = nil}) end,
        --- clo_nav_e_abs
        function() setAndUpdate(key_order[20], {x = nil, y = nil, z = nil}) end,
        --- fur_sloc
        function() setAndUpdate(key_order[21], nil) end,
        --- fur_nav_s
        function() setAndUpdate(key_order[22], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_s_abs
        function() setAndUpdate(key_order[23], {x = nil, y = nil, z = nil}) end,
        --- fur_eloc
        function() setAndUpdate(key_order[24], nil) end,
        --- fur_nav_e
        function() setAndUpdate(key_order[25], {x = nil, y = nil, z = nil}) end,
        --- fur_nav_e_abs
        function() setAndUpdate(key_order[26], {x = nil, y = nil, z = nil}) end,
    }
    for i, func in ipairs(updates) do if not skp[i] then func() end end
    if print then stats.print_going_status('bck') end
end
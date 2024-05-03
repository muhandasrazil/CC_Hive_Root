tArgs = { ... }
cmd = tArgs[1]
id = tArgs[2]
orientation = tArgs[3]
if not tArgs[2] then
    actions.a_all_cmd(cmd)
else
    actions.a_all_cmd(cmd,id,orientation)
end
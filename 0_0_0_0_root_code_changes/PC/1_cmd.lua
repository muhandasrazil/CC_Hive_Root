tArgs = { ... }
ex_com = {}
ex_com_val = {}
for i, v in ipairs(tArgs) do
    if i>3 then
        table.insert(ex_com,v)
    end
end

--for _, step in ipairs(ex_com) do
--    for _, item in ipairs(step) do
--        print(item)
--        table.insert(ex_com_val,{item})
--    end
--end

local ex_com_text = table.concat(ex_com)

local function all_control()
    rednet.broadcast(tArgs[2],'usrcmd')
    sleep(1)
    if tArgs[2] == 's' then
        os.shutdown()
    elseif tArgs[2] == 'r' then
        os.reboot()
    else
        print("Not a valid command.")
    end
end

local function turtle_control()
    print("sending Command:",tArgs[3],"to",tArgs[2])
    rednet.send(tonumber(tArgs[2]),{cmd = tArgs[3], arg = ex_com_text},'usrcmd')
    print(ex_com_text)

end

local function pc_control()
    print("no commands yet")
end

if tArgs[1] == 'a' then
    all_control()
elseif tArgs[1] == 't' then
    turtle_control()
elseif tArgs[1] == 'p' then
    pc_control()
end
-- Continuously receive rednet messages
while true do
    local senderId, message, protocol = rednet.receive('usrcmd')
    if message == 's' then
        os.shutdown()
    elseif message == 'r' then
        os.reboot()
    else
        print(message.cmd)
        print(message.arg)
        --actions[message.cmd](message.arg)
        print("request")
    end
end
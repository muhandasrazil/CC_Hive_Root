local my_self_id = os.getComputerID()
function waitForWakeUp()
    while true do
        actions.getAllCompData()
        local senderId, message, protocol = rednet.receive('wake_up')
        if message == 'wake_up' then
            print("Received wake_up message. Restarting get_info loop.")
            get_info()
        elseif message == 'update_me' then
            local id2, receivedData, protocol2 = rednet.receive('find_me')
            if receivedData then
                if actions.pcTable[senderId] then
                    actions.updatePcTable(receivedData,senderId)
                else
                    actions.writeToPcTable(receivedData, senderId)
                end
            end
        elseif message == 's' then
            os.shutdown()
        elseif message == 'r' then
            os.reboot()
        elseif message == 'north' or message == 'south' or message == 'east' or message == 'west' then
            actions.updateStateValue("orientation",message)
            actions.updateAndBroadcast()
            sleep(1)
        else 
            return true
        end
    end
end
function get_info()
    timeout_count = 0
    local increment_counter = 2
    while timeout_count < increment_counter do
        actions.getAllCompData()
        local senderId, message, protocol = rednet.receive('find_me', 2)
        if not senderId then
            print("Timeout " .. timeout_count)
            if timeout_count >= increment_counter then
                print("now waiting for new responses")
                break
            end
            local stateData = actions.readStateData()
            local dataToSend = textutils.serialize(stateData)
            rednet.broadcast(dataToSend, 'find_me')
            timeout_count = timeout_count + 1
        else
            local receivedData = textutils.unserialize(tostring(message))
            if message.my_id == my_self_id then
                print("Ignoring own broadcast")
            else
                term.clear()
                term.setCursorPos(1,1)
                print("Timeout " .. timeout_count)
                if actions.pcTable[senderId] then
                    print("Known sender ID: " .. senderId .. ", forwarding...")
                    for id in pairs(actions.readCurrentPcData().pc) do
                        if id ~= senderId and id ~= my_self_id then
                            rednet.send(tonumber(id), dataToSend, 'find_me')
                            print("Forwarding to ID: " .. id)
                        end
                    end
                else
                    print("Unknown sender ID: " .. senderId .. ", adding new entry...")
                    actions.writeToPcTable(receivedData, senderId)
                    timeout_count = 0
                end
            end
        end
    end
    term.clear()
    term.setCursorPos(1,1)
    print("now waiting for new responses")
end
actions.getAllCompData()
if not actions.pcTable[my_self_id] then
    local stateData = actions.readStateData()
    actions.writeToPcTable(stateData, stateData.my_id)
    rednet.broadcast('wake_up','wake_up')
    sleep(0.5)
    local dataToSend = textutils.serialize(stateData)
    rednet.broadcast(dataToSend, 'find_me')
else
    actions.updateAndBroadcast()
end
get_info()
waitForWakeUp()
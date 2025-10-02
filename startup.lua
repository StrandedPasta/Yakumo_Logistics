local modem = peripheral.find("modem")

turtle.select(4)
modem.open(2)
while true do
    local event, side, channel, replyChannel, message, distance
    repeat
    event, side, channel, replyChannel, message, distance = os.pullEvent("modem_message")
    until channel == 2
    if message == "craft" then
        local complete = turtle.craft()
        modem.transmit(1,2,complete)
    end
end
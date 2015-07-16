
if use_date_time == true then

    print(" Getting time...")

    -- do a HEAD request and extract date and time from the response headers 'Date' field
    conn = net.createConnection(net.TCP, 0)        
    conn:on("receive", function(conn, payload)
        -- if got response...
        if string.find(payload, "HTTP/1.1 200 OK") then

            -- get the 'Date' header field (Example: 'Date: Tue, 15 Nov 1994 08:12:31 GMT')
            res = string.sub(payload, string.find(payload, "Date: ") + 6, string.find(payload, "Date: ") + 30)

            -- extract date
            date = string.sub(res, 0, string.find(res, ":") - 3)

            -- TODO: date foo

            -- extract time
            time = string.sub(res, string.find(res, ":") - 2, string.find(res, ":") + 5)
            
            -- extract hours, minutes and seconds
            hours = string.sub(time, 0, 2)
            minutes = string.sub(time, 4, 5)
            seconds = string.sub(time, 7, 8)

            -- time correction hack (add time_offset and handle a potential overflow)
            hours = (hours+time_offset) % 24

            -- re-add the leading zero which might just got "trunculated"
            hours = string.format("%02d", hours)

            -- time format: 00:00:00
            time = hours..":"..minutes
            -- time format: 00:00
            time_n = hours..":"..minutes..":"..seconds
            
            -- print date and time
            print(" -> Date: " ..date)
            print(" -> Time: " ..time..":"..seconds)
            print("")
            
            -- collect some garbage (NOTE: test if still neccessary)
            collectgarbage()
            
            -- make the Pushingbox Scenario request
            print(" Triggering Scenario " ..send_warning.. " ("..bat_info..")...")
            if DEBUG ~= true then
                dofile("trigger_scenario.lc")
            end

       else
          print(payload)
          print(" -> FAIL\n")
       end

    end)
    conn:connect(80, time_server_ip)
    conn:send("HEAD / HTTP/1.1\r\n"..
       "Host: " ..time_server_ip.. "\r\n"..
       "Connection: close\r\n"..
       "Accept: */*\r\n"..
       "\r\n")
    conn = nil

else
    date = "0"
    time = "0"
    seconds = "0"

    print(" Triggering Scenario " ..send_warning.. " ("..bat_info..")...")
    if DEBUG ~= true then
        dofile("trigger_scenario.lc")
    end
end


    -- prepare the GET parameter
    data = ""
    if use_temp_sensor then
        data = "&temperatur=" ..ds_temp
    end
    if use_battery_check then
        data = data.. "&vbat=" ..string.format("%.2f", vin).. "&bat_info=" ..bat_info
    end
    if use_wifi_strength then
        data = data.. "&rssi=" ..rssi.. "&quality=" ..quality
    end
    if use_date_time then
        -- sanitize unvalid chars
        date = date:gsub("%,", "")
        date = date:gsub("% ", "+")

        -- date %(d, m, y, Y)
        --data = data.. "&d=" ..d.. "&m=" ..m.. "&y=" ..y.. "&Y=" ..Y
        -- date %(a, A, b, B, )
        --data = data.. "&a=" ..a.. "&A=" ..A.. "&b=" ..b.. "&B=" ..B

        -- time
        data = data.. "&date=" ..date.. "&time=" ..time.. "&seconds=" ..seconds
        --data = data.. "&hours=" ..hours.. "&minutes=" ..minutes
    end
    data = data.. "&ip_time=" ..ip_time.. "&ip=" ..wifi.sta.getip()
    --print("Data: "..data)
    
    -- send the request
    conn = net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload)
        if string.find(payload, "HTTP/1.1 200 OK") then
            print(" -> SUCCESS\n")
        else
            print(payload)
            print(" -> FAIL\n")
        end
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(" DeepSleeping...  ")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(" Heap: " ..node.heap()/1000 .." KB")
        print(" Timer: " ..string.format("%.2f", tmr.now()/1000000).. " Seconds\n")
        -- infinite DeepSleep
        node.dsleep(0, 1)
    end)
    -- but first get the ip from the DNS
    conn:dns('api.pushingbox.com', function(conn, ip)
        conn:connect(80, ip)
        conn:send("GET /pushingbox?devid="..devid..data.. 
                " HTTP/1.1\r\n"..
                "Host: api.pushingbox.com\r\n"..
                "Connection: close\r\n"..
                "Accept: */*\r\n"..
                "\r\n")
    end)
    conn = nil

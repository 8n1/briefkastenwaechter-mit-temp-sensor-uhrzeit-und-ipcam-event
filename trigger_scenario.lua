-- Trigger Pushingbox Scenario
-- Example using Pushingbox variables

function triggerPushingboxScenario(date, time)
    date = date:gsub("%,", "")
    date = date:gsub("% ", "+")
           
    conn = net.createConnection(net.TCP, 0)
    conn:on("receive", function(conn, payload)
        if string.find(payload, "HTTP/1.1 200 OK") then
            print(" -> SUCCESS\n")
        else
            print(payload)
            print(" -> FAIL\n")
        end
        -- Go to deep sleep anyway and never wake up
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(" DeepSleeping...  ")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        node.dsleep(0, 1)
    end)
    conn:dns('api.pushingbox.com', function(conn, ip)
        conn:connect(80, ip)
        conn:send("GET /pushingbox?devid=" ..devid.. "&temperatur=" ..temperature.. "&date=" ..date.. "&time=" ..time.. " HTTP/1.1\r\n"..
            "Host: api.pushingbox.com\r\n"..
            "Connection: close\r\n"..
            "Accept: */*\r\n"..
            "\r\n")
    end)
    conn = nil
end

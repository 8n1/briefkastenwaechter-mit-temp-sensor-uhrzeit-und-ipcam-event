-- Launches a Pushingbox Scenario with some variables, then goes into cyclic or infinite DeepSleep

-- measure the time it takes to get a respone
local re_timer = tmr.now()/1000/1000

-- the last thing we append is the time it took to reach this point
data = data.."&req_time="..string.format("%.2f", re_timer)
--print("Query String: '"..data.."'")

-- check if on:receive event already got called (bugfix)
local got_response = false

-- create the connection
local dnsConn = net.createConnection(net.TCP, 0)
-- first get the ip...
dnsConn:dns('api.pushingbox.com', function(pushConn, ip) 
    pushConn:on("receive", function(conn, payload)
        if not already_done then
            got_response = true
            if string.find(payload, "HTTP/1.1 200 OK") then
                -- calculate the time it took to get the response
                re_timer = string.format("%.2f", tmr.now()/1000/1000-re_timer)
                print(" -> SUCCESS (" ..re_timer .."s)")
                -- activate deep sleep
                print("~~~~~~~~~~~~~~~~~~~~~~~~~")
                print(" DeepSleeping...")
                dofile("deepsleep.lc")
            else
                fail_type = "api_fails"
                dofile("log_fails.lc")
                print(payload)
                print("\n -> FAIL\n")

                if not did_a_retry then
                    did_a_retry = true
                    print(" Retrying to launch Scenario...")
                    fail_safe("launch_scenario.lc", "req_fails")
                else
                    print("~~~~~~~~~~~~~~~~~~~~~~~~~")
                    print(" Forcing DeepSleep after Pushingbox API Fail #2...")
                    fail_type = "api_fails"
                    dofile("log_fails.lc")
                    dofile("deepsleep.lc")
                end
            end
        end
    end)
    -- ...then send the request
    pushConn:connect(80, ip)
    pushConn:send("GET /pushingbox?devid=" ..devid ..data .." HTTP/1.1\r\n"
        .."Host: api.pushingbox.com\r\n"
        .."User-Agent: NodeMCU/0.9.5\r\n"
        .."Connection: close\r\n"
        .."Accept: */*\r\n"
        .."\r\n")
end)
dnsConn = nil

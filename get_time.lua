-- Get time from webserver by parsing the HTTP requests "Date" header
-- see http://benlo.com/esp8266/esp8266Projects.html (-> Ask Google for the Time)

conn = net.createConnection(net.TCP, 0)        
conn:on("receive", function(conn, payload)
    if string.find(payload, "HTTP/1.1 200 OK") then
        res = string.sub(payload, string.find(payload,"Date: ")+6, string.find(payload,"Date: ")+30)
           
        date = string.sub(payload, string.find(payload,"Date: ")+6, string.find(payload,"Date: ")+21)
        time = string.sub(res, string.find(res,":")-2, string.find(res,":")+5)
           
        hours = string.sub(time, 0, 2)
        min_secs = string.sub(time, 3, 8)
        calc_hours = (hours+time_offset) % 24
   
        if calc_hours < 10 then
            calc_hours = "0"..calc_hours
        end
   
        time = calc_hours..min_secs
           
        print(" -> Datum: "..date)
        print(" -> Zeit: "..time)
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")

        res, hours, min_secs, calc_hours = nil
        collectgarbage()
           
        print(" Triggering Pushingbox Scenario...")
        dofile("trigger_scenario.lc")
        triggerPushingboxScenario(date, time)
   else
      print(payload)
      print(" -> FAIL")
   end
end)
conn:connect(80, time_server_ip)
conn:send("HEAD / HTTP/1.1\r\n"..
   "Host: "..time_server_ip.."\r\n"..
   "Connection: close\r\n"..
   "Accept: */*\r\n"..
   "\r\n")
conn = nil

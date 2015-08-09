-- Trigger an Axis IP cam event with HTTP BASIC authentication

-- Create the connection
local conn = net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload)
    if string.find(payload, "HTTP/1.0 200 OK") then
        print(" -> Cam Event: SUCCESS\n")
    else
        print(payload)
        print(" -> Cam Event: FAIL\n")
    end
end)
conn:connect(cam_port, cam_ip)
conn:send("GET " ..cam_event_url.. " HTTP/1.1\r\n"..
    "Host: " ..cam_ip.. ":" ..cam_port.. "\r\n"..
    "Authorization: Basic " ..cam_base64_pass.. "\r\n"..
    "Connection: close\r\n"..
    "Accept: */*\r\n"..
    "\r\n")

-- clean up
cam_port, cam_ip, cam_event_url, cam_base64_pass = nil
conn = nil 

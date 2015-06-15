-- Trigger an Axis IP cam event

-- Used global variables:
--cam_ip = ""
--cam_port = ""
--event_url = ""
--base64_pass = ""

conn = net.createConnection(net.TCP, 0)
conn:on("receive", function(conn, payload)
    if string.find(payload, "HTTP/1.0 200 OK") then
        print(" -> SUCCESS")
    else
        print(payload)
        print(" -> FAIL")
    end
end)
conn:connect(cam_port, cam_ip)
conn:send("GET " ..event_url.. " HTTP/1.1\r\n"..
    "Host: " ..cam_ip.. ":" ..cam_port.. "\r\n"..
    "Authorization: Basic " ..base64_pass.. "\r\n"..
    "Connection: close\r\n"..
    "Accept: */*\r\n"..
    "\r\n")
conn = nil

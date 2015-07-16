--https://github.com/nodemcu/nodemcu-firmware/wiki/nodemcu_api_en#wifistagetap
   
--get RSSI for currently configured AP
function listap(t)
    for bssid,v in pairs(t) do
        local ssid, local_rssi, authmode, channel = string.match(v, "([^,]+),([^,]+),([^,]+),([^,]+)")
        rssi = local_rssi
        quality = 2 * (rssi + 100)
    end
end

ssid, tmp, bssid_set, bssid = wifi.sta.getconfig() 
scan_cfg = {}
scan_cfg.ssid = ssid 

if bssid_set == 1 then 
    scan_cfg.bssid = bssid 
else 
    scan_cfg.bssid = nil 
end

scan_cfg.channel = wifi.getchannel()
scan_cfg.show_hidden = 0
ssid, tmp, bssid_set, bssid = nil, nil, nil, nil
wifi.sta.getap(scan_cfg, 1, listap)

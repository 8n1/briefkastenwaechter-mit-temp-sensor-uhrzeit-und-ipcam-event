
-- Set to Station Mode
wifi.setmode(wifi.STATION)

-- Load user config
dofile("config.lua")

if use_static_ip then
    wifi.sta.setip({ip=sensor_ip, netmask=sensor_netmask, gateway=sensor_gateway})
end

-- Connect to AP
wifi.sta.connect()

-- Small intro
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter       ")
print(" mit Temperatur, Uhrzeit,          ")
print(" IP Cam und Batterie-ueberwachung  ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

-- Only use a single devid?
if use_single_devid then
    print("Single devid")
    warn_devid1 = devid
    warn_devid2 = devid
end

-- Startup time 
startup_time = dhcp_startup_time
if use_static_ip then
    print("Static IP\n")
    startup_time = static_startup_time
else
    print("DHCP\n")
end

-- Get Wifi strength
rssi = 0
quality = 0
if use_wifi_strength then
    dofile("get_rssi.lc")
end

-- Get battery voltage
vin = 0
send_warning = 0
--bat_info
if use_battery_check then
    dofile("get_battery_voltage.lc")
    vin = check_volts()

    print("Batterie Spannung: "..string.format("%.2f", vin).."V")
    print("Warn Modus: "..send_warning)
    print("Bat: "..bat_info.."\n")

    check_volts = nil
end
    
-- Wait until we have an IP from the AP
tmr.alarm(0, startup_time, 1, function()
    print(" Checking IP...")
    if wifi.sta.getip() == nil then
        tmr_now = tmr.now()
        -- Do nothing
    else
        tmr.stop(0)

        -- Time to get an IP
        ip_time = string.format("%.2f", tmr.now()/1000/1000)

        -- Print ip and wifi strength quality
        print(" -> IP: " ..wifi.sta.getip())
        if use_wifi_strength then
            print(" -> RSSI is: "..rssi.."dBm")
            print(" -> Quality is: "..quality.."%\n")
        else
            print("")
        end

        -- Get temperature
        ds_temp = 0
        if use_temp_sensor then
            print(" Getting temperature...  ")
            dofile("get_ds_temp.lc")
            debug = 1
            dofile("get_ds_temp.lc")
            print(" -> Temperature: " ..ds_temp.. "'C")
            print("")
        end

        -- Activate ip cam event
        if use_ipcam_event then
            print(" Triggering IP Cam Event...")
            dofile("trigger_ipcam_event.lc")
            print("")
        end
        
        -- Get time and activate Pushingbox Scenario
        dofile("get_time.lc")
    end
end)

-- Force deep sleep if e.g. AP is not reachable
tmr.alarm(1, timout*1000, 0, function()
    print("\n~~~~~~~~~~~~~~~~~~~~~~~")
    print(" Forcing DeepSleep...    ")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~")
    if DEBUG ~= true then
        node.dsleep(0, 1)
    end
end)

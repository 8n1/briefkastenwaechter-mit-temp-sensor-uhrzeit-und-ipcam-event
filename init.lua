--------------------------------------------
-- NodeMCU Briefkastenwächter
--  Version 1.3 - Mit Wlan Signalstaerke - Beide wieder vereint
--------------------------------------------

--HEAP_DEBUG = true

-- Load user config
dofile("config.lc")

--------------------------------------
-- Intro
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter  ")
print("  mit Logging - v1.3          ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

--------------------------------------
-- GET Query String
data = ""

--------------------------------------
-- Check logfiles, print/append content to the query string
dofile("print_logs.lc")

--------------------------------------
-- Get the wifi strength (it takes a second to get the rssi)
if USE_WIFI_STRENGTH then
    dofile("get_rssi.lc")
end

--------------------------------------
-- Read the temp sensor but ignore the first reading because it is old
if USE_TEMP_SENSOR then
    -- (small delay to let the heap recover)
    tmr.alarm(2, 200, 0, function()
        ds_debug = true
        dofile("get_temp.lc")
    end)
end

--------------------------------------
-- ip check loop 
-- (also lets the battery, heap and tempsensor recover)
local wifi_counter = 0
tmr.alarm(0, 1500, 1, function()
    --------------------------------------
    -- Re-read temperature and append it
    if USE_TEMP_SENSOR then
        dofile("get_temp.lc")
        print(" Temperature: " ..ds_temp .."'C\n")
        ds_temp, USE_TEMP_SENSOR = nil
    end
    
    --------------------------------------
    -- Calculate the battery voltage and append it
    if USE_BATTERY_CHECK then
        dofile("get_vcc.lc")
        print(" Battery Voltage: " ..vin .."V")
        print(" Bat Info: " ..bat_info)
        print(" Launching Scenario: " ..devid .." " ..mod .."\n")
        mod, vin, bat_info, USE_BATTERY_CHECK = nil
    end
    
    --------------------------------------
    -- Check if we got a IP (DHCP)
    if wifi.sta.getip() == nil then
        print(" Checking IP...")
    else
        tmr.stop(0)
        
        --------------------------------------
        -- Collect some Wifi information...
        local ip = wifi.sta.getip()
        local ip_time = string.format("%.2f", tmr.now()/1000/1000)
        print(" -> Got IP: " ..ip .." (" ..ip_time .."s)\n")
        -- ...and append it to Query String
        data = data .."&ip=" ..ip .."&ip_time=" ..ip_time
        ip, ip_time = nil
        
        --------------------------------------
        -- Print wifi strength
        if USE_WIFI_STRENGTH then
            print(" -> RSSI is: "..rssi.."dBm")
            print(" -> Quality is: "..quality.."%\n")
            rssi, quality, listap, USE_WIFI_STRENGTH = nil
        end
        
        --------------------------------------
        -- Trigger IP Cam Event
        if USE_IPCAM_EVENT then
            print(" Triggering IP Cam Event...\n")
            dofile("trigger_ipcam_event.lc")
            USE_IPCAM_EVENT = nil
        end
        
        --------------------------------------
        -- Load fail_save() function
        dofile("fail_save.lc")
        
        --------------------------------------
        -- Get the date/time (append it) and launch the Pushingbox Scenario / small delay to let the heap recover
        tmr.alarm(0, 300, 0, function()
            if USE_DATE_TIME then
                print(" Getting time...")
                dofile("get_time.lc")
            else
                print(" Launching Pushingbox Scenario...")
                fail_safe("launch_scenario.lc", "req_fails")
            end
        end)
    end
    
    --------------------------------------
    -- Check max 8 times if got a IP (~10s)
    if wifi_counter == 8  then
        tmr.stop(0)
        
        print(" No wifi connection. (Status: " ..wifi.sta.status() ..")")
        print("\n Logging fail...")
        fail_type = "wifi_fails"
        dofile("log_fails.lc")
        fail_type = nil
        
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        print(" Forcing DeepSleep...")
        dofile("deepsleep.lc")
    end
    wifi_counter = wifi_counter + 1
end)

--------------------------------------
-- Debug heap
if HEAP_DEBUG then
    tmr.alarm(4, 100, 1, function()
        print(node.heap())
    end)
end

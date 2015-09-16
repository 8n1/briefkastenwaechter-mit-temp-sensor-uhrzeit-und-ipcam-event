--------------------------------------------
-- NodeMCU Briefkastenwaechter
--  Version 1.4 - Fehlerbehebung und Logging verbessert, Mit Reset Möglichkeit
--------------------------------------------

--HEAP_DEBUG = true

-- Load user config
dofile("config.lc")

--------------------------------------
-- Intro
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter v1.4  ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

--------------------------------------
-- IO Configuration
--------------------------------------
-- setup the reset signal pin
--gpio.mode(RESET_SIGNAL_PIN, gpio.OUTPUT)
-- setup the clear_logs_pin as INPUT and activate the PULLUP
gpio.mode(clear_logs_pin, gpio.PULLUP)

--------------------------------------
-- GET Query String
data = ""

--------------------------------------
-- Check logfiles, print/append content to the query string
dofile("check_logs.lc")

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
-- ip check loop (also lets the battery, heap and tempsensor recover)
local wifi_counter = 0
tmr.alarm(0, 1500, 1, function()
    --------------------------------------
    -- Re-read the temperature and append it
    if USE_TEMP_SENSOR then
        dofile("get_temp.lc")
        print(" Temperature: " ..ds_temp .."'C\n")
        ds_temp = nil
    end
    USE_TEMP_SENSOR = nil
    
    --------------------------------------
    -- Calculate the battery voltage and append it
    if USE_BATTERY_CHECK then
        dofile("get_vcc.lc")
        print(" Battery Voltage: " ..vin .."V")
        print(" Bat Info: " ..bat_info)
        print(" Launching Scenario: " ..devid .." " ..mod .."\n")
        mod, vin, bat_info = nil
    end
    USE_BATTERY_CHECK = nil
    
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
        -- Print wifi strength  (already got appended in get_rssi.lc)
        if USE_WIFI_STRENGTH then
            if rssi ~= nil then
                print(" -> RSSI is: "..rssi.."dBm")
                print(" -> Quality is: "..quality.."%\n")
                rssi, quality, listap = nil
            else
                print(" -> Could not find AP: " ..SSID)
            end
        end
        USE_WIFI_STRENGTH = nil
        
        --------------------------------------
        -- Trigger IP Cam Event
        if USE_IPCAM_EVENT then
            print(" Triggering IP Cam Event...\n")
            dofile("trigger_ipcam_event.lc")
        end
        USE_IPCAM_EVENT = nil
        
        --------------------------------------
        -- Load fail_save() function
        dofile("fail_save.lc")
        
        --------------------------------------
        -- Get the date/time, append it and launch the Pushingbox Scenario / small delay to let the heap recover
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
    -- Check max 8 times if got a IP (~15s)
    if wifi_counter == 10  then
        tmr.stop(0)
        print(" No wifi connection. (Status: " ..wifi.sta.status() ..")")
        print("\n Logging wifi fail...")
        fail_type = "wifi_fails"
        dofile("log_fails.lc")
        
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

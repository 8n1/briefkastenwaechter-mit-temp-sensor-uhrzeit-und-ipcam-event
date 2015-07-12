-- Load user config
dofile("config.lua")

-- Small intro
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter       ")
print(" mit Temperatur, Uhrzeit,          ")
print(" IP Cam und Batterie-ueberwachung  ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

-- If just want to use a single devid
if use_single_devid == true then
    print("Single devid")
    warn_devid1 = devid
    warn_devid2 = devid
end

print("")

-- Check battery voltage and set 'send_warning', 'devid' and 'bat_info'
vin = 0
send_warning = 0
if use_battery_check == true then
    dofile("check_volts.lc")
    vin = check_volts()

    -- Print some informations
    print("Batterie Spannung: "..string.format("%.2f", vin).."V")
    print("Warn Modus: "..send_warning)
    print("Bat: "..bat_info.."\n")

    check_volts = nil
end

-- Wait until we have an IP from the AP
tmr.alarm(0, 1000, 1, function()
    print(" Checking IP...")
    if wifi.sta.getip() == nil then
        -- Do nothing
    else
        dhcp_time = string.format("%.2f", tmr.now()/1000/1000)
        tmr.stop(0)
        print(" -> IP: " ..wifi.sta.getip().. "\n")

        -- Get ds temperature
        if use_temp_sensor == true then
            print(" Getting temperature...  ")
            dofile("ds_init.lc")
            debug = 1
            dofile("ds_init.lc")
            print(" -> Temperature: " ..ds_temp.. "'C")
            print("")
        else
            ds_temp = 0
        end

        -- Activate ip cam event
        if use_ipcam_event == true then
            print(" Triggering IP Cam Event...")
            dofile("trigger_ipcam_event.lc")
            print("")
        end
        
        -- Get time and trigger Pushingbox notification
        print(" Getting time...")
        dofile("get_time.lc")
    end
end)

-- Force deep sleep if e.g. AP is not reachable
tmr.alarm(1, timout*1000, 0, function()
    print("\n~~~~~~~~~~~~~~~~~~~~~~~")
    print(" Forcing DeepSleep...    ")
    print("~~~~~~~~~~~~~~~~~~~~~~~~~")
    node.dsleep(0, 1)
end)

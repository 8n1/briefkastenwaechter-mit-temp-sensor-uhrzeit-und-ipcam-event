--------------------------------------
-- WIFI configuration (only needs to be done once)
--------------------------------------
wifi.setmode(wifi.STATION)
--wifi.sta.config("SSID", "PASSWD")
wifi.sta.connect()

--------------------------------------
-- Pushingbox device id
devid = "xxxxx"
--------------------------------------
-- Temperatur Sensor pin (nodemcu I/O Index)
tempsensor_pin = 4
--------------------------------------
-- Decimal places for sensor value
precision = 1
--------------------------------------
-- Server to get the time from (not NTP)
time_server_ip = "192.168.1.123"
--------------------------------------
-- Time offset
time_offset = 1
--------------------------------------
-- IP cam config
cam_ip = "192.168.1.18"
cam_port = "8001"
event_url = "/axis-cgi/io/virtualinput.cgi?action=6:/5000"
base64_pass = "am9oOmpvaA=="
--------------------------------------

print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" NodeMCU Briefkastenwaechter     ")
print(" mit Temp-Sensor,Uhrzeit und     ")
print(" IP Cam Event                    ")
print("~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")

-- Read temperature sensor
function getTemperature(sensor_pin)
    sensor = require("ds18b20")
    
    sensor.setup(sensor_pin)
    temp = sensor.read()
    if temp == nil then
        print("Couldn't read sensor. Check wiring")
        temp = 0
    end
    
    return string.format("%."..precision.."f", temp)
end
-- ignore first reading (it's old because it was taken before going to DeepSleep)
getTemperature(tempsensor_pin)

-- wait until we have an IP from the AP
tmr.alarm(0, 1000, 1, function()
    print(" Checking IP...")
    if wifi.sta.getip() == nil then
        -- do nothing
    else
        print(" -> IP: "..wifi.sta.getip())
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        tmr.stop(0)

        -- get ds temperature
        print(" Getting temperature...  ")
        temperature = getTemperature(tempsensor_pin)
        print(" -> Temperature: " ..temperature.. "'C")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")
        
        print(" Triggering IP Cam Event...")
        dofile("trigger_ipcam_event.lc")
        print("~~~~~~~~~~~~~~~~~~~~~~~~~")

        -- Get time from webserver
        print(" Getting time...")
        dofile("get_time.lc")
    end
end)

-- force deep sleep if e.g. AP is not reachable
tmr.alarm(1, 10000, 0, function()
    print("~~~~~~~~~~~~~~~~~~~~~~")
    print(" Forcing DeepSleep...")
    print("~~~~~~~~~~~~~~~~~~~~~~")
    node.dsleep(0,1)
end)

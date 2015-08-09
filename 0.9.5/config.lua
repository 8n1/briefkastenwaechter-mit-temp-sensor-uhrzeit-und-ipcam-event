
--------------------------------------
-- SET FEATURES
--------------------------------------
use_battery_check 	= true	-- battery
use_temp_sensor 	= true	-- temp
use_date_time 		= true 	-- date
use_ipcam_event 	= true	-- ipcam

use_single_devid 	= true 	-- only set to false if use_battery_check = true

use_wifi_strength 	= true	-- only available since nodemcu_float_0.9.6-dev_20150627

--------------------------------------
-- WIFI config
--------------------------------------
--wifi.sta.config("SSID", "PASSWD")	-- only needs to be done once - ESP saves wifi credentials in the flash memory

--------------------------------------
-- Pushingbox device id
--------------------------------------
devid = "xxxxx"

--------------------------------------
-- if use_battery_check set:
--------------------------------------
-- adc vref
vref = 0.985
-- Voltage divider values
r1 	= 33000
r2 	= 10000
-- Standard bat info 
bat_info 	= "OK"

-- First Warning Voltage, devid and bat info
warn_volt1 	= 3.7
warn_devid1	= "xxxxx"
warn_info1 	= "50%"
-- Second Warning Voltage, devid and bat info
warn_volt2 	= 3.3
warn_devid2	= "xxxxx"
warn_info2 	= "20%"

--------------------------------------
-- if use_temp_sensor set:
--------------------------------------
-- Temperature sensor pin (nodemcu I/O Index)
tempsensor_pin = 4
-- Decimal places for sensor value
precision = 1

--------------------------------------
-- if use_date_time set:
--------------------------------------
-- Webserver to get the time from (not NTP)
time_server_ip = "192.168.1.123"
-- Time offset
time_offset = 2

--------------------------------------
-- if use_ipcam_event set:
--------------------------------------
cam_ip 		= "192.168.1.18"
cam_port 	= 8001
event_url 	= "/axis-cgi/io/virtualinput.cgi?action=6:/5000"
base64_pass = "am9oOmpvaA=="


--------------------------------------
-- dev stuff
--------------------------------------
 dhcp_startup_time	= 1000
--------------------------------------
 timout = 10
--------------------------------------


--------------------------------------
-- SET FEATURES
--------------------------------------
use_static_ip		= false -- static ip

use_battery_check 	= true	-- battery
use_temp_sensor 	= true	-- temp
use_date_time 		= true 	-- date
use_ipcam_event 	= false	-- ipcam

use_single_devid 	= true 	-- depends on battery_check

use_wifi_strength 	= false	-- only available since nodemcu_float_0.9.6-dev_20150627

--------------------------------------
-- WIFI config
--------------------------------------
--wifi.sta.config("SSID", "PASSWD")	-- only needs to be done once - ESP saves wifi credentials in the flash memory

--------------------------------------
-- if use_static_ip set:
--------------------------------------
sensor_ip	= "192.168.0.126"
sensor_netmask 	= "255.255.255.0"
sensor_gateway	= "192.168.0.1"

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
-- First Warning Voltage
warn_volt1 	= 3.7
warn_devid1	= "xxxxx"
warn_info1 	= "50%"
-- Second Warning Voltage
warn_volt2 	= 3.3
warn_devid2	= "xxxxx"
warn_info2 	= "20%"

--------------------------------------
-- if use_temp_sensor set:
--------------------------------------
-- Temperature sensor pin (nodemcu I/O Index)
tempsensor_pin = 2
-- Decimal places for sensor value
precision = 1

--------------------------------------
-- if use_date_time set:
--------------------------------------
-- Webserver to get the time from (not NTP)
time_server_ip = "192.168.0.123"
-- Time offset
time_offset = 2

--------------------------------------
-- if use_ipcam_event set:
--------------------------------------
cam_ip 		= "192.168.0.18"
cam_port 	= 8001
event_url 	= "/axis-cgi/io/virtualinput.cgi?action=6:/5000"
base64_pass = "am9oOmpvaA=="


--------------------------------------
-- DEV stuff
 -------------------------------------
 dhcp_startup_time	= 1000
 static_startup_time 	= 500
--------------------------------------
 timout = 10
--------------------------------------

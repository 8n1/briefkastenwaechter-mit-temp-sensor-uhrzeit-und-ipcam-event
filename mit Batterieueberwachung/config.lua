
use_battery_check = true
use_temp_sensor = true
use_ipcam_event = true

use_single_devid = false

--------------------------------------
-- WIFI configuration
wifi.setmode(wifi.STATION)
--wifi.sta.config("SSID", "PASSWD")	-- only needs to be done once - ESP saves wifi credentials in the flash memory
wifi.sta.connect()

--------------------------------------
-- Pushingbox device id
devid = "xxxxx"

--------------------------------------
-- Voltage divider values and vref
vref = 0.985    --1024 == 985mV
r1 = 33000
r2 = 10000

bat_info = "OK"
-- Warning voltage 1 & 2 (2 must be lower then 1)
warn_volt1 = 3.7    -- e.g battery half empty
warn_devid1 = "xxxxx"
warn_info1 = "50%"

warn_volt2 = 3.3    -- e.g battery almost dead
warn_devid2 = "xxxxx"
warn_info2 = "20%"

--------------------------------------
-- Temperature sensor pin (nodemcu I/O Index)
tempsensor_pin = 4
-- Decimal places for sensor value
precision = 1

--------------------------------------
-- Server to get the time from (not NTP)
time_server_ip = "192.168.1.123"
-- Time offset
time_offset = 1

--------------------------------------
-- IP cam config
cam_ip = "192.168.1.18"
cam_port = 8001
event_url = "/axis-cgi/io/virtualinput.cgi?action=6:/5000"
base64_pass = "am9oOmpvaA=="

--------------------------------------
-- Timout - force DeepSleep after n seconds
timout = 10

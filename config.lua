
--------------------------------------
-- Wifi configuration
--------------------------------------
--wifi.setmode(wifi.STATION)
--wifi.sta.config(SSID, "PASSWD")
--wifi.sta.connect()

--------------------------------------
-- Pushingbox device id
--------------------------------------
devid = "xxxxx"

--------------------------------------
USE_TEMP_SENSOR = true
--------------------------------------
  -- ds18b20 data pin (nodemcu I/O Index)
  tempsensor_pin = 3
  -- Decimal places for sensor value
  tempsensor_precision = 1

--------------------------------------
USE_BATTERY_CHECK = true
--------------------------------------
  -- ADC reference voltage (adjust for your esp module)
  vref = 0.985
  -- Values for the resistor voltage divider
  r1 = 33000
  r2 = 10000
--------------------------------------
  -- Standard bat info ($bat_info$)
  bat_info     = "OK"
--------------------------------------
  -- First Warning Voltage
  warn_volt_1    = 0.4
  -- Content of $bat_info$ if $vbat$ <= warn_volt1
  warn_info_1    = "50%"
--------------------------------------
  -- Second Warning Voltage
  warn_volt_2    = 0.3
  -- Content of $bat_info$ if $vbat$ <= warn_volt2
  warn_info_2    = "20%"
  
--------------------------------------
USE_MULTIPLE_DEVIDS = false  -- depends on USE_BATTERY_CHECK
--------------------------------------
  -- First Warning Scenario (will be used if $vbat$ <= warn_volt1)
  warn_devid_1   = "xxxxx"
  -- Second Warning Scenario (will be used if $vbat$ <= warn_volt2)
  warn_devid_2   = "xxxxx"

--------------------------------------
USE_DATE_TIME = true
--------------------------------------
  -- Webserver to get the time from
  time_server_ip = "192.168.1.123"
  -- Time offset
  time_offset = 2
  -- Translate date to german (Dec=Dez, Tue=Di,..)
  date_translate = true

--------------------------------------
USE_IPCAM_EVENT = false
--------------------------------------
  -- IP cam config
  cam_ip = "192.168.1.125"
  cam_port = 80
  cam_event_url = "/axis-cgi/io/virtualinput.cgi?action=6:/5000"
  cam_base64_pass = "am9oOmpvaA=="

--------------------------------------
USE_WIFI_STRENGTH = true
--------------------------------------
  -- SSID of the router
  SSID = ""

--------------------------------------
USE_CYCLIC_DEEPSLEEP = true -- only works if PIN32(RST) and PIN8(XPD_DCDC aka GPIO16 are connected together
--------------------------------------
  -- Wake up every 'sleep_time' minutes (max. 30!) 
  sleep_time = 5

--------------------------------------
-- FAILSAVE options (worst case running time with std config(3,10): ~50 seconds)
--------------------------------------
  max_retries = 3   -- amount of retries (before doing a reset)
  time_between_requests = 10  -- how long to wait between the requests
  
  -- Reset config
  DO_A_RESET = true  -- do a (single) reset
  DO_A_SOFT_RESET = true -- do not deepsleep, do a soft-reset instead
  DO_A_RESET_SLEEPTIME = 15   -- seconds to deepsleep before doing a reset (only works if PIN32(RST) and PIN8(XPD_DCDC aka GPIO16 are connected together)
  RESET_SIGNAL_PIN = 1  -- pin for the reset signal (will be HIGH for 1.5 seconds)

--------------------------------------
  -- Lgfiles get cleared if this pin is LOW
  clear_logs_pin = 5


--------------------------------------
-- Wifi configuration
--------------------------------------
wifi.setmode(wifi.STATION)
--wifi.sta.config("SSDI", "PASSWD")
--wifi.sta.connect()

--------------------------------------
-- Pushingbox device id
--------------------------------------
devid = "xxxxx"

--------------------------------------
USE_TEMP_SENSOR = false
--------------------------------------
  -- ds18b20 data pin (nodemcu I/O Index)
  tempsensor_pin = 3
  -- Decimal places for sensor value
  tempsensor_precision = 1

--------------------------------------
USE_BATTERY_CHECK = false
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
USE_DATE_TIME = false
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
--USE_CYCLIC_DEEPSLEEP = true
--------------------------------------
  -- Wake up every 'sleep_time' minutes
  --sleep_time = 1

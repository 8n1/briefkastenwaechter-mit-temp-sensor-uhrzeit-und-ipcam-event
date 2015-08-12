######################################################################
# NodeMCU Briefkastenwaechter Version 1.1 - mit Logging
#
# Modified MAKEFILE from: https://github.com/marcoskirsch/nodemcu-httpserver
# Uses esptool.py for flashing:
# -> https://github.com/themadinventor/esptool
# And nodemcu-uploader.py to upload the scripts:
# -> https://github.com/kmpm/nodemcu-uploader
######################################################################

######################################################################
# User configuration
######################################################################
# Serial port
PORT=/dev/ttyUSB0
# Raspi
#PORT=/dev/ttyAMA0

# Path to esptool (https://github.com/themadinventor/esptool)
ESPTOOL=./Tools/esptool/esptool.py
# flash speed
FLASH_SPEED=921600
# firmware file
NODEMCU_FIRMWARE=./Firmware/nodemcu_float_0.9.5_20150318.bin

# Path to nodemcu-uploader
NODEMCU-UPLOADER=./Tools/nodemcu-uploader/nodemcu-uploader.py

######################################################################
# End of user config
######################################################################

# nodemcu-uploader upload speed
UPLOAD_SPEED=9600

# Lua files to upload
LUA_FILES := \
	init.lua \
	config.lua \
	deepsleep.lua \
	ds18b20.lua \
	fail_save_function.lua \
	get_rssi.lua\
	get_vcc.lua \
	get_temp.lua \
	get_time.lua \
	parse_date.lua \
	trigger_ipcam_event.lua \
	launch_scenario.lua \
	log_fails.lua \
	print_logs.lua

# Print usage
usage:
	@echo "make flash                     to flash the nodemcu firmware (float_0.9.5_20150318) "
	@echo "make upload                    to upload the lua files"
	@echo "make upload_file FILE:=<file>  to upload a specific lua file"
	@echo "make update                    to update all lua files"
	@echo "make list_files                to list all file on the filesystem"
	@echo "make format_fs                 to format the filesystem"
	@echo "make stop_timer                to stop the timers"
	@echo $(TEST)

# Flash the firmware ("TO FLASH THE FIRMWARE HOLD DOWN GPIO0 AND RESET THE ESP")
flash:
	@echo " TO FLASH THE FIRMWARE CONNECT GPIO0 TO GND AND RESET THE ESP."
	@echo " IF ITS DONE, DISCONNECT GPIO0 FROM GND."
	@$(ESPTOOL) -p $(PORT) -b $(FLASH_SPEED) write_flash 0x0000 $(NODEMCU_FIRMWARE)

# Upload all files (Upload duration: ~32 seconds)
upload: $(LUA_FILES)
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) upload $(foreach f, $^, $(f)) --compile --restart

# Upload a single file
upload_file:
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) upload $1 --compile

update:$(LUA_FILES)
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) exec ./Tools/stop_timer.lua
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) file format
	@#$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) exec ./Tools/setup_uart.lua
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) upload $(foreach f, $^, $(f)) --compile --restart

# Format filesystem
format_fs:
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) file format

# List files on the filesystem
list_files:
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) file list

# Stop the timers so we can do stuff
stop_timer:
	@$(NODEMCU-UPLOADER) -b $(UPLOAD_SPEED) -p $(PORT) exec ./Tools/stop_timer.lua

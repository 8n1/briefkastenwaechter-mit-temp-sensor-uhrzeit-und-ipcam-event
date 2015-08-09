
-- require ds18b20 module
ds18b20 = require("ds18b20")
-- setup sensor
ds18b20.setup(tempsensor_pin)

-- read temperature
ds_temp = ds18b20.read()

-- handle "power-on reset value"
if ds_temp == 85 then
    tmr.delay(750000)
    ds_temp = sensor.read()
end

-- if couldn't get temperature...
if ds_temp == nil then
	-- ...print debugging information(if wanted)
    if debug == 1 then
        print(" -> 'Could not read sensor. Check wiring'")
    end
    -- ...set temperature anyway
    ds_temp = 0
end

-- temperature format: 0.00
ds_temp = string.format("%." ..precision.. "f", ds_temp)

-- clean up
debug = nil
ds18b20 = nil
package.loaded["ds18b20"] = nil

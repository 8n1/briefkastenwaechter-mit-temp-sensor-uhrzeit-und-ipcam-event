
ds18b20 = require("ds18b20")
ds18b20.setup(tempsensor_pin)

ds_temp = ds18b20.read()

-- ignore "power-on reset value"
if ds_temp == 85 then
    tmr.delay(750000)
    ds_temp = sensor.read()
end

if ds_temp == nil then
    if debug == 1 then
        print(" -> 'Could not read sensor. Check wiring'")
    end
    ds_temp = 0
end

ds_temp = string.format("%." ..precision.. "f", ds_temp)

debug = nil
ds18b20 = nil
package.loaded["ds18b20"] = nil

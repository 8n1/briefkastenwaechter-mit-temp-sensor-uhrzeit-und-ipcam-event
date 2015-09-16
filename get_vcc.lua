-- Calculate the battery voltage and and based on that decide which scenario to launch

-- raw ADC value
local adc_value = adc.read(0)
-- voltage divider ratio
local volt_div = (r1+r2)/r2
-- calculate the battery voltage
vin = vref/1024 * adc_value * volt_div

-- based on the calculated voltage decide wich scenario to launch
if USE_MULTIPLE_DEVIDS then
    mod = "(MDs)"
    if vin <= warn_volt_1 then
        if vin > warn_volt_2 then
            -- Battery is half empty
            devid = warn_devid_1
            bat_info = warn_info_1
        else 
            -- Battery is almost dead
            devid = warn_devid_2
            bat_info = warn_info_2
        end
    end
else
    mod = "(SD)"
    warn_devid_1, warn_devid_2 = devid, devid
end

-- format: 0.00
vin = string.format("%.2f", vin)
-- and append to Query String
data = data.."&vbat="..vin.."&bat_info="..bat_info

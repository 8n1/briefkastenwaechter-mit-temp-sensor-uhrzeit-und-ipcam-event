
function check_volts() 
    --------------------------------------------
    -- Calculate input voltage (VIN)
    --vref = 0.985    --1024 == 985mV
    --r1 = 33000
    --r2 = 10000

    adc_value = adc.read(0)

    adc_res = 1024
    volt_div = (r1+r2)/r2
    vin = vref/adc_res * adc_value * volt_div
    --print("VIN: " ..vin)

    --------------------------------------------
    -- Check battery level and prepare variables
        if vin <= warn_volt1 then
            if vin > warn_volt2 then
                -- Battery is half empty
                send_warning = 1
                devid = warn_devid1
                bat_info = warn_info1
            else 
                -- Battery is almost dead
                send_warning = 2
                devid = warn_devid2
                bat_info = warn_info2
            end
        else
            -- Battery is fine
            send_warning = 0
        end

    --------------------------------------------
    -- Return battery voltage
    return vin
end

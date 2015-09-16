
--------------------------------------
-- Fail-save timer for the http request
--  - tries to send a request a given amount of times and logs every failed attempt
--------------------------------------

function fail_safe(script_to_call, logfile_to_use)

    -- call the given script
    dofile(script_to_call)
    
    repeat_counter = 0
    -- setup the failsave timer
    tmr.alarm(2, time_between_requests*1000, 1, function()
        if repeat_counter < max_retries-1 then
            repeat_counter = repeat_counter + 1
            print("\n Request #"..repeat_counter .." Failed. Logging and Retrying...")
            fail_type = logfile_to_use
            dofile("log_fails.lc")
            print("")

            -- retry sending the request
            dofile(script_to_call)
            
        else
            tmr.stop(2)

            repeat_counter = repeat_counter + 1
            print("\n Request #"..repeat_counter .." Failed.")

            -- optional do a reset with a short deepsleep delay
            if DO_A_RESET then
                if not file.open("did_a_reset", "r") then
                    file.open("did_a_reset", "w+") file.close()
                    print(" Doing a reset in 1.5 seconds and logging it (also activating the reset signal)...")
                    
                    -- log the resets
                    fail_type = "reset" 
                    dofile("log_fails.lc")
                    
                    -- activate the reset signal
                    gpio.mode(RESET_SIGNAL_PIN, gpio.OUTPUT)
                    gpio.write(RESET_SIGNAL_PIN, 1)

                    -- wait a second to let the tiny reset the timer
                    tmr.delay(1500*1000)

                    -- software reset or deepsleep
                    if DO_A_SOFT_RESET then
                        print("\n Doing a reset...\n")
                        node.restart()
                    else
                        print("\n Waking up in " ..DO_A_RESET_SLEEPTIME .." seconds...\n")
                        node.dsleep(DO_A_RESET_SLEEPTIME*1000*1000, 1)
                    end
                else
                    print(" Already did a reset. Logging and DeepSleeping...")
                    file.remove("did_a_reset")
                end
            end

            tmr.alarm(2, 1500, 0, function()
                fail_type = "fails" 
                dofile("log_fails.lc")
                dofile("deepsleep.lc") 
            end)
        end
    end)
end

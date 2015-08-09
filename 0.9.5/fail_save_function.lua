-- Fail save function

--------------------------------------
-- Fail-save timer for the request
--------------------------------------
function fail_safe(script_to_call, logfile_to_use)
    
    -- call the given script
    dofile(script_to_call)
    
    -- setup a failsave timer
    tmr.alarm(2, 5000, 0, function()
        print("\n Request Failed. Logging and Retrying...")
        -- log the retry and append
        fail_type = logfile_to_use
        dofile("log_fails.lc")
        
        -- retry sending the request
        dofile(script_to_call)
        
        -- very last fail safe
        tmr.alarm(2, 4000, 0, function()
            print("\n Request Failed again. Logging and DeepSleeping.")
            fail_type = "fails" 
            dofile("log_fails.lc")
            dofile("deepsleep.lc") 
        end)
    end)
end

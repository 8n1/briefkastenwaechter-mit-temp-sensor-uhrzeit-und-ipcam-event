-- Activate cyclic or infinite DeepSleep

print("~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" Heap: " ..node.heap()/1000 .." KB free")
print(" Timer: " ..string.format("%.2f", tmr.now()/1000/1000) .." seconds elapsed\n")

if USE_VREG_SHUTDOWN then
    print(" Signaling the shutdown...")
    gpio.mode(vreg_shutdown_pin, gpio.OUTPUT)
    -- 1 sec shutdown signal
    gpio.write(vreg_shutdown_pin, 1)
    tmr.delay(1*1000*1000)
    gpio.write(vreg_shutdown_pin, 0)
end

if USE_CYCLIC_DEEPSLEEP then
    print(" Waking up in " ..sleep_time .." minute(s).")
    node.dsleep(sleep_time*60*1000*1000 - tmr.now(), 1)
else
    -- infinite deep sleep
    node.dsleep(0, 1)
end

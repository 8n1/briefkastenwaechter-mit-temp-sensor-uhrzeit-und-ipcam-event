-- Activate cyclic or infinite DeepSleep

print("~~~~~~~~~~~~~~~~~~~~~~~~~")
print(" Heap: " ..node.heap()/1000 .." KB free")
print(" Timer: " ..string.format("%.2f", tmr.now()/1000/1000) .." seconds elapsed\n")

if USE_CYCLIC_DEEPSLEEP then
    print(" Waking up in " ..sleep_time .." minute(s).")
    node.dsleep(sleep_time*60*1000*1000 - tmr.now(), 1)
else
    -- infinite deep sleep
    node.dsleep(0, 1)
end

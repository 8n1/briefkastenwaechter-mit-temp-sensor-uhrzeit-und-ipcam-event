--------------------------------------
-- Delete all logfiles
--------------------------------------
local types = { 
    "req_fails", 
    "fails", 
    "api_fails", 
    "get_time_api_fails", 
    "wifi_fails" 
}
for count = 1, 5 do
	file.remove(types[count] .."_counter.txt")
end
print("Done.")

--------------------------------------
-- Delete all logfiles
--------------------------------------
local types = { 
    "req_fails", 
    "fails", 
    "api_fails", 
    "get_time_api_fails", 
    "wifi_fails",
    "reset"
}
for count = 1, 6 do
	file.remove(types[count] .."_counter.txt")
end
print("Done.")

-- Extracts the date and time from the responses "Date" header field...

-- extract date
local date = string.sub(res, 0, string.find(res, ":") - 3)

-- extract time
local time = string.sub(res, string.find(res, ":") - 2, string.find(res, ":") + 5)
-- then the hours, minutes and seconds
local hours = string.sub(time, 0, 2)
local minutes = string.sub(time, 4, 5)
local seconds = string.sub(time, 7, 8)

-- do a small time correction hack (TODO: Winter/Sommerzeit)
hours = (hours+time_offset) % 24
-- re-add the "trunculated" leading zero
hours = string.format("%02d", hours)

-- time format: 00:00
time = hours..":"..minutes
-- time_n format: 00:00:00
local time_n = time..":"..seconds

print(" -> Date: " ..date)
print(" -> Time: " ..time_n.. "\n")

-- sanitize/replace unvalid chars
date = date:gsub("%,", "")
date = date:gsub("% ", "+")
-- Append the data to Query String
data = data.."&date="..date.."&time="..time.."&time_n="..time_n

-- clean up
res, date, time, time_n, hours, minutes, seconds = nil
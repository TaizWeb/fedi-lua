json = dofile("lib/json.lua")
dofile("lib/curl.lua")
dofile("lib/escape-fix.lua")

table = json.decode(escapeFix(newData))
for key, value in pairs(table) do print(key, value) end


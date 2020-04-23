json = dofile("lib/json.lua")
dofile("lib/curl.lua")
dofile("lib/escape-fix.lua")

--table = json.decode(escapeFix(newData))
--for key, value in pairs(table) do print(key, value) end

function split(string, char)
	local stringTable = {}
	local lastIndex = 1
	for i=1,string.len(string) do
		if (string.sub(string, i, i) == char) then
			stringTable[#stringTable+1] = string.sub(string, lastIndex, i-1)
			lastIndex = i+1
		end
	end
	stringTable[#stringTable+1] = string.sub(string, lastIndex, #string)
	return stringTable
end

Fedi = {}
for line in io.lines("config.txt") do
	lineData = split(line, " ")
	Fedi[lineData[1]] = lineData[2]
end
print(Fedi.token)

function Fedi.postStatus(status, media, poll, pollExpiration)
	curl("POST", {"Authorization: Bearer " .. Fedi.token}, {"status=" .. status}, Fedi.domain .. "/api/v1/statuses")
end

Fedi.postStatus("Testing from API...")


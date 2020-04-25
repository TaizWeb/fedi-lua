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

function Fedi.postStatus(status, media, poll, pollExpiration)
	headers = {"Authorization: Bearer " .. Fedi.token}
	formData = {"status=" .. status}
	-- Handle media uploading
	if (media ~= nil) then
		for i=1,#media do
			local curlData = json.decode(escapeFix(curl("POST", headers, {"file=@" .. media[i]}, Fedi.domain .. "/api/v1/media")))
			local mediaData = "media_ids[]=" .. curlData["id"]
			formData[#formData+1] = mediaData
		end
	end
	print(curl("POST", headers, formData, Fedi.domain .. "/api/v1/statuses"))
end

Fedi.postStatus("Multiple media test", {"cirno.jpg", "boomer.png"})


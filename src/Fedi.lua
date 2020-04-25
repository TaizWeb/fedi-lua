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
-- Loading the configuration data
for line in io.lines("config.txt") do
	lineData = split(line, " ")
	Fedi[lineData[1]] = lineData[2]
end

-- Warning: For mastodon servers, you cannot use both media and poll in the same status
function Fedi.postStatus(status, media, pollOptions, pollExpiration)
	headers = {"Authorization: Bearer " .. Fedi.token}
	formData = {"status=" .. status}
	-- Handle media uploading
	if (media ~= nil) then
		for i=1,#media do
			-- Upload media to server
			local curlData = json.decode(escapeFix(curl("POST", headers, {"file=@" .. media[i]}, Fedi.domain .. "/api/v1/media")))
			-- Get the id and add it to the formdata
			formData[#formData+1] = "media_ids[]=" .. curlData["id"]
		end
	end

	-- Handle poll data
	if (pollOptions ~= nil and pollExpiration ~= nil) then
		for i=1,#pollOptions do
			formData[#formData+1] = "poll[options][]=" .. pollOptions[i]
		end
		formData[#formData+1] = "poll[expires_in]=" .. tostring(pollExpiration)
	end

	for i=1,#formData do
		print(formData[i])
	end
	-- Send the request to the server and return the response data
	return curl("POST", headers, formData, Fedi.domain .. "/api/v1/statuses")
end



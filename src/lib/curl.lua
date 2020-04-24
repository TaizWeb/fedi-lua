-- curl: Takes request type, header and formdata table, and target
function curl(request, headers, formdata, target)
	curlString = "curl -X " .. request .. " \\\n"
	-- Appending headers
	for i=1,#headers do
		curlString = curlString .. "-H '" .. headers[i] .. "' \\\n"
	end
	-- Appending formdata
	for i=1,#formdata do
		curlString = curlString .. "-F '" .. formdata[i] .. "' \\\n"
	end
	-- Appending target
	curlString = curlString .. target
	-- Sending request
	--print(curlString)
	local data = io.popen(curlString)
	local retData = data:read("*a")
	data:close()
	return retData
end


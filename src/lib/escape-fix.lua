function escapeFix()
	newData = ""
	for i=1,string.len(data) do
		char = string.sub(data, i, i)
		nextChar = string.sub(data, i+1, i+1)
		prevChar = string.sub(data, i-1, i-1)
		if (char == '"' and (prevChar ~= "{" and nextChar ~= ":" and prevChar ~= ":" and nextChar ~= "," and prevChar ~= "," and nextChar ~= "}")) then
			newData = newData .. "\\"
		end
		newData = newData .. string.sub(data, i, i)
	end
	newData = string.gsub(newData, "\n", "\\n")
	return newData
end


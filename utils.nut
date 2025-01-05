function min(a,b) 
{
	return a < b ? a : b;
}

function max(a,b) 
{
	return a > b ? a : b;
}

function str_replace(search, replace, subject)
{
	if (subject == null) return null;

	local text = subject;

	local position = text.find(search);

	while (position != null) {
		local slice1 = text.slice(0, position);
		local slice2 = text.slice(position + search.len());

		text = slice1 + replace + slice2;

		position = text.find(search);
	}

	return text;
}

function ini_section(filename, section)
{
	local file = ReadTextFile("/", filename);
	local map = {};
	
	local section_found = false;
	while(!file.eos()) {
		local line = file.read_line();

		if (line == "["+section+"]") {
			section_found = true;
			continue;
		}

		if (! section_found) {
			continue;
		}

		if (line.len()>0 && line.slice(0, 1) == "[") {
			break;
		}

		local parts = split(line, "=");
		if (parts.len() == 2) {
			local key = strip(parts[0]);
			local value = strip(parts[1]);
			value = str_replace("\"", "", value);

			map[key] <- value;
		}
	}

	// file.close();
	return map;
}
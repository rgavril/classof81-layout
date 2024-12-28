function retroarch_config_write(filename, variable, value) {
	local orig_file = null;
	local temp_file = null;

	local orig_file = ReadTextFile("/", filename);
	local temp_file = WriteTextFile(filename+".tmp");

	local was_replaced = false;
	while (!orig_file.eos()) {
		local line = orig_file.read_line();

		local parts = split(line, "=");
		if (parts.len() == 2) {
			local key = strip(parts[0]);
			if (key == variable) {
				temp_file.write_line(variable + " = \"" + value + "\"\n");
				was_replaced = true;
				continue;
			}
		}

		temp_file.write_line(line + "\n");
	}

	if (! was_replaced) {
		temp_file.write_line(variable + " = \"" + value + "\"\n");
	}

	rename(filename+".tmp", filename);
}

function retroarch_config_read(filename, variable) {
	local file = ReadTextFile("/", filename);

	local value = null;

	while(!file.eos()) {
		local line = file.read_line();

		local parts = split(line, "=");
		if (parts.len() == 2) {
			local key = strip(parts[0]);

			if (key == variable) {
				value = strip(parts[1]);
				value = str_replace("\"", "", value);
				break;
			}
		}
	}

	return value;
}
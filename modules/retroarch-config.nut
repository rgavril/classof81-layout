function retroarch_config_write(filename, variable, value) {
	try {
		rename(filename, filename+".old");
	} catch (e) {
		print("ERROR: Cannot rename to retroach config file : " + filename + "\n");
		return;
	}

	local old_file = ReadTextFile(filename+".old");
	local new_file = WriteTextFile(filename);

	local was_replaced = false;
	while (!old_file.eos()) {
		local line = old_file.read_line();

		local parts = split(line, "=");
		if (parts.len() == 2) {
			local key = strip(parts[0]);
			if (key == variable) {
				new_file.write_line(variable + " = \"" + value + "\"\n");
				was_replaced = true;
				continue;
			}
		}

		new_file.write_line(line + "\n");
	}

	if (! was_replaced) {
		try {
			new_file.write_line(variable + " = \"" + value + "\"\n");
		} catch (e) {
			print("ERROR: Cannot write to retroach config file : " + filename + "\n");
			return;
		}
	}

	try {
		remove(filename+".old")
	} catch (e) {
		print("WARNING: Cannot delete temp retroach config file : " + filename + ".old\n");
	}
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
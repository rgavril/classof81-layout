function retroarch_config_write(filename, variable, value) {
	local filenameOrig = fe.path_expand(filename);
	local filenameTemp = filenameOrig + ".temp";

	# Remove temporary file if it exists
	if (fe.path_test(filenameTemp, PathTest.IsFile)) {
		try {
			remove(filenameTemp);
		} catch (e) {
			print(format("WARNING : Cannot remove temporary file %s (%s)", filenameTemp, e));
			return;
		}
	}

	local fileOrig = ReadTextFile(filenameOrig);
	local fileTemp = WriteTextFile(filenameTemp);

	while (!fileOrig.eos()) {
		# Read a line from the file
		local line = fileOrig.read_line();

		# If the line contains our varilable, skip writing it
		local parts = split(line, "=");
		if (parts.len() == 2 && strip(parts[0]) == variable) {
			continue;
		}
		
		# Else copy the line
		fileTemp.write_line(line + "\n");
	}


	# Write our variable = value into the temp file
	fileTemp.write_line(variable + " = \"" + value + "\"\n");

	# Close our files else windows will complain
	try {
		fileTemp._f.close();
	} catch (e) {
		print(format("WARNING : Cannot close temp file %s (%s)", filenameTemp, e)); 
	}
	try {
		fileOrig._f.close();
	} catch (e) {
		print(format("WARNING : Cannot close orig file %s (%s)", filenameOrig, e)); 
	}

	# Remove original file
	try {
		remove(filenameOrig)
	} catch (e) {
		print(format("WARNING : Cannot remove orig file %s (%s)", filenameOrig, e)); 
	}

	# Make the tempoarary file our new original
	try {
		rename(filenameTemp, filenameOrig);
	} catch (e) {
		print(format("WARNING : Cannot rename temporary file %s (%s)", filenameOrig, e)); 
	}
}

function retroarch_config_read(filename, variable) {
	local file = ReadTextFile(fe.path_expand(filename));

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

	# Close the file so windows doesn't complain
	try {
		file._f.close();
	} catch (e) {
		print(format("WARNING : Cannot close retroarch file %s (%s)", filename, e)); 
	}

	return value;
}
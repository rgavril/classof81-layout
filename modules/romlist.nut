class RomList
{
	entries = {};
	name = "";

	function constructor()
	{
		this.name = fe.displays[fe.list.display_index].romlist
		this.parse_romlist();
	}

	function parse_romlist() {
		local filename = format( "%s/romlists/%s.txt", FeConfigDirectory, this.name );
		
		local file = ReadTextFile(filename);
		while(!file.eos()) {
			local line = file.read_line();

			local entry = this.split_preserve_empty(line, ";");
			local rom = entry[Info.Name];

			entries[rom] <- entry;
		}

		return entries;
	}

	function game_clones(rom) {
		local clones = [];

		foreach (entry in this.entries) {
			if (entry[Info.CloneOf] == rom) {
				clones.push(entry[Info.Name]);
			}
		}

		return clones;
	}

	function game_info(rom, info) {
		return this.entries[rom][info];
	}

	# Split a string by a delimiter, preserving empty values
	function split_preserve_empty(str, delimiter) {
		local result = [];
		local current = "";

		for (local i = 0; i < str.len(); i++) {
		    local char = format("%c", str[i]);

		    if (char == delimiter) {
		        result.append(current);
		        current = "";
		    } else {
		        current += char;
		    }
		}
		result.append(current);

		return result;
	}
}

romlist <- RomList();
class RomVersions
{
	CONFIG_FILE = fe.script_dir+"/config/versions.conf"

	rom = null             # String storing the parent rom name
	available_games = [];  # Array with all information from the romlists/ file
	current_idx = 0;       # Index for available_games that points to the active version

	constructor(rom)
	{
		this.rom = rom;

		this.available_games = this._parse_available_games();
		this.current_idx = this.get_default_idx();

		local current_rom = this._read_from_disk();
		if (current_rom != "") {
			foreach (idx, game in available_games) {
				if (game[Info.Name] == current_rom) {
					this.current_idx = idx;
				}
			}
		}
	}

	function get_available_titles() {
		local titles = [];

		foreach(idx, game in this.available_games) {
			titles.push(game[Info.Title]);
		}

		return titles;
	}

	function get_available_roms() {
		local roms = [];

		foreach(idx, game in this.available_games) {
			roms.push(game[Info.Name]);
		}

		return roms;
	}

	function get_current_title() {
		return this.available_games[this.current_idx][Info.Title];
	}

	function get_current_rom() {
		return this.available_games[this.current_idx][Info.Name];
	}

	function get_current_idx() {
		return this.current_idx;
	}

	function set_current_idx(idx) {
		this.current_idx = idx;

		this._save_to_disk();
	}

	function get_default_idx() {
		foreach(idx, game in this.available_games) {
			if (game[Info.CloneOf] == "") {
				return idx;
			}
		}

		return 0;
	}

	function select_next_version() {
		local next_idx = (this.current_idx + 1) % this.available_games.len();

		this.set_current_idx(next_idx);
	}

	function select_prev_version() {
		local prev_idx = (this.current_idx + this.available_games.len() - 1) % this.available_games.len();

		this.set_current_idx(prev_idx);
	}

	function reset() {
		this.set_current_idx(this.get_default_idx());
	}

	# Return a string array with rom names of all clones and parent rom
	function _parse_available_games()
	{
		local file = ReadTextFile(this._romlist_file());

		local available_games = []

		while(!file.eos()) {
			local line = file.read_line();
			local game = this._split_preserve_empty(line, ";");

			if (game[Info.CloneOf] != this.rom && game[Info.Name] != this.rom) { continue; }

			available_games.push(game);
		}

		return available_games;
	}

	# Return the romlist filename from romlists/ folder
	function _romlist_file()
	{
		local romlist = fe.displays[fe.list.display_index].romlist;

		// Start from the script directory
		local path = fe.script_dir;

		// Go two folders back
		local count = 3;
		while (count > 0) {
			local lastSlashIndex = -1;

			// Find the location of the last '/'
			for (local i = path.len() - 1; i >= 0; i--) {
			    if (path[i] == '/') {
			        lastSlashIndex = i;
			        break;
			    }
			}

			if (lastSlashIndex == -1) {
				break;
			}

			path = path.slice(0, lastSlashIndex);
			count--;
		}

		// Create the actual path
		path = path + "/romlists/"+romlist+".txt";

		return path;
	}

	# Split a string by a delimiter, preserving empty values
	function _split_preserve_empty(str, delimiter) {
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

	function _save_to_disk() {
		retroarch_config_write(this.CONFIG_FILE, this.rom, this.get_current_rom());
	}

	function _read_from_disk() {
		return retroarch_config_read(this.CONFIG_FILE, this.rom)
	}
}
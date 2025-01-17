class RomVersions
{
	rom = null;
	current = null;
	available_games = [];
	current_idx = 0;

	constructor(rom)
	{
		this.rom = rom;
		this.current = this.rom;
		this.available_games = this._parse_available_games();

		this.current_idx = this.get_default_idx();
		if ("game_versions_map" in fe.nv && this.rom in fe.nv["game_versions_map"]) {
			local stored_rom = fe.nv["game_versions_map"][this.rom];

			foreach (idx, game in available_games) {
				if (game[Info.Name] == stored_rom) {
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

		if (! ("game_versions_map" in fe.nv)) {
			fe.nv["game_versions_map"] <- {};
		}

		fe.nv["game_versions_map"][this.rom] <- this.get_current_rom();
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
}
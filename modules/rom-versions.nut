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
		this.available_games = this.read_available_games();
		this.current_idx = 0;
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
		return this.available_games[this.current_idx][Info.Title];
	}

	function get_current_idx() {
		return this.current_idx;
	}

	function set_current_idx(idx) {
		this.current_idx = idx;
	}

	function read_available_games()
	{
		local file = ReadTextFile("/", "/Users/rgavril/.attract/romlists/Mame.txt");

		local available_games = []

		while(!file.eos()) {
			local line = file.read_line();
			local game = splitPreserveEmpty(line, ";");

			if (game[Info.CloneOf] != this.rom && game[Info.Name] != this.rom) { continue; }

			available_games.push(game);
		}

		return available_games;
	}
}

function splitPreserveEmpty(str, delimiter) {
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
    result.append(current); // Add the last segment
    return result;
}
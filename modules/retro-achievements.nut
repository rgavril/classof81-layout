class RetroAchievements
{
	Error = {
		GameIDNotFound = "Game not found in RetroAchievements.org database.",
		GameListDownload = "Failed to download game list.\nCheck your internet connection and login credentials.",
		GameListParse = "Error parsing the game list. Please try again.",
		GameInfoDownload = "Failed to download game info.\nCheck your internet connection and login credentials.",
		GameInfoParse = "Error parsing the game list. Please try again.",
		GameInfoEmpty = "Game info is empty.\nCheck your internet connection and login credentials.",
		LeaderboardsDownload = "Failde to download leaderbords.\nCheck your internet connection and login credentials.",
		LeaderboardsParse = "Error parsing the game leaderboards. Please try again."
	}

	STORAGE_DIR   = fe.script_dir+"/achievements/";
	GAMELIST_JSON = fe.script_dir+"/achievements/_gamelist.json"

	constructor() {

	}

	function download_gamelist() {
		# Build the gamelist download url
		local url = this.build_url(
			"API_GetGameList.php",
			{
				"i": 27,
				"h": 1
			}
		);

		# Try to download the gamelist 
		if (! fe.get_url(url, GAMELIST_JSON) ) {

			# If it fails, thow a error
			throw Error.GameListDownload;
		}
	}

	function parse_gamelist() {
		# Download the gamelist if not yet downloaded
		if (! fe.path_test(GAMELIST_JSON, PathTest.IsFile)) {
			this.download_gamelist();
		}

		# Try to parse the gamelist
		try {
			return load_json(GAMELIST_JSON);

		# If it fails json parsing
		} catch (e) {
			# Delete the file so it can be downloaded again
			remove(GAMELIST_JSON);

			# Throw a error
			throw Error.GameListParse;
		}
	}

	function download_gameinfo(rom) {
		# Find the gameid associated with the rom
		local game_id = this.game_id(rom);

		# Build teh gameinfo url
		local url = this.build_url(
			"API_GetGameInfoAndUserProgress.php",
			{
				"g": game_id,
				"u": AM_CONFIG["ra_username"],
				"z": AM_CONFIG["ra_username"]
			}
		)

		# Try to download the gameinfo
		if (! fe.get_url(url, STORAGE_DIR+"/"+rom+".json")) {

			# If it fails thow a error
			throw Error.GameInfoDownload;
		}
	}

	function parse_gameinfo(rom) {
		local gameinfo = null;

		if (! fe.path_test(STORAGE_DIR+"/"+rom+".json", PathTest.IsFile)) {
			this.download_gameinfo(rom);
		}

		try {
			gameinfo = load_json(STORAGE_DIR+"/"+rom+".json");
		} catch(e) {
			throw Error.GameInfoParse;
		}

		if (gameinfo.len() == 0) {
			throw Error.GameInfoEmpty;
		}

		return gameinfo;
	}

	function download_leaderboards(rom) {
		# Find the gameid associated with the rom
		local game_id = this.game_id(rom);

		# Build teh gameinfo url
		local url = this.build_url(
			"API_GetGameLeaderboards.php",
			{
				"i": game_id
			}
		)

		# Try to download the leaderboards
		if (! fe.get_url(url, STORAGE_DIR+"/leaderboards/"+rom+".json")) {
			
			# If it fails thow a error
			throw Error.LeaderboardsDownload;
		}
	}

	function parse_leaderboards(rom) {
		local leaderboards = null;

		if (! fe.path_test(STORAGE_DIR+"/leaderboards/"+rom+".json", PathTest.IsFile)) {
			this.download_leaderboards(rom);
		}

		try {
			leaderboards = load_json(STORAGE_DIR+"/leaderboards/"+rom+".json");
		} catch(e) {
			throw Error.LeaderboardsParse;
		}

		// if (leaderboards.len() == 0) {
		// 	throw Error.GameInfoEmpty;
		// }

		return leaderboards;
	}

	function game_id(rom) {
		# Parse the gamelist
		local gamelist = this.parse_gamelist();

		# Create a hash for the current rom
		local romHash = md5(rom);

		# Find a game that has this hash and return it's gameID
		foreach(game in gamelist) {
			foreach(hash in game.Hashes) {
				if (hash == romHash) {
					return (game.ID);
				}
			}
		}

		# If we got this far, and not game was found, thow a error
		throw Error.GameIDNotFound;
	}

	function badge_image(badge_id) {
		local img_filename = STORAGE_DIR+"/"+badge_id+".png"

		if (! fe.path_test(img_filename, PathTest.IsFile)) {
			fe.get_url("https://media.retroachievements.org/Badge/"+badge_id+".png", img_filename);
		}

		return img_filename;
	}

	function build_url(method, params) {
		local url = "https://retroachievements.org/API/"+method+"?y="+AM_CONFIG["ra_apikey"];
	
		foreach(key, value in params) {
			url += "&"+key+"="+value;
		}

		return url;
	}
}

# Retro Achievements API
ra <- RetroAchievements();
class RetroAchievements
{
	Error = {
		NoAcheievemnts = "Game Has No Retro Achivements",
		GameListDownload = "Cannot Download Retro Achievements Game List",
		GameListParse = "Cannot Parse Retro Achievements Game List",
		GameInfoDownload = "Cannot Download Retro Achievements Game Info",
		GameInfoParse = "Cannot Parse Retro Achievements Game Info",
		GameInfoFormat = "Wrong Game Info Format",
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
		if (! fe.path_test(STORAGE_DIR+"/"+rom+".json", PathTest.IsFile)) {
			this.download_gameinfo(rom);
		}

		try {
			return load_json(STORAGE_DIR+"/"+rom+".json");
		} catch(e) {
			throw Error.GameInfoParse;
		}
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
		throw Error.NoAcheievemnts;
	}

	function game_achievements(rom) {
		# Parse the game info
		local gameinfo = this.parse_gameinfo(rom);

		# If this game has achievements
		if ("Achievements" in gameinfo) {

			# Return the achivements part of the gameinfo as an array
			local achievements = [];
			foreach (key, value in gameinfo.Achievements) {
			    achievements.append(value);
			}
			return achievements;
		}

		# If Achivements was not found, we have a problem
		throw Error.GameInfoFormat;
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
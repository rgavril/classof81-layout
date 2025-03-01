class RetroAchievements
{
	Error = {
		GameIDNotFound = "Game not found on RetroAchievements.org",
		Download = "Failed retrive data from RetroAchievements.org.\nCheck your internet connection and login credentials.",
		ParseJSON = "Error parsing response from RetroAchievements.org. Please try again."
	}

	STORAGE_DIR   = fe.script_dir+"/achievements/";
	GAMELIST_JSON = fe.script_dir+"/achievements/_gamelist.json"

	constructor() {

	}

	function GetGameList(use_cache=true) {
		local cache_age = 30 * 24 * 60; // 30 Days

		return this.call_method(
			"API_GetGameList.php",
			{
				"i": 27,
				"h": 1
			},
			use_cache ? cache_age : 0
		)
	}

	/*
		User Game Progress
		A call to this endpoint will retrieve extended metadata about a game, in addition to a user's 
		progress about that game. This is targeted via a game's unique ID and a given username.

		https://api-docs.retroachievements.org/v1/get-game-info-and-user-progress.html
	*/
	function GetGameInfoAndUserProgress(game_id, use_cache=true) {
		local cache_age = 1; // 1 Minute

		return this.call_method(
			"API_GetGameInfoAndUserProgress.php",
			{
				"g": game_id,
				"u": AM_CONFIG["ra_username"],
				"z": AM_CONFIG["ra_username"]
			},
			use_cache ? cache_age : 0
		)
	}

	/*
		Game Leaderboards
		A call to this endpoint will retrieve a given game's list of leaderboards, targeted by the game's ID.

		https://api-docs.retroachievements.org/v1/get-game-leaderboards.html
	*/
	function GetGameLeaderboards(game_id, use_cache=true) {
		local cache_age = 30 * 24 * 60; // 30 Days

		return this.call_method(
			"API_GetGameLeaderboards.php",
			{
				"i": game_id
			},
			use_cache ? cache_age : 0
		);
	}

	function GetLeaderboardEntries(leaderboard_id, offset=0, count=100, use_cache=true) {
		local cache_age = 1 * 60; // 1 Hour

		return this.call_method(
			"API_GetLeaderboardEntries.php",
			{
				"i": leaderboard_id,
				"c": count,
				"o": offset
			},
			use_cache ? cache_age : 0
		);
	}

	function GetUserGameLeaderboards(game_id, offset=0, count=200, use_cache=true) {
		local cache_age = 1 * 60; // 1 Hour

		return this.call_method(
			"API_GetUserGameLeaderboards.php",
			{
				"i": game_id,
				"u": AM_CONFIG["ra_username"],
				"c": count,
				"o": offset
			}
			use_cache ? cache_age : 0
		);
	}

	function game_id(rom) {
		# Parse the gamelist
		local gamelist = this.GetGameList();

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

	function call_method(method, params, cache_age=0) {
		# Build Cache Filename
		local cache_file = STORAGE_DIR+"/"+method;
		foreach(key,value in params) {
			cache_file += "." + key + "__" + value;
		}

		# Build URL
		local url = "https://retroachievements.org/API/"+method+"?y="+AM_CONFIG["ra_apikey"];
		foreach(key, value in params) {
			url += "&"+key+"="+value;
		}

		# If Cache is to old
		if (! this.valid_cache(cache_file, cache_age)) {
			# Download URL
			if (! fe.get_url(url, cache_file)) {
				# If it fails thow a error
				throw (Error.Download)
			}
		} else {
			// print("HIT RA CACHE : "+ url + "\n");
		}

		# Parse the response
		local response = null;

		try {
			response = load_json(cache_file);
		} catch(e) {
			throw (Error.ParseJSON);
		}

		# Return the response
		return response;
	}

	function build_url(method, params) {
		local url = "https://retroachievements.org/API/"+method+"?y="+AM_CONFIG["ra_apikey"];
	
		foreach(key, value in params) {
			url += "&"+key+"="+value;
		}

		return url;
	}

	function valid_cache(filename, age) {
		if (age <= 0) {
			return false;
		}

		if (! fe.path_test(filename, PathTest.IsFile)) {
			return false;
		}

		// TODO: Compare file mtime to current time to see how old it is
		return false;
	}
}

# Retro Achievements API
ra <- RetroAchievements();
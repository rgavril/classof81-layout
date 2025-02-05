class RetroAchievements
{
	STORAGE_DIR   = fe.script_dir+"/achievements/";
	GAMELIST_JSON = fe.script_dir+"/achievements/GameList.json"

	constructor() {
	}

	function download_gamelist() {
		local url = this.build_url(
			"API_GetGameList.php",
			{
				"i": 27,
				"h": 1
			}
		);

		fe.get_url(url, GAMELIST_JSON);
	}

	function parse_gamelist() {
		if (! fe.path_test(GAMELIST_JSON, PathTest.IsFile)) {
			this.download_gamelist();
		}

		return load_json(GAMELIST_JSON);
	}

	function download_gameinfo(rom) {
		local game_id = this.game_id(rom);
		if (game_id == null) {
			return;
		}

		local url = this.build_url(
			"API_GetGameInfoAndUserProgress.php",
			{
				"g": game_id,
				"u": AM_CONFIG["ra_username"],
				"z": AM_CONFIG["ra_username"]
			}
		)

		fe.get_url(url, STORAGE_DIR+"/"+rom+".json");
	}

	function parse_gameinfo(rom) {
		if (! fe.path_test(STORAGE_DIR+"/"+rom+".json", PathTest.IsFile)) {
			this.download_gameinfo(rom);
		}

		local data = null;
		try {
			data = load_json(STORAGE_DIR+"/"+rom+".json");
		} catch(e) {}

		return data;
	}

	function game_id(rom) {
		local gamelist = this.parse_gamelist();

		local romHash = md5(rom);

		foreach(game in gamelist) {
			foreach(hash in game.Hashes) {
				if (hash == romHash) {
					return (game.ID);
				}
			}
		}

		return null;
	}

	function game_achievements(rom) {
		local gameinfo = this.parse_gameinfo(rom);

		if (gameinfo != null) {
			return gameinfo.Achievements;
		} else {
			return null;
		}
	}

	function build_url(method, params) {
		local url = "https://retroachievements.org/API/"+method+"?y="+AM_CONFIG["ra_apikey"];
	
		foreach(key, value in params) {
			url += "&"+key+"="+value;
		}

		return url;
	}
}
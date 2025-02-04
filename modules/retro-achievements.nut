class RetroAchievements {
	
	function constructor()
	{
		this.update_gamelist();
	}

	function update_gamelist()
	{
		local url = "https://retroachievements.org/API/API_GetGameList.php?y="+AM_CONFIG["ra_apikey"]+"&i=27&h=1"
		local file = fe.script_dir+"/achievements/game_list.json";

		fe.get_url(url, file)
	}

	function update_achievements(rom)
	{
		local url = "https://retroachievements.org/API/API_GetGameInfoAndUserProgress.php?g="+md5(rom)+"&u="+AM_CONFIG["ra_username"]+"&y="+AM_CONFIG["ra_apikey"]+"&z="+AM_CONFIG["ra_username"]+""
		local file = fe.script_dir+"/achievements/nuts/"+rom+".json";

		print("URL  " + url + "\n\n");
		print("FILE " + file + "\n\n");

		fe.get_url(url, file)
	}
}
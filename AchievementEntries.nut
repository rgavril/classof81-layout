class AchievementEntries {
	constructor() {
		local ra = dofile(fe.script_dir + "/ra2nut/achievements.nut");

		# Sort achivements by keys
		local keys = [];
		foreach (key, value in ra.Achievements) {
		    keys.push(key);
		}
		keys.sort();

		foreach (i,key in keys) {
			AchievementEntry(490, 380+85*(i++), ra.Achievements[key]);
			if (i == 8) break
		}
	}
}
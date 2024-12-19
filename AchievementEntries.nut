class AchievementEntries {
	PAGE_SIZE = 9;

	m_x = 0;
	m_y = 0;
	m_info = null;
	m_rom = null;
	m_achivement_entries = null;

	constructor(x, y) {
		m_x = x;
		m_y = y;

		m_achivement_entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local achivement_entry = AchievementEntry(m_x, m_y+83*i);
			m_achivement_entries.push(achivement_entry)
		}
	}

	function refresh() {
		local rom = fe.game_info(Info.Name);
		
		try {
			m_info = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");
			show();
		} catch(e) {
			hide();
		}
	}

	function show() {
		# Sort achivements by keys
		local keys = [];
		foreach (key, value in m_info.Achievements) {
		    keys.push(key);
		}
		keys.sort();

		foreach(index,achivement_entry in m_achivement_entries) {
			local info = m_info.Achievements[keys[index]];
			achivement_entry.show(info);
		}
	}

	function hide() {
		foreach(achivement_entry in m_achivement_entries) {
			achivement_entry.hide();
		}
	}
}
class AchievementEntries {
	PAGE_SIZE = 9;

	m_x = 0;
	m_y = 0;
	m_info = null;
	m_rom = null;
	m_achivement_entries = null;
	m_selected_index = 0;

	constructor(x, y) {
		# Save the x,y coordinates for later user
		m_x = x; m_y = y;

		# Create the achivement entris 
		m_achivement_entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(m_x, m_y+83*i);
			m_achivement_entries.push(entry)
		}

		# Add signal handler used for list navigation
		fe.add_signal_handler(this, "key_detect");
	}

	# Signal handler for navigatin the achievents list
	function key_detect(signal_str) {
		if (signal_str == "right") {
			# Select the next element in list
			m_selected_index++;

			# Prevent the selection to go over the end of the list
			if (m_selected_index > m_achivement_entries.len()) {
				m_selected_index = m_achivement_entries.len();
			}

			# Redraw the achievements list
			draw();

			# Prevent the default action for the button
			return true;
		}

		if (signal_str == "left") {
			# Select the previous element in the list
			m_selected_index--;

			# Prevent the selection to be negative
			if (m_selected_index < 0) {
				m_selected_index = 0;
			}

			# Redraw the achievements list
			draw();

			# Prevent the default action for the button
			return true;
		}
		
    	# Allow other signals to be handled normally
    	return false;
	}

	# Loads the achivements for the current game
	function load() {
		# Detect the rom name for the current game
		local rom = fe.game_info(Info.Name);
		
		# Move selection index to the begining of the list
		m_selected_index = 0;

		try {
			# Try to load the load achievements from the list
			m_info = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");

			# Draw the list of achievements
			draw();

		# If the achivements list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			hide();
		}
	}

	function draw() {
		# Sort achivements by keys, they are not sorted by default
		local keys = [];
		foreach (key, value in m_info.Achievements) {
		    keys.push(key);
		}
		keys.sort();

		# Calcuate the start/end indexes for the achivement info that is visible
		local start_index = 0
		local end_index = PAGE_SIZE;
		
		if (0 < m_selected_index - PAGE_SIZE) {
			start_index = m_selected_index - PAGE_SIZE;
			end_index = start_index + PAGE_SIZE;
		}

		foreach(entry_index,entry in m_achivement_entries) {
			# Translate the entry index to achivement info index
			local info_index = entry_index;
			if (m_selected_index >= PAGE_SIZE) {
				info_index += m_selected_index - PAGE_SIZE + 1;
			}
			
			# Load the info from the info_index into the entry
			local info = m_info.Achievements[keys[info_index]];
			entry.load(info);
			entry.deselect()

			# Mark the selected achivement
			if (m_selected_index == info_index) {
				entry.select();
			}
		}
	}

	# Hide the achivements
	function hide() {
		foreach(entry in m_achivement_entries) {
			entry.hide();
		}
	}
}
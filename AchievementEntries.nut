class AchievementEntries {
	PAGE_SIZE = 9;       # Number of achivements visible on screen
	_info = [];          # Array containing all the achivements
	_info_selected = 0;  # The index of the selected achivement
	_info_offset = 0;    # The index of the first visible achivement
	_entries = [];       # Array containing the achivement entries
	_is_active = false;  # Whether the list is active or not
	sound_engine = null;  

	constructor(x, y) {
		# Create the achivement entries
		_entries = [];
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = AchievementEntry(x, y+80*i);
			_entries.push(entry)
		}

		# Activate sound engine
		sound_engine = SoundEngine();

		# Load and draw the achivements for the current game
		load(); draw();

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");
	}

	function transition_callback(ttype, var, transition_time) {
		# When the selected game changes
		if (ttype == Transition.FromOldSelection) {

			# Load and draw the achivements for the current game
			load(); draw();
		}
	}

	# Signal handler for navigatin the achievents list
	function key_detect(signal_str) {
		if (signal_str == "next_game") {
			move_next();
			sound_engine.click()
			return true;
		}

		if (signal_str == "prev_game") {
			move_prev();
			sound_engine.click()
			return true;
		}

    	# Allow other signals to be handled normally
    	return false;
	}

	# Loads the achivements info for the current game
	function load() {
		# Detect the rom name for the current game
		local rom = fe.game_info(Info.Name);

		# Load the load achievements from the list
		try {
			local temp = dofile(fe.script_dir + "/achievements/nuts/"+rom+".nut");
			_info = temp.Achievements;
			sort();

		# If the achivements list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			_info = []
			hide();
		}

		# Set the indexes for the start / end and selected
		_info_selected = 0;
		_info_offset = 0;
	}

	# Sort the list of achivements
	function sort() {
		local sortedAchievements = [];
		local keys = [];

		foreach (key, value in _info) {
	    	keys.push(key);
		}
		
		keys.sort();

		for (local i=0; i<keys.len(); i++) {
			sortedAchievements.push(_info[keys[i]]);
		}

		_info = sortedAchievements;
	}

	function draw() {
		for (local i=0; i<PAGE_SIZE; i++) {
			local entry = _entries[i];

			# Load the achivement info if there is one
			if (_info_offset + i < _info.len()) {
				local info = _info[_info_offset + i];
				entry.load(info);

			# Else hide it from screen
			} else {
				entry.hide();
			}

			# Mark entry as selected, but only when the sidebox is active
			if (_is_active && _info_selected == _info_offset + i) {
				entry.select()
			} else {
				entry.deselect();
			}
		}
	}

	function move_next() {
		# If we're at the end of the list, no need to move forward
		if (_info_selected == _info.len() - 1) {
			return;
		}

		# Select the next element in list
		_info_selected++;

		# Scroll the list down if the selection is not visible
		if (_info_selected > _info_offset+PAGE_SIZE - 1) {
			_info_offset++;
		}

		draw();
	}

	function move_prev() {
		# If we're at the begining of the list, no need to move back
		if (_info_selected == 0) {
			return;
		}

		# Select the previous element in the list
		_info_selected--;

		# Scroll the list up if the selection is not visible
		if (_info_selected < _info_offset) {
			_info_offset--;
		}

		draw();
	}

	# Hide the achivements
	function hide() {
		foreach(entry in _entries) {
			entry.hide();
		}
	}

	function activate() {
		# Add signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");
		fe.add_signal_handler(this, "key_detect");

		_is_active = true;

		draw();
	}

	function desactivate() {
		# Remove signal handler used for list navigation
		fe.remove_signal_handler(this, "key_detect");

		_is_active = false;

		draw();
	}
}
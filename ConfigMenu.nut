class ConfigMenu {
	PAGE_SIZE = 7;

	dip_switches = [];
	first_idx = 0;
	selected_idx = 0;

	surface = [];
	menu_entrie = [];
	is_active = false;

	constructor() {
		debug();

		this.surface = fe.add_surface(1000, 1000);
		this.surface.set_pos(0, 200);

		# Background
		this.surface.add_image("images/config_menu.png", 0, 0);

		for (local i=0; i<PAGE_SIZE; i++) {
			local menu_entry = ConfigMenuEntry(this.surface, 70, 110+90*i);
			this.menu_entrie.push(menu_entry);
		}

		this.load(); 
		this.draw();

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");
	}

	function transition_callback(ttype, var, transition_time) {
		debug()

		if (ttype == Transition.FromOldSelection) {
			load(); draw();
		}
	}

	function key_detect(signal_str) {
		if (signal_str == "down") {
			this.move_next();
			return true;
		}

		if (signal_str == "up" ) {
			this.move_prev();
			return true;
		}

		return false;
	}

	function load() {
		debug();

		local rom = fe.game_info(Info.Name);

		# Load the load dip switches for the current game
		local dip_switches = [];
		try {
			dip_switches = dofile(fe.script_dir + "/dipswitches/nuts/"+rom+".nut");

		# If the dip switches list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			dip_switches = []
		}

		# Add only valid dip switches
		this.dip_switches = [];
		foreach (dip_switch in dip_switches) {
			if (dip_switch["name"] == "Unknown") {  continue; }
			if (dip_switch["name"] == "Unused")  {  continue; }
			this.dip_switches.push(dip_switch);
		}

		# Reset the offset and selected index
		this.selected_idx = 0;
		this.first_idx = 0;
	}

	function draw() {
		debug();

		for (local i=0; i<PAGE_SIZE; i++) {
			local dip_switch
			local menu_entry = this.menu_entrie[i]

			# Try to load the dipswitch at this position
			try {
				dip_switch = this.dip_switches[i + first_idx];
			} catch (e) {
				dip_switch = null;
			}

			# If we found a valid dipswitch, add it to the menu entires
			if (dip_switch) {
				menu_entry.set_title(dip_switch["name"]);
				menu_entry.set_value(dip_switch["default"]);	
				menu_entry.show();
			} else {
				menu_entry.hide();
			}

 			if (this.selected_idx == i + this.first_idx) {
 				menu_entry.select();
 			} else {
 				menu_entry.deselect();
 			}
		}
	}

	function move_next() {
		debug();

		# If we're at the end of the list, no need to move forward
		if (this.selected_idx == this.dip_switches.len() - 1) {
			return;
		}

		# Select the next element in list
		this.selected_idx++;

		# Scroll the list down if the selection is not visible
		if (this.selected_idx > this.first_idx + (PAGE_SIZE - 1)) {
			this.first_idx++;
		}

		draw();
	}

	function move_prev() {
		debug()

		# If we're at the begining of the list, no need to move back
		if (this.selected_idx == 0) {
			return;
		}

		# Select the previous element in the list
		this.selected_idx--;

		# Scroll the list up if the selection is not visible
		if (this.selected_idx < this.first_idx) {
			this.first_idx--;
		}

		draw();
	}

	function show() {
		this.is_active = true;
		this.surface.visible = true;

        local enlarge = {property = "scale", start=0.1, end=1, time = 300, 	tween = Tween.Quart}
        animation.add(PropertyAnimation(this.surface, enlarge));
	}

	function hide() {
		this.is_active = false;
		this.surface.visible = false;
	}
}
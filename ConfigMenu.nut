class ConfigMenu {
	PAGE_SIZE = 20;

	dip_switches = [];

	surface = [];
	menu_entrie = [];

	constructor() {
		debug();

		this.surface = fe.add_surface(1000, 1000);
		this.surface.set_pos(0, 200);

		# Background
		this.surface.add_image("images/config_menu_background.png", 0, 0);

		for (local i=0; i<PAGE_SIZE; i++) {
			local menu_entry = ConfigMenuEntry(this.surface, 40, 80+40*i);
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

	function load() {
		debug();

		local rom = fe.game_info(Info.Name);

		# Load the load dip switches for the current game
		local dip_switches = [];
		try {
			dip_switches = dofile(fe.script_dir + "/dipswitches/nuts/"+rom+".nut");

			# Debug 
			// foreach (i, dip_switch in this.dip_switches) {
			// 	print("* " + dip_switch["name"] + " = " + dip_switch["default"] + "\n");
			// }

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
	}

	function draw() {
		debug();

		for (local i=0; i<PAGE_SIZE; i++) {
			local dip_switch
			local menu_entry = menu_entrie[i]

			# Try to load the dipswitch at this position
			try {
				dip_switch = this.dip_switches[i];
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
		}
	}
}
class ConfigMenu {
	PAGE_SIZE = 10;

	dip_switches = [];

	surface = [];
	menu_entrie = [];

	constructor(x, y) {
		debug();

		this.surface = fe.add_surface(1000, 1000);
		this.surface.set_pos(x, y);


		for (local i=0; i<PAGE_SIZE; i++) {
			local menu_entry = ConfigMenuEntry(this.surface, 0, 0+30*i);
			this.menu_entrie.push(menu_entry);
		}

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
		try {
			local temp = dofile(fe.script_dir + "/dipswitches/nuts/"+rom+".nut");
			this.dip_switches = temp;

		# If the dip switches list was not loaded correctly (ex: missing or bad format)
		} catch(e) {
			this.dip_switches = []
		}
	}

	function draw() {
		debug();

		foreach (i, dip_siwtch in this.dip_switches) {
			print("* " + dip_siwtch["name"] + " = " + dip_siwtch["default"] + "\n");

			if (i<PAGE_SIZE) {
				menu_entrie[i].set_title(dip_siwtch["name"]);
				menu_entrie[i].set_value(dip_siwtch["default"]);
			}
		}
	}
}
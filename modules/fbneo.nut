/*
	dipswitch.get_name();
	dipswitch.get_value();
	dipswitch.get_default_value();
	dispwtich.get_possible_values();

	dipswitch.set_value(value);
	dipswitch.reset();
*/
class FBNeoDipSwitch {
	rom = "";
	name = "";
	values = [];
	current_idx = "";
	default_idx = "";
	is_advanced = false;

	constructor(rom, name, values, default_idx, is_advanced=false) {
		this.rom = rom;
		this.name = name;
		this.values = values;
		this.default_idx = default_idx;
		this.current_idx = default_idx;
		this.is_advanced = is_advanced;

		local saved_value = ini_read(AM_CONFIG["fbneo_config_file"], this.key());
		foreach(idx, value in this.values) {
			if (saved_value == value) {
				this.current_idx = idx;
			}
		}
	}

	function get_value() {
		return values[current_idx];
	}

	function get_name() {
		return this.name;
	}

	function get_possible_values() {
		return this.values;
	}

	function get_default_value() {
		return this.values[this.default_idx];
	}

	function key() {
		return "fbneo-dipswitch-"+this.rom+"-"+str_replace(" ", "_", this.name);
	}

	function write() {
		ini_write(AM_CONFIG["fbneo_config_file"], this.key(), this.get_value());
	}

	function set_current_idx(index) {
		if (index < 0 || index > this.values.len() - 1) {
			return;
		}

		this.current_idx = index;
		write();
	}

	function set_value(value) {
		local idx = this.values.find(value);
		if (idx == null) {
			idx = this.default_idx;
		}

		this.set_current_idx(idx);
	}

	function reset() {
		this.set_current_idx(this.default_idx);
	}
}


/*
	fbneo.dipswitches("mspacman");
*/
class FBNeo {
	function dipswitches(rom)
	{
		local json_info = [];

		try {
			json_info = dofile(fe.script_dir + "/modules/fbneo-dipswitches/"+rom+".nut");
		} catch(e) {
			print("WARNING: Cannot find dip switch definition file for rom '"+rom+"'.\n");
			return null;
		}

		local dipswitches = []
		foreach (entry in json_info) {
			local is_advanced = "advanced" in entry && entry["advanced"] == true ? true : false;
			local dipswitch = FBNeoDipSwitch(rom, entry["name"], entry["values"], entry["default"], is_advanced);

			dipswitches.push(dipswitch);
		}

		return dipswitches;
	}
}

# FBNeo API
fbneo <- FBNeo();
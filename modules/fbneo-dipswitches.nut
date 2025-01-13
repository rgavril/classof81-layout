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

		local saved_value = retroarch_config_read(AM_CONFIG["fbneo_config_file"], this.key());
		foreach(idx, value in this.values) {
			if (saved_value == value) {
				this.current_idx = idx;
			}
		}
	}

	function move_to_next_value() {
		local next_value_idx = (current_idx + 1) % values.len();
		this.current_idx = next_value_idx;

		this.write();
	}

	function move_to_prev_value() {
		local next_value_idx = (current_idx + values.len() - 1) % values.len();
		this.current_idx = next_value_idx;

		this.write();
	}

	function value() {
		return values[current_idx];
	}

	function default_value() {
		return values[default_idx];
	}

	function key() {
		return "fbneo-dipswitch-"+this.rom+"-"+str_replace(" ", "_", this.name);
	}

	function write() {
		retroarch_config_write(AM_CONFIG["fbneo_config_file"], this.key(), this.value());
	}

	function set(index) {
		if (index < 0 || index > this.values.len() - 1) {
			return;
		}

		this.current_idx = index;
		write();
	}

	function reset() {
		this.set(this.default_idx);
	}
}

class FBNeoDipSwitches {
	dip_switches = [];
	rom = null;

	constructor(rom)
	{
		this.dip_switches = [];
		this.rom = rom;

		local dip_switches_definition = [];
		try {
			dip_switches_definition = dofile(fe.script_dir + "/modules/fbneo-dipswitches/"+rom+".nut");
		} catch(e) {
			print("WARNING: Cannot find dip switch definitnion file from rom '"+rom+"'.\n");
		}

		foreach (definition in dip_switches_definition) {
			if (definition["name"] == "Unknown") {  continue; }
			if (definition["name"] == "Unused")  {  continue; }

			local is_advanced = "advanced" in definition && definition["advanced"] == true ? true : false;
			local dip_switch = FBNeoDipSwitch(rom, definition["name"], definition["values"], definition["default"], is_advanced);
			dip_switches.push(dip_switch);
		}
	}

	function len() {
		return dip_switches.len();
	}

	function get(index) {
		if (index < dip_switches.len()) {
			return dip_switches[index];
		} else {
			return null;
		}
	}
}
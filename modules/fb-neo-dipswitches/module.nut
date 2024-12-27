class FBNeoDipSwitch {
	rom = "";
	name = "";
	values = "";
	current_idx = "";
	default_idx = "";

	constructor(rom, name, values, default_idx) {
		this.name = name;
		this.values = values;
		this.default_idx = default_idx;
		this.current_idx = default_idx;
	}

	function move_to_next_value() {
		local next_value_idx = (current_idx + 1) % values.len();
		this.current_idx = next_value_idx;
	}

	function move_to_prev_value() {
		local next_value_idx = (current_idx + values.len() - 1) % values.len();
		this.current_idx = next_value_idx;
	}

	function current_value() {
		return values[current_idx];
	}

	function default_value() {
		return values[default_idx];
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
			dip_switches_definition = dofile(fe.script_dir + "/modules/fb-neo-dipswitches/definitions/"+rom+".nut");
		} catch(e) {
			print("WARNING: Cannot find dip switch definitnion file from rom '"+rom+"'");
		}

		foreach (definition in dip_switches_definition) {
			if (definition["name"] == "Unknown") {  continue; }
			if (definition["name"] == "Unused")  {  continue; }

			local dip_switch = FBNeoDipSwitch(rom, definition["name"], definition["values"], definition["default"]);
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
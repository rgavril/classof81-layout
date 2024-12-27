class FBNeoDipSwitch {
	FBNEO_CONFIG_FILE = "/Users/rgavril/Library/Application Support/RetroArch/config/FinalBurn Neo/FinalBurn Neo.opt"
	rom = "";
	name = "";
	values = "";
	current_idx = "";
	default_idx = "";

	constructor(rom, name, values, default_idx) {
		this.rom = rom;
		this.name = name;
		this.values = values;
		this.default_idx = default_idx;
		this.current_idx = default_idx;
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
		local key = "fbneo-dipswitch-"+this.rom+"-";

		foreach (position,word in split(this.name, " "))  {
			if (position != 0) {
				key += "_";
			}
			key += word;
		}

		return key;
	}

	function write() {
		local config_file = null;
		local temp_file = null;

		config_file = ReadTextFile("/", FBNEO_CONFIG_FILE);
		temp_file = WriteTextFile(FBNEO_CONFIG_FILE+".tmp");

		local was_replaced = false;
		while (!config_file.eos()) {
			local line = config_file.read_line();

			local parts = split(line, "=");
			if (parts.len() == 2) {
				local key = strip(parts[0]);
				if (key == this.key()) {
					temp_file.write_line(this.key() + " = \"" + this.value() + "\"\n");
					was_replaced = true;
					continue;
				}
			}

			temp_file.write_line(line + "\n");
		}

		if (! was_replaced) {
			temp_file.write_line(this.key() + " = \"" + this.value() + "\"\n");
		}

		rename(FBNEO_CONFIG_FILE+".tmp", FBNEO_CONFIG_FILE);
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
			print("WARNING: Cannot find dip switch definitnion file from rom '"+rom+"'.\n");
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
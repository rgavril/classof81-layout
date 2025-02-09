/*
	diversion.get(rom)
	diversion.set(rom, clone);
*/

class Diversions {
	CONFIG_FILE = fe.script_dir+"/config/versions.conf"

	ini_cache = {};

	function get(parent_rom) {
		local clone_rom = null;

		# Try to read if a diversion is in palce
		try {
			if (parent_rom in this.ini_cache) {
				clone_rom = this.ini_cache[parent_rom];
			} else {
				clone_rom = ini_read(CONFIG_FILE, parent_rom);
			}
		} catch(e) {
			print("WARNING: cannot read diversions from " + CONFIG_FILE + "\n");
			print(e+"\n\n\n\n");
			return parent_rom;
		}

		# If no diversion is in place, return parent_rom
		if (clone_rom == null) {
			return parent_rom;
		}

		# Reply with clone rom only when clone rom is valid
		if (parent_rom != clone_rom && romlist.game_clones(parent_rom).find(clone_rom) == null) {
			print("WARNING: Found invalid diversion of '"+parent_rom+"' to '"+clone_rom+"'\n");
			return parent_rom;
		}

		return clone_rom;
	}

	function set(parent_rom, clone_rom) {
		if ( parent_rom != clone_rom && romlist.game_clones(parent_rom).find(clone_rom) == null) {
			print("WARNING: Trying to set invalid diversion of "+parent_rom+" to "+clone_rom + "\n");
			return;
		}

		ini_write(CONFIG_FILE, parent_rom, clone_rom);

		this.ini_cache[parent_rom] <- clone_rom;
	}
}

diversions <- Diversions();
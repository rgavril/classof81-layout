class GameStartupPage
{
	surface = null;
	background_image = null;
	logo = null;
	is_active = false;
	warning_message = null;
	in_clone_list = false;
	rom = false;

	controls = {}

	info_label = {
		"left"    : {"line": null, "tag": null },
		"right"   : {"line": null, "tag": null },
		"up"      : {"line": null, "tag": null },
		"down"    : {"line": null, "tag": null },
		"button1" : {"line": null, "tag": null },
		"button2" : {"line": null, "tag": null },
		"start2"  : {"line": null, "tag": null },
	};

	constructor()
	{
		this.surface = fe.add_surface(960, 1280);
		this.surface.set_pos(0, 0);
		this.surface.visible = false;

		this.background_image = this.surface.add_image("images/controls.png", 0, 0);

		this.logo = this.surface.add_artwork("wheel", 45, 250);

		construct_control("button1", 667, 695, 150);
		construct_control("button2", 761, 695, 115);
		construct_control("up"     , 485, 502, 114); this.info_label["up"]["tag"].y = 485 - 15;
		construct_control("down"   , 485, 743, 150);
		construct_control("left"   , 432, 688, 155);
		construct_control("right"  , 541, 688, 122);
		construct_control("start2" , 200, 749, 101);
		
		fe.add_transition_callback(this, "transition_callback");

		this.controls = dofile(fe.script_dir + "/modules/controls.nut");

		this.warning_message = this.surface.add_text("WARNING:\nThis game requires more than 2 buttons. Controls may be limited!", 40, 360, 900, 100);
		this.warning_message.char_size = 26;
		this.warning_message.word_wrap = true;
		this.warning_message.style = Style.Bold;
		this.warning_message.set_rgb(255, 50, 50);
		this.warning_message.visible = false;

		fe.add_ticks_callback(this, "ticks_callback");
		draw();
	}

	function ticks_callback(tick_time) {
		# If the this page is active and we're in the clone list, we need to select a game
		if (this.is_active && this.in_clone_list) {
			local versions = RomVersions(this.rom);

			local selected_rom = fe.game_info(Info.Name);     # Current selected rom from attractmode
			local diverted_rom = versions.get_current_rom();  # Actual rom that we want to play

			# If the current game is not what we want to run move to next game
			if (selected_rom != diverted_rom) {
				fe.signal("next_game");

			# If the current game is what we want to run
			} else {
				# Reset the flat that notifies that we're in the clones list
				# this way we get out of the ticks loop
				this.in_clone_list = false;

				# Copy the dipswitches from the parent rom if this is a clone
				local parent_rom = versions.get_default_rom();
				if (parent_rom != diverted_rom) {
					local dipswitches = FBNeoDipSwitches(parent_rom);
					for(local idx=0; idx<dipswitches.len(); idx++) {
						local dipswitch = dipswitches.get(idx);

						dipswitch.rom = diverted_rom;
						dipswitch.write();
					}
				}

				# Simulate key presses to run the current game
				fe.signal("up"); fe.signal("up");
			}
		}
	}

	function draw()
	{

		# Calculate the size of the logo based on max 170 vertical / 300 horizontal
		local logo_height = 170;
		local logo_width = 170.0/this.logo.texture_height * this.logo.texture_width;
		if (logo_width > 300) {
			logo_width = 300;
			logo_height = 300.0/this.logo.texture_width * this.logo.texture_height;
		}
		this.logo.height = logo_height;
		this.logo.width = logo_width;
		this.logo.origin_y = logo_height/2;

		# Unset all labels
		foreach(label,info_label in this.info_label) {
			this.set_info_label(label, "");
		}

		# Hide Warning message
		this.warning_message.visible = false;

		local rom = fe.game_info(Info.Name);
		if (rom in this.controls) {
			local controls = this.controls[rom];

			# Joystick
			this.set_info_label("up"   , controls["joystick"][0]);
			this.set_info_label("down" , controls["joystick"][1]);
			this.set_info_label("left" , controls["joystick"][2]);
			this.set_info_label("right", controls["joystick"][3]);

			# Button 1
			if (controls["buttons"].len() >= 1) {
				this.set_info_label("button1", controls["buttons"][0]);
			} else {
				this.set_info_label("button1", "");
			}

			# Button 2
			if (controls["buttons"].len() >= 2) {
				this.set_info_label("button2", controls["buttons"][1]);
			} else {
				this.set_info_label("button2", "");
			}

			# Start Player 2
			if (controls["players"] >= 2)
			{
				this.set_info_label("start2", "2 PLAYERS START");
			} else {
				this.set_info_label("start2", "");
			}

			if (controls["buttons"].len() > 2) {
				this.warning_message.visible = true;
			}
		}
	}

	function set_info_label(label, value) {
		info_label[label]["tag"].msg = value.toupper();

		if (value != "") {
			info_label[label]["tag"].visible = true;
			info_label[label]["line"].visible = true;
		} else {
			info_label[label]["tag"].visible = false;
			info_label[label]["line"].visible = false;
		}
	}

	function construct_control(name, x, y, height) {
		local line = this.surface.add_image("images/line.png", x, y);
		line.height = height;
		line.origin_x = line.texture_width/2;

		local tag = this.surface.add_text(name.toupper(), x-150, y+height, 300, 32);
		tag.char_size = 18;
		tag.style = Style.Bold;
		tag.align = Align.MiddleCentre;

		this.info_label[name]["line"] = line;
		this.info_label[name]["tag"] = tag;
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) {
			return false;
		}

		# While in clone list selection, only accept next_game signals
		if (this.in_clone_list) {
			if ( signal_str != "next_game") {
				return true;
			}
		# If not i clone list selection, all signals are select
		} else {
			if ( signal_str != "select" ) {
				fe.signal("select");
				return true;
			}
		}

		return false;
	}

	function transition_callback(ttype, var, transition_time)
	{
		# Delay the starting of the game to play a sound
		if (ttype == Transition.ToGame) {
			if (transition_time == 0) {
				::sound_engine.play_enter_sound();
				return true;
			}

			if (transition_time < 250)  {
				return true;
			}

			this.hide();
			return false;
		}

		# When a list change is made while the start page is active
		# it means that we moved to a clone select list
		if (ttype == Transition.ToNewList && this.is_active) {
			this.in_clone_list = true;
		}

		if (ttype == Transition.FromOldSelection) {
			draw();
		}
	}

	function show()
	{
		::sound_engine.play_enter_sound();
		this.is_active = true;
		this.surface.visible = true;
		this.in_clone_list = false;
		this.rom = fe.game_info(Info.Name);
	}

	function hide()
	{
		this.is_active = false;
		this.surface.visible = false;
	}
}
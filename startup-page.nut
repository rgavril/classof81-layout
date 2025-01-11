class StartupPage
{
	surface = null;
	background_image = null;
	wheel = null;
	is_active = false;
	warning_message = null;

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

		this.wheel = this.surface.add_artwork("wheel", 30, 190);
		this.wheel.preserve_aspect_ratio = true;

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

		draw();
	}

	function draw()
	{

		# Resize the game logo
		this.wheel.height = 120;
		if (this.wheel.texture_width > 400) {
			this.wheel.width = 400;
		}

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
		if ( signal_str != "select" ) {
			fe.signal("select");
			return true;
		}

		return false;
	}

	function transition_callback(ttype, var, transition_time)
	{
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

		if (ttype == Transition.FromOldSelection) {
			draw();
		}
	}

	function show()
	{
		::sound_engine.play_enter_sound();
		this.is_active = true;
		this.surface.visible = true;
	}

	function hide()
	{
		this.is_active = false;
		this.surface.visible = false;
	}
}
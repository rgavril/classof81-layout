class StartupPage
{
	surface = null;
	background_image = null;
	is_active = false;

	info_label = {
		"P1_JOYSTICK_LEFT"   : {"line": null, "tag": null },
		"P1_JOYSTICK_RIGHT"  : {"line": null, "tag": null },
		"P1_JOYSTICK_UP"     : {"line": null, "tag": null },
		"P1_JOYSTICK_DOWN"   : {"line": null, "tag": null },
		"P1_BUTTON1"         : {"line": null, "tag": null },
		"P1_BUTTON2"         : {"line": null, "tag": null },
		"p2"                 : {"line": null, "tag": null },
	};

	constructor()
	{
		this.surface = fe.add_surface(960, 1280);
		this.surface.set_pos(0, 0);
		// this.surface.visible = false;	

		this.background_image = this.surface.add_image("images/controls.png", 0, 0);

		local snap = this.surface.add_artwork("wheel", 30, 200);
		snap.preserve_aspect_ratio = true;
		snap.width = 400;

		construct_control("P1_BUTTON1"       , 667, 695, 115);
		construct_control("P1_BUTTON2"       , 761, 695, 150);
		construct_control("P1_JOYSTICK_UP"   , 485, 502, 114); this.info_label["P1_JOYSTICK_UP"]["tag"].y = 485 - 15;
		construct_control("P1_JOYSTICK_DOWN" , 485, 743, 150);
		construct_control("P1_JOYSTICK_LEFT" , 432, 688, 150);
		construct_control("P1_JOYSTICK_RIGHT", 541, 688, 150);
		construct_control("p2"               , 200, 749, 101);
		
		fe.add_transition_callback(this, "transition_callback");

		draw();
	}

	function draw()
	{
		foreach (name, label in info_label) {
			local rom = fe.game_info(Info.Name);
			local tag_msg = ini_read("/Users/rgavril/Downloads/controls.ini", rom, name);

			if (tag_msg == null || tag_msg == "") {
				label["tag"].visible = false;
				label["line"].visible = false;
				continue;
			}

			label["tag"].visible = true;
			label["line"].visible = true;
			label["tag"].msg = tag_msg.toupper();
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
				print("transition_callback\n\n");
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
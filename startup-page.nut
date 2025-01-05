class StartupPage
{
	surface = null;
	background_image = null;
	is_active = false;

	controls = {
		"left"   : {"line": null, "label": null },
		"right"  : {"line": null, "label": null },
		"up"     : {"line": null, "label": null },
		"down"   : {"line": null, "label": null },
		"button1": {"line": null, "label": null },
		"button2": {"line": null, "label": null }
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

		construct_control("button1", 667, 695, 115);
		construct_control("button2", 761, 695, 150);
		construct_control("up"     , 485, 502, 114);
		this.controls["up"]["label"].y = 485 - 15;
		construct_control("down"   , 485, 743, 150);
		construct_control("left"   , 432, 688, 150);
		construct_control("right"  , 541, 688, 150);
		construct_control("p2"     , 200, 749, 101);
		
		fe.add_transition_callback(this, "transition_callback");
	}

	function construct_control(name, x, y, height) {
		local line = this.surface.add_image("images/line.png", x, y);
		line.height = height;
		line.origin_x = line.texture_width/2;

		local label = this.surface.add_text(name.toupper(), x-150, y+height, 300, 32);
		label.char_size = 18;
		label.style = Style.Bold;
		label.align = Align.MiddleCentre;

		this.controls[name]["line"] = line;
		this.controls[name]["label"] = label;
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
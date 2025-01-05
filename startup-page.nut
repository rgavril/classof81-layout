class StartupPage
{
	surface = null;
	background_image = null;
	is_active = false;

	constructor()
	{
		this.surface = fe.add_surface(960, 1280);
		this.surface.set_pos(0, 0);
		this.surface.visible = false;	

		this.background_image = this.surface.add_image("images/controls.png", 0, 0);

		local snap = this.surface.add_artwork("wheel", 30, 200);
		snap.preserve_aspect_ratio = true;
		snap.width = 400;
		
		fe.add_transition_callback(this, "transition_callback");
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
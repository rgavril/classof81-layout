fe.do_nut("Sections/RightBox/RightBoxOverview.nut");
fe.do_nut("Sections/RightBox/RightBoxAchievements.nut");
fe.do_nut("Sections/RightBox/RightBoxLeaderboards.nut");

class RightBoxBackground
{
	_box = null;

	constructor()
	{
		this._box = fe.add_rectangle(460, 220, 480, 870);
		// this._box.set_rgba(0, 0, 0, 0);
		this._box.outline = -15;
		this._box.corner_radius = 15;
		this._box.corner_points = 32;
		this._box.set_outline_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2]);
		this._box.set_rgb(0,0,100);
		this._box.alpha = 155;
		
		// fe.add_image("images/fade.png", 475, 235);
	}

	function activate()
	{
		this._box.set_outline_rgb(COLOR.accent_two[0], COLOR.accent_two[1], COLOR.accent_two[2]);
	}

	function desactivate()
	{
		this._box.set_outline_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2]);
	}
}

class RightBoxConnectionBar
{
	vbar = null;
	hbar = null;
	surface = null;

	constructor()
	{
		this.surface = fe.add_surface(260, 340, 200, 190);

		this.hbar = this.surface.add_rectangle(0, 65, 200, 15);
		this.hbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2]);

		this.vbar = this.surface.add_rectangle(190, 5, 20, 180);
		this.vbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2]);
		this.vbar.corner_radius = 10;
	}

	function activate()
	{
		this.vbar.set_rgb(COLOR.accent_two[0], COLOR.accent_two[1], COLOR.accent_two[2]);
		this.hbar.set_rgb(COLOR.accent_two[0], COLOR.accent_two[1], COLOR.accent_two[2]);
	}

	function desactivate()
	{
		this.vbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2]);
		this.hbar.set_rgb(COLOR.accent_one[0], COLOR.accent_one[1], COLOR.accent_one[2]);
	}

	function move_to(position)
	{
		this.surface.y = 240 + position * 130;
	}
}

class RightBox
{
	is_active = false;
	_background = null;
	_connection_bar = null;

 	displays = [];
 	active_display_idx = 0;

	constructor()
	{
		this._background = RightBoxBackground();
		this._connection_bar = RightBoxConnectionBar();

		this.displays.push(RightBoxOverview());
		this.displays.push(RightBoxAchievements());
		this.displays.push(RightBoxLeaderboards());
		this.show_display(0);

		# Add a callback to redraw when game is changed
		fe.add_transition_callback(this, "transition_callback");
	}

	function active_display() {
		return this.displays[this.active_display_idx];
	}

	function show_display(idx) {
		this.active_display_idx = idx

		foreach (display in displays) {
			display.desactivate();
			display.hide();
		}

		this.active_display().activate();
		this.active_display().show();
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			show_display(0);
			this._connection_bar.move_to(fe.list.index % 6);
		}

		if (ttype == Transition.ToNewList) {
			this._connection_bar.move_to(fe.list.index % 6);
		}
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) {
			return false;
		}

		if (this.active_display().key_detect(signal_str)) {
			return true;
		}

		switch (signal_str)
		{
			case "select":
				return true;
			break;

			case "left": 
				::sound_engine.play_click_sound()
				GameList.activate();
				this.desactivate();
				return true;
			break;

			case "right":
				local next_display_idx = (this.active_display_idx + 1 ) % this.displays.len()
				# Play a sound
				::sound_engine.play_click_sound()
				this.show_display(next_display_idx);
				return true;
			break;

			case "up":
			case "down":
				return true;
			break;
		}

		return false;
	}

	function activate()
	{
		this.is_active = true;
		this._background.activate();
		this._connection_bar.activate();
		this.active_display().activate();
	}

	function desactivate()
	{
		this.is_active = false;
		this._background.desactivate();
		this._connection_bar.desactivate();
		this.active_display().desactivate();
	}
}
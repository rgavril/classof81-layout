class RightBox
{
	is_active = false;
	border_image = null;
	connection_bar = null;

 	displays = [];
 	active_display_idx = 0;

	overview = null;
	achievements = null;

	constructor()
	{
		# Sidebox Border
		this.border_image = fe.add_image("images/sidebox_inactive.png", 460, 220);

		# Connection Bar
		this.connection_bar = fe.add_image("images/connection_bar_inactive.png", 460, 340);
		this.connection_bar.origin_x = this.connection_bar.texture_width;
		this.connection_bar.origin_y = this.connection_bar.texture_height / 2;
		this.connection_bar.visible = true;

		# Snap
		local snap = fe.add_artwork("snap", 0, 0);
		snap.width  = 450;
		snap.height = snap.width * 4/3;
		snap.x      = 475;
		snap.y      = 235 + 840 - snap.height;
		// snap.alpha  = 50;

		# Snap Fade
		fe.add_image("images/fade.png", 475, 235);

		draw();

		this.displays.push(RightBoxOverview());
		this.displays.push(RightBoxAchievements());
		this.displays.push(RightBoxLeaderboards());
		show_display(0);

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
			draw();
		}

		if (ttype == Transition.ToNewList) {
			draw();
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
				game_buttons.activate();
				right_box.desactivate();
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

	function draw()
	{
		# Sidebox Border
		if (this.is_active) {
			this.border_image.file_name = "images/sidebox_active.png";
		} else {
			this.border_image.file_name = "images/sidebox_inactive.png";
		}

		# Connection Bar Image
		if (this.is_active) {
			this.connection_bar.file_name = "images/connection_bar_active.png"
		} else {
			this.connection_bar.file_name = "images/connection_bar_inactive.png"
		}

		# Connection Bar Location
		this.connection_bar.y = 340 + (fe.list.index % 6) * 130;
	}

	function activate()
	{
		this.is_active = true;
		this.active_display().activate();
		draw();
	}

	function desactivate()
	{
		this.is_active = false;
		this.active_display().desactivate();
		draw();
	}
}
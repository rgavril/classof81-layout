class RightBox
{
	is_active = false;
	border_image = null;
	connection_bar = null;

	overview_surface = null;
	overview_window = null;
	overview_text = null;

	constructor()
	{

		# Snap
		local snap = fe.add_artwork("snap", 0, 0);
		snap.width = 450;
		snap.height = snap.width * 4/3;
		snap.x = 475;
		snap.y = 235+840 - snap.height;
		// snap.shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		fe.add_image("images/test.png", 475, 235);


		# Title Shadow
		local title_shadow = fe.add_text("[!TitleFormated]", 475+1, 235+1, 450, 50)
		title_shadow.font = "CriqueGrotesk-Bold.ttf"
		title_shadow.set_rgb(0,0,0)
		title_shadow.char_size = 36
		title_shadow.align = Align.TopCentre

		# Title
		local title = fe.add_text("[!TitleFormated]", 475, 235, 450, 50)
		title.font = "CriqueGrotesk-Bold.ttf";
		title.set_rgb(255,104,181);
		title.char_size = 36;
		title.align = Align.TopCentre;

		# Subtitle
		// local subtitle = fe.add_text("[Year] [Manufacturer]", 475, 235+50, 450, 50);
		// subtitle.set_rgb(255,252,103);
		// subtitle.char_size = 26;
		// subtitle.align = Align.TopCentre;

		# Sidebox Border
		this.border_image = fe.add_image("images/sidebox_active.png", 460, 220);
		this.border_image.visible = false;

		# Connection Bar
		this.connection_bar = fe.add_image("images/connection_bar_inactive.png", 460, 340);
		this.connection_bar.origin_x = this.connection_bar.texture_width;
		this.connection_bar.origin_y = this.connection_bar.texture_height / 2;
		this.connection_bar.visible = true;

		# Overview
		this.overview_window = fe.add_surface(450, 840-60-50);
		this.overview_window.set_pos(475, 235+60);

		this.overview_surface = this.overview_window.add_surface(450, 5000);
		this.overview_text = this.overview_surface.add_text("[Overview]", 0, 0, 450, this.overview_window.height);
		overview_text.align = Align.TopLeft;
		overview_text.char_size = 26;
		overview_text.word_wrap = true;
		overview_text.margin = 20;
		overview_text.set_rgb(255, 252, 103);

		draw();

		# Add a callback to refresh the buttons when events take place
		fe.add_transition_callback(this, "transition_callback");
		
		# Add a tick call back to resend key events as long as a key is pressed
		fe.add_ticks_callback(this, "ticks_callback");
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			draw();
		}
	}

	function key_detect(signal_str)
	{
		switch (signal_str)
		{
			case "down"   : this.down_action()   ; break;
			case "up"     : this.up_action()     ; break;
			default:
				return false;
		}
		return true;
	}

	# We use this callback to move trough menu buttons when a key is hold
	down_hold_start = 0; up_hold_start = 0;
	function ticks_callback( tick_time ) 
	{
		# Don't register keys if we're not active
		if (! this.is_active) { return; }

		if (fe.get_input_state("down")) { 
			if (down_hold_start == 0) {
				down_hold_start = tick_time + 500;
			}

			if (tick_time - down_hold_start > 100) {
				down_hold_start = tick_time;
				this.key_detect("down");
			}
		} else {
			down_hold_start = 0;
		}

		if (fe.get_input_state("up")) { 
			if (up_hold_start == 0) {
				up_hold_start = tick_time + 500;
			}

			if (tick_time - up_hold_start > 100) {
				up_hold_start = tick_time;
				this.key_detect("up");
			}
		} else {
			up_hold_start = 0;
		}
	}

	function draw()
	{
		# Sidebox Border
		this.border_image.visible = this.is_active;

		# Connection Bar Image
		if (this.is_active) {
			this.connection_bar.file_name = "images/connection_bar_active.png";
		} else {
			this.connection_bar.file_name = "images/connection_bar_inactive.png";
		}

		# Connection Bar Location
		this.connection_bar.y = 340 + (fe.list.index % 6) * 130;

		# Reset overview scroll
		this.overview_surface.y = 0;
		this.overview_text.height = this.overview_window.height;
		animation.add(PropertyAnimation(this.overview_text, { property = "height", end="+0", time = 100, tween = Tween.Linear }));
		animation.add(PropertyAnimation(this.overview_surface, { property = "y"  , end=0   , time = 100, tween = Tween.Linear }));
	}

	function down_action()
	{
		local offset = 26*2;
		if (this.overview_surface.y + offset > 0) {
			offset = 0 - this.overview_surface.y;
		}
		
		// this.overview_text.height -= offset;
		// this.overview_surface.y += offset;
		animation.add(PropertyAnimation(this.overview_text   , { property = "height", end="-"+offset, time = 100, tween = Tween.Linear }));
		animation.add(PropertyAnimation(this.overview_surface, { property = "y"     , end="+"+offset, time = 100, tween = Tween.Linear }));
	}

	function up_action()
	{
		local offset = 26*2;
		
		this.overview_text.height += offset;
		local new_message = this.overview_text.msg_wrapped;

		this.overview_text.height -= offset;
		local old_message = this.overview_text.msg_wrapped;

		if (new_message == old_message) {
			offset = 0;
		}

		// this.overview_text.height += offset;
		// this.overview_surface.y -= offset;
		animation.add(PropertyAnimation(this.overview_text   , { property = "height", end="+"+offset, time = 100, tween = Tween.Linear }));
		animation.add(PropertyAnimation(this.overview_surface, { property = "y"     , end="-"+offset, time = 100, tween = Tween.Linear }));
	}

	function activate()
	{
		this.is_active = true;
		draw();
	}

	function desactivate()
	{
		this.is_active = false;
		draw();
	}
}
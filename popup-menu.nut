
class PopupMenu {
	message = "";
	options = [];
	select_idx = 0;

	surface = null;
	background_top = null;
	background_bottom = null;
	message_label = null;

	MAX_OPTIONS = 19;
	options_background = [];
	options_text = [];

	is_active = true;

	function constructor()
	{
		this.surface = fe.add_surface(1000, 1280);
		this.surface.set_pos(0, 0);
		this.surface.visible = false;

		this.select_idx = 0;
		this.options = [];
		this.is_active = false;

		# Background
		this.background_top = this.surface.add_image("images/popup_menu.png", 0, 0);
		this.background_bottom = this.surface.add_clone(this.background_top);

		# Message
		this.message_label = this.surface.add_text("", this.background_top.texture_width/2 - 250, 80, 500,200);
		this.message_label.font = "fonts/CriqueGrotesk-Bold.ttf";
		this.message_label.set_rgb(255, 255, 255);
		this.message_label.char_size = 26;
		this.message_label.word_wrap = true;
		this.message_label.align = Align.TopCentre;

		# Popup Option Buttons
		for (local idx=0; idx<MAX_OPTIONS; idx++) {
			local background = this.surface.add_image("images/popup_option.png", 260, 160+50*idx);
			background.visible = false;
			this.options_background.push(background);

			local text = this.surface.add_text("", background.x, background.y+background.texture_height/2, background.texture_width, background.height);
			text.set_rgb(255, 255, 255);
			text.char_size = 26;
			text.font = "fonts/CriqueGrotesk-Bold.ttf";
			text.align = Align.MiddleLeft;
			text.margin = 30;
			text.visible = false;
			this.options_text.push(text);
		}

		draw();

		fe.add_ticks_callback(this, "ticks_callback");
	}

	last_scroll_text = "";
	last_scroll_tick = 0;
	last_scroll_idx = 0;
	function ticks_callback(tick_time) {
		# Don't scroll if we're not active
		if (!this.is_active) {
			return;
		}

		# Calculate the wait time till the next scroll
		local wait_tick_time = 100;
		if (last_scroll_idx == 0) {
			wait_tick_time = 500;
		}

		# If not enough time passed, skip this scroll
		if (tick_time < last_scroll_tick + wait_tick_time) {
			return;
		# Else update last scroll time
		} else {
			last_scroll_tick = tick_time;
		}

		# Get a hold of the container and the text we need to scroll
		local container = this.options_text[this.select_idx];
		local scroll_text = this.options[this.select_idx];

		# Don't scroll if text fits the container
		container.msg = scroll_text;
		if (strip(container.msg) == strip(container.msg_wrapped)) {
			return;
		}

		# If the scrollable text changed, reset scroll index
		if (last_scroll_text != scroll_text) {
			last_scroll_idx = 0;
			last_scroll_text = scroll_text;
		# Else increase the scroll index
		} else {
			last_scroll_idx++;
		}

		# If scroll index is at the end, reset it
		local scroll_space = "      ";
		if (last_scroll_idx > scroll_text.len() + scroll_space.len()){
			last_scroll_idx = 0;
		}

		# Duplicate the scroll text so it will look as it repeats
		scroll_text = scroll_text + scroll_space + scroll_text;
		container.msg = scroll_text.slice(last_scroll_idx);
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) {
			return false;
		}
		
		switch (signal_str)
		{
			case "down"   : this.down_action()   ; break;
			case "up"     : this.up_action()     ; break;
			case "select" : this.select_action() ; break;	
		}
		return true;
	}

	function draw()
	{
		# Update message
		this.message_label.msg = this.message;

		# First hide all options
		for (local idx=0; idx<MAX_OPTIONS; idx++) {
			options_text[idx].visible = false;
			options_background[idx].visible = false;
		}

		# Now create and show options that are active
		foreach(idx,option in this.options) {

			# Set the text of the option
			options_text[idx].msg = option;
			options_text[idx].visible = true;

			# Add "..."" if the text doesn't fit the box
			if (strip(options_text[idx].msg) != strip(this.options_text[idx].msg_wrapped)) {
				options_text[idx].msg = strip(options_text[idx].msg_wrapped).slice(0, -3) + "...";
			}

			# Show the option
			options_background[idx].visible = true;

			# Set it as seletion state of the option
			if (this.select_idx == idx) {
				this.options_text[idx].set_rgb(100, 71, 145);
				this.options_background[idx].file_name = "images/popup_option_selected.png";
			} else {
				this.options_text[idx].set_rgb(255, 255, 255);
				this.options_background[idx].file_name = "images/popup_option.png";
			}
		}

		# Hide the unused top backgroun image
		local visible_height = this.options.len() * 50 + 170;
		this.background_top.subimg_height = visible_height;
		
		# Move the bottom background image in place
		this.background_bottom.subimg_y = this.background_bottom.texture_height - 75;
		this.background_bottom.y = visible_height;

		# Set surface origin so that is centered
		this.surface.origin_y = (visible_height+75-1280)/2;
	}

	function set_options(options, select_idx) {
		this.options = options;
		this.select_idx = select_idx;

		# If we need to display more options than we can
		if (options.len() >= this.MAX_OPTIONS) {
			# Write a error message
			print("WARNING: Popup cannot display more that "+this.MAX_OPTIONS+" options. List was truncated");

			# Truncate the options list
			this.options = options.slice(0, this.MAX_OPTIONS)

			# Ensure the selected idx is in the list
			if (this.select_idx >= this.MAX_OPTIONS) { this.select_idx = 0; }
		}
	}

	function set_message(message)
	{
		this.message = message;
	}

	function show()
	{
		::sound_engine.play_enter_sound();

		this.is_active = true;
		this.draw();

		local startY = (this.options.len() * 50 + 170) / 2;
        animation.add(PropertyAnimation(this.surface, {property = "y", start=startY, time = 150, tween = Tween.Quart}));
        animation.add(PropertyAnimation(this.surface, {property = "height", start=0, time = 150, center={x=0,y=500}, tween = Tween.Quart}));
        animation.add(PropertyAnimation(this.surface, {property = "alpha", start=0, end=255, time = 150, tween = Tween.Quart}));

		this.surface.visible = true;
	}

	function hide()
	{
		this.is_active = false;
		// this.surface.visible = false;

        animation.add(PropertyAnimation(this.surface,{property = "alpha", start=255, end=0, time = 200, tween = Tween.Quart}));
	}

	function down_action()
	{
		if (this.select_idx + 1 in this.options) {
			::sound_engine.play_click_sound();
			this.select_idx += 1;
			draw();
		}
	}

	function up_action()
	{
		if (this.select_idx - 1 in this.options) {
			::sound_engine.play_click_sound();
			this.select_idx -= 1;
			draw();
		}
	}

	function select_action()
	{
		::sound_engine.play_enter_sound();

		this.hide();

		fe.signal("custom1");
	}

	function last_selected_idx()
	{
		return this.select_idx;
	}

	function last_selected_value()
	{
		return this.options[this.select_idx];
	}
}
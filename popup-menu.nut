
class PopupMenu {
	title = "";
	options = [];
	select_idx = 0;

	surface = null;
	background_top = null;
	background_bottom = null;
	title_label = null;

	MAX_OPTIONS = 20;
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

		# Title
		this.title_label = this.surface.add_text("", this.background_top.texture_width/2 - 250, 80, 500,200);
		this.title_label.font = "fonts/CriqueGrotesk-Bold.ttf";
		this.title_label.set_rgb(255, 255, 255);
		this.title_label.char_size = 26;
		this.title_label.word_wrap = true;
		this.title_label.align = Align.TopCentre;

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
			text.margin = 40;
			text.visible = false;
			this.options_text.push(text);
		}

		draw();
	}

	function key_detect(signal_str)
	{
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
		# Update title
		this.title_label.msg = "Choose a new setting for\n"+this.title+":";

		# First hide all options
		for (local idx=0; idx<MAX_OPTIONS; idx++) {
			options_text[idx].visible = false;
			options_background[idx].visible = false;
		}

		# Now create and show options that are active
		foreach(idx,option in this.options) {
			if (idx >= this.MAX_OPTIONS) {
				print("WARNING: Popup cannot display all options.");
				break;
			}

			# Set the text of the option
			options_text[idx].msg = option;
			options_text[idx].visible = true;

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
	}

	function set_title(title)
	{
		this.title = title.toupper();
	}

	function show()
	{
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
			this.select_idx += 1;
			draw();
		}
	}

	function up_action()
	{
		if (this.select_idx - 1 in this.options) {
			this.select_idx -= 1;
			draw();
		}
	}

	function select_action()
	{
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
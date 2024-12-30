
class PopupOptions {
	title = "BONUS";
	options = [
		"Yes",
		"No"
		// "20,000 and 70,000",
		// "20,000 and 60,000",
		// "20,000 and 80,000",
		// "30,000 and 100,000",
		// "20,000",
		// "20,000 and every 70,000",
		// "20,000 and every 80,000",
		// "None"
	];

	surface = null;
	background_top = null;
	background_bottom = null;
	title_label = null;

	MAX_OPTIONS = 10;
	options_background = [];
	options_text = [];

	function constructor()
	{
		this.surface = fe.add_surface(1000, 1280);
		this.surface.set_pos(0, 0);

		# Background
		this.background_top = this.surface.add_image("images/popup_menu.png", 0, 0);

		this.background_bottom = this.surface.add_clone(this.background_top);

		# Title
		this.title_label = this.surface.add_text("", this.background_top.texture_width/2 - 250, 80, 500,200);
		this.title_label.font = "CriqueGrotesk-Bold.ttf";
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
			text.font = "CriqueGrotesk-Bold.ttf";
			text.align = Align.MiddleLeft;
			text.margin = 40;
			text.visible = false;
			this.options_text.push(text);
		}

		draw();
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
			options_text[idx].msg = option;
			options_text[idx].visible = true;

			options_background[idx].visible = true;
		}

		# Hide the unused top backgroun image
		local visible_height = this.options.len() * 50 + 170;
		this.background_top.subimg_height = visible_height;
		
		# Move the bottom background image in place
		this.background_bottom.subimg_y = this.background_bottom.texture_height - 75;
		this.background_bottom.y = visible_height;

		# Set surface hieght so we can center it
		this.surface.origin_y = (visible_height+75-1280)/2;
	}
}
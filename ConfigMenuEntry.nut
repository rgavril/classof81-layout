class ConfigMenuEntry {
	title = "";
	value = "";
	options = [];

	surface = null;
	title_label = null;
	value_label = null;
	background_image = null;

	constructor(parent_surface, x, y) {
		this.surface = parent_surface.add_surface(1000, 1000);
		this.surface.set_pos(x, y);
		
		# Background
		this.background_image = this.surface.add_image("images/config_menu_entry.png", 0, 0);

		# Title
		this.title_label = this.surface.add_text(title, this.background_image.x + 20, this.background_image.y, this.background_image.texture_width - 40, this.background_image.texture_height);
		title_label.align = Align.MiddleLeft;
		title_label.char_size = 32;
		title_label.style = Style.Bold;
		title_label.set_rgb(255, 255, 255);

		# Value
		this.value_label = this.surface.add_text(value, this.background_image.x + 20, this.background_image.x, this.background_image.texture_width - 40, this.background_image.texture_height);
		value_label.align = Align.MiddleRight;
		value_label.char_size = 32;
		value_label.style = Style.Bold;
		value_label.set_rgb(255, 255, 255);
	}

	function set_title(text) {
		this.title_label.msg = text + ":";
	}

	function set_value(text) {
		this.value_label.msg = text;
	}

	function hide() {
		this.surface.visible = false;
	}

	function show() {
		this.surface.visible = true;
	}
}
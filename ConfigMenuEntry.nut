class ConfigMenuEntry {
	title = "";
	value = "";
	options = [];

	surface = null;
	title_label = null;
	value_label = null;
	background_image = null;

	name = "";
	option = "";

	constructor(parent_surface, x, y) {
		this.surface = parent_surface.add_surface(1000, 100);
		this.surface.set_pos(x, y);
		
		# Background
		this.background_image = this.surface.add_image("images/config_menu_entry.png", 0, 0);

		# Title
		this.title_label = this.surface.add_text(title, this.background_image.x + 25, this.background_image.y - 1, this.background_image.texture_width - 50, this.background_image.texture_height);
		title_label.align = Align.MiddleLeft;
		title_label.char_size = 32;
		title_label.style = Style.Bold;
		title_label.set_rgb(255, 255, 255);

		# Value
		this.value_label = this.surface.add_text(value, this.background_image.x + 25, this.background_image.y - 1, this.background_image.texture_width - 50, this.background_image.texture_height);
		value_label.align = Align.MiddleRight;
		value_label.char_size = 32;
		value_label.style = Style.Bold;
		value_label.set_rgb(255, 255, 255);
	}

	function draw() {
		this.title_label.msg = name.toupper();

		if (option == null) {
			this.title_label.align = Align.MiddleCentre;
			this.value_label.visible = false;
		} else {
			this.title_label.msg += ":";
			this.title_label.align = Align.MiddleLeft;

			this.value_label.msg = option;
			this.value_label.visible = true;
		}
	}

	function set_label(name, option=null) {
		
		this.name = name;
		this.option = option;

		draw();
	}

	function hide() {
		this.surface.visible = false;
	}

	function show() {
		this.surface.visible = true;
	}

	function select() {
		this.background_image.file_name = "images/config_menu_entry_selected.png"
		this.title_label.set_rgb(100, 71, 145)
		this.value_label.set_rgb(100, 71, 145)
	}

	function deselect() {
		this.background_image.file_name = "images/config_menu_entry.png"
		this.title_label.set_rgb(255, 255, 255)
		this.value_label.set_rgb(255, 255, 255)
	}
}
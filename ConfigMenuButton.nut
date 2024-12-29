class ConfigMenuButton {
	title = "";
	value = "";

	surface = null;
	name_label = null;
	value_label = null;
	background_image = null;

	name = "";
	value = "";

	is_selected = false;

	on_select = {
		"obj": null,
		"method": null
	}

	constructor(parent_surface, x, y) {
		this.surface = parent_surface.add_surface(1000, 100);
		this.surface.set_pos(x, y);
		
		# Background
		this.background_image = this.surface.add_image("images/config_menu_entry.png", 0, 0);

		# Title
		this.name_label = this.surface.add_text(title, this.background_image.x + 25, this.background_image.y - 1, this.background_image.texture_width - 50, this.background_image.texture_height);
		name_label.align = Align.MiddleLeft;
		name_label.char_size = 32;
		name_label.style = Style.Bold;
		name_label.set_rgb(255, 255, 255);

		# Value
		this.value_label = this.surface.add_text(value, this.background_image.x + 25, this.background_image.y - 1, this.background_image.texture_width - 50, this.background_image.texture_height);
		value_label.align = Align.MiddleRight;
		value_label.char_size = 32;
		value_label.style = Style.Bold;
		value_label.set_rgb(255, 255, 255);
	}

	function draw() {
		this.name_label.msg = name.toupper();
		this.name_label.align = Align.MiddleCentre;
		this.value_label.visible = false;

		if (this.value != null) {
			this.name_label.msg += ":";
			this.name_label.align = Align.MiddleLeft;

			this.value_label.msg = this.value;
			this.value_label.visible = true;
		}

		if (this.is_selected) {
			this.background_image.file_name = "images/config_menu_entry_selected.png"
			this.name_label.set_rgb(100, 71, 145)
			this.value_label.set_rgb(100, 71, 145)
		} else {
			this.background_image.file_name = "images/config_menu_entry.png"
			this.name_label.set_rgb(255, 255, 255)
			this.value_label.set_rgb(255, 255, 255)
		}
	}

	function set_label(name, value=null) {
		this.name = name;
		this.value = value;

		draw();
	}

	function set_y(value) {
		this.surface.y = value; 
	}

	function hide() {
		this.surface.visible = false;
	}

	function show() {
		this.surface.visible = true;
	}

	function select() {
		this.is_selected = true;
		draw();
	}

	function deselect() {
		this.is_selected = false;
		draw();
	}
}
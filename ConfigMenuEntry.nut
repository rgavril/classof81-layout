class ConfigMenuEntry {
	title = "";
	value = "";
	options = [];

	surface = null;
	title_label = null;
	value_label = null;

	constructor(parent_surface, x, y) {
		this.surface = parent_surface.add_surface(1000, 1000);
		this.surface.set_pos(x, y);
		
		# Title
		this.title_label = this.surface.add_text(title, 0, 0, 600, 35);
		title_label.align = Align.MiddleLeft;

		# Value
		this.value_label = this.surface.add_text(value, 0, 0, 600, 35);
		value_label.align = Align.MiddleRight;
	}

	function set_title(text) {
		this.title_label.msg = text;
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
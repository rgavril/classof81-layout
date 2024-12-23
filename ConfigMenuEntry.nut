class ConfigMenuEntry {
	title = "No Title";
	value = "No Value";
	options = [];

	surface = null;
	title_label = null;
	value_label = null;

	constructor(parent_surface, x, y) {
		this.surface = fe.add_surface(1000, 1000);
		this.surface.set_pos(x, y);
		
		# Title
		this.title_label = this.surface.add_text(title, 0, 0, 600, 30);
		title_label.align = Align.MiddleLeft;

		# Value
		this.value_label = this.surface.add_text(value, 0, 0, 600, 30);
		value_label.align = Align.MiddleRight;
	}

	function set_title(text) {
		this.title_label.msg = text;
	}

	function set_value(text) {
		this.value_label.msg = text;
	}
}
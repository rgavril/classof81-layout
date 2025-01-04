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

	constructor(parent_surface, x, y)
	{
		this.surface = parent_surface.add_surface(1000, 100);
		this.surface.set_pos(x, y);
		
		# Background
		this.background_image = this.surface.add_image("images/config_menu_button.png", 0, 0);

		# Title
		this.name_label = this.surface.add_text (
			title,
			this.background_image.x,
			this.background_image.y,
			this.background_image.texture_width,
			this.background_image.texture_height
		);
		name_label.align = Align.MiddleLeft;
		name_label.char_size = 29;
		name_label.style = Style.Bold;
		name_label.set_rgb(255, 255, 255);

		# Value
		this.value_label = this.surface.add_text (
			value,
			this.background_image.x + this.background_image.texture_width / 2,
			this.background_image.y,
			this.background_image.texture_width/2 - 45,
			this.background_image.texture_height
		);
		value_label.align = Align.MiddleRight;
		value_label.char_size = 29;
		value_label.style = Style.Bold;
		value_label.set_rgb(255, 255, 255);
	}

	function draw() 
	{
		this.name_label.msg = name.toupper();
		this.name_label.align = Align.MiddleCentre;
		this.value_label.visible = false;

		# If there is a value to show
		if (this.value != null) {
			# Add a ":" to the end of the name and align it to the left
			this.name_label.msg += ":";
			this.name_label.align = Align.MiddleLeft;

			# Remove all the whitespaces from the value (some fbneo dipswitches have them)
			this.value_label.msg = str_replace("  ", " ", this.value);

			# If the value is to big to show on screen add some "..." at the end
			if (strip(this.value_label.msg) != strip(this.value_label.msg_wrapped)) {
				this.value_label.msg = strip(this.value_label.msg_wrapped).slice(0, -3) + "...";
			}

			# Display the value label
			this.value_label.visible = true;
		}

		if (this.is_selected) {
			this.background_image.file_name = "images/config_menu_button_selected.png"
			if (::popup_menu && ::popup_menu.is_active) {
				this.name_label.set_rgb(255, 255, 255)
				this.value_label.set_rgb(255, 255, 255)
			} else {
				this.name_label.set_rgb(100, 71, 145)
				this.value_label.set_rgb(100, 71, 145)
			}
		} else {
			this.background_image.file_name = "images/config_menu_button.png"
			this.name_label.set_rgb(255, 255, 255)
			this.value_label.set_rgb(255, 255, 255)
		}
	}

	function set_label(name, value=null)
	{
		this.name = name;
		this.value = value;

		draw();
	}

	function set_y(value)
	{
		this.surface.y = value; 
	}

	function hide()
	{
		this.surface.visible = false;
	}

	function show()
	{
		this.surface.visible = true;
	}

	function select()
	{
		this.is_selected = true;
		draw();
	}

	function deselect()
	{
		this.is_selected = false;
		draw();
	}
}
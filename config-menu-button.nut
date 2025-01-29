class ConfigMenuButton {
	surface = null
	name_label = null
	value_label = null
	background_image = null

	name = ""
	value = ""

	is_selected = false

	constructor(parent_surface, x, y)
	{
		# Drawing Sufrace
		this.surface = parent_surface.add_surface(1000, 100)
		this.surface.set_pos(x, y)
		
		# Background
		this.background_image = this.surface.add_image(fix_path("images/config_menu_button.png"), 0, 0)

		# Title Label
		this.name_label = this.surface.add_text("", 0, 0, 0, 0)

		this.name_label.x         = this.background_image.x + 25
		this.name_label.y         = this.background_image.y
		this.name_label.width     = this.background_image.texture_width - 25*2
		this.name_label.height    = this.background_image.texture_height
		this.name_label.align     = Align.MiddleLeft
		this.name_label.char_size = 29
		this.name_label.style     = Style.Bold
		this.name_label.set_rgb(255, 255, 255)

		# Value Label
		this.value_label = this.surface.add_text("", 0, 0, 0, 0)

		this.value_label.y         = this.background_image.y
		this.value_label.x         = this.background_image.x + this.background_image.texture_width / 2
		this.value_label.width     = this.background_image.texture_width/2 - 45
		this.value_label.height    = this.background_image.texture_height
		this.value_label.align     = Align.MiddleRight
		this.value_label.char_size = 29
		this.value_label.style     = Style.Bold
		this.value_label.set_rgb(255, 255, 255)
	}

	function draw() 
	{
		# By default align name label on center and hide value label
		this.name_label.msg   = name.toupper()
		this.name_label.align = Align.MiddleCentre

		this.value_label.visible = false

		# If the options has a value to display
		if (this.value != null) {
			# Add ":" to the end of the name and align it to the left
			this.name_label.msg  += ":"
			this.name_label.align = Align.MiddleLeft

			# Remove all the whitespaces from the value (some fbneo dipswitches have them)
			this.value_label.msg = str_replace("  ", " ", this.value)

			# If the value is to big to show on screen add some "..." at the end
			if (strip(this.value_label.msg) != strip(this.value_label.msg_wrapped)) {
				this.value_label.msg = strip(this.value_label.msg_wrapped).slice(0, -3) + "..."
			}

			# Display the value label
			this.value_label.visible = true

			# Dynamic label width
			this.value_label.x     = this.name_label.x + this.name_label.msg_width - 10
			this.value_label.width = this.background_image.texture_width - this.name_label.msg_width - 55 

		}

		if (this.is_selected) {
			this.background_image.file_name = fix_path("images/config_menu_button_selected.png")
			if (::popup_menu && ::popup_menu.is_visible()) {
				this.name_label.set_rgb(255, 255, 255)
				this.value_label.set_rgb(255, 255, 255)
			} else {
				this.name_label.set_rgb(100, 71, 145)
				this.value_label.set_rgb(100, 71, 145)
			}
		} else {
			this.background_image.file_name = fix_path("images/config_menu_button.png")
			this.name_label.set_rgb(255, 255, 255)
			this.value_label.set_rgb(255, 255, 255)
		}
	}

	function set_value(value)
	{
		this.value = value;
	}

	function set_label(name, value=null)
	{
		this.name = name
	}

	function set_y(value)
	{
		this.surface.y = value 
	}

	function hide()
	{
		this.surface.visible = false
	}

	function show()
	{
		this.surface.visible = true
	}

	function select()
	{
		this.is_selected = true
	}

	function deselect()
	{
		this.is_selected = false
	}
}
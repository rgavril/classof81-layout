class ConfigMenuButton {
	surface = null
	name_label = null
	value_label = null
	value_scroller = null
	background = null

	name = ""
	value = ""

	is_selected = false

	constructor(parent_surface, x, y)
	{
		# Drawing Sufrace
		this.surface = parent_surface.add_surface(1000, 100)
		this.surface.set_pos(x, y)
		
		# Background
		this.background = this.surface.add_rectangle(0, 0, 755, 50)
		this.background.outline = -3;
		this.background.set_rgb(183, 156, 198);
		this.background.set_outline_rgb(255,255,255);

		# Title Label
		this.name_label = this.surface.add_text("", 0, 0, 0, 0)

		this.name_label.x         = this.background.x + 25
		this.name_label.y         = this.background.y
		this.name_label.width     = this.background.width - 25*2
		this.name_label.height    = this.background.height
		this.name_label.align     = Align.MiddleLeft
		this.name_label.char_size = 29
		this.name_label.style     = Style.Bold
		this.name_label.set_rgb(255, 255, 255)

		# Value Label
		this.value_label = this.surface.add_text("", 0, 0, 0, 0)

		this.value_label.y         = this.background.y
		this.value_label.x         = this.background.x + this.background.width / 2
		this.value_label.width     = this.background.width/2 - 45
		this.value_label.height    = this.background.height
		this.value_label.align     = Align.MiddleRight
		this.value_label.char_size = 29
		this.value_label.style     = Style.Bold
		this.value_label.set_rgb(255, 255, 255)

		this.value_scroller = TextScroller(this.value_label, "")
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

			# Dynamic label width
			this.value_label.x     = this.name_label.x + this.name_label.msg_width + 10
			this.value_label.width = this.background.width - this.name_label.msg_width - 55

			# Display the value label
			this.value_label.visible = true

			# Update the value label text
			this.value_scroller.set_text(str_replace("  ", " ", this.value))
		}

		if (this.is_selected) {
			this.background.set_rgb(106, 148, 228);

			this.value_scroller.activate()

			if (::popup_menu && ::popup_menu.is_visible()) {
				this.name_label.set_rgb(255, 255, 255)
				this.value_label.set_rgb(255, 255, 255)
			} else {
				this.name_label.set_rgb(100, 71, 145)
				this.value_label.set_rgb(100, 71, 145)
			}
		} else {
			this.background.set_rgb(183, 156, 198);

			this.value_scroller.desactivate()

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
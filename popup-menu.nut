
class PopupMenu
{
	MAX_OPTIONS = 19          # The maximum number of options a popup can show
	message = ""              # String containg the message
	options = []              # Array of strings with all the options
	selected_idx = 0          # Integer representing the selected option

	surface = null             # fe.Surface that everything is drawn on
	background_top = null      # fe.Image for the top part of the background
	background_bottom = null   # fe.Image for the bottom part of the background
	buttons = []               # Array of fe.Image / fe.Text elements representing the buttons
	message_label = null       # fe.Text that displays the message

	is_active = false          # Boolean that is true when the popup is visible 

	function constructor()
	{
		# Drawing Surface
		this.surface = fe.add_surface(1000, 1280)
		this.surface.visible = false
		this.surface.set_pos(0, 0)

		# Background
		this.background_top    = this.surface.add_image("images/popup_menu.png", 0, 0)
		this.background_bottom = this.surface.add_clone(this.background_top)

		# Message
		this.message_label = this.surface.add_text("", 0, 0, 0, 0)
		this.message_label.x         = this.background_top.texture_width/2 - 250
		this.message_label.y         = 80
		this.message_label.width     = 500
		this.message_label.height    = 200
		this.message_label.font      = "fonts/CriqueGrotesk-Bold.ttf"
		this.message_label.char_size = 26
		this.message_label.word_wrap = true
		this.message_label.align     = Align.TopCentre
		this.message_label.set_rgb(0xff, 0xff, 0xff)

		# Option Buttons
		for ( local idx=0; idx<this.MAX_OPTIONS; idx++ ) {
			local button = {
				"image"    : this.surface.add_image("images/popup_option.png"),
				"text"     : this.surface.add_text("", 0, 0, 0, 0),
				"scroller" : null
			}

			# Option Button Image
			button.image.x         = 260
			button.image.y         = 160 + 50*idx
			button.image.visible   = false

			# Option Button Text
			button.text.x         = button.image.x
			button.text.y         = button.image.y + button.image.texture_height/2
			button.text.width     = button.image.texture_width
			button.text.height    = button.image.height
			button.text.char_size = 26
			button.text.font      = "fonts/CriqueGrotesk-Bold.ttf"
			button.text.align     = Align.MiddleLeft
			button.text.margin    = 30
			button.text.visible   = false

			button.scroller = TextScroller(button.text, "");

			this.buttons.push(button)
		}
	}

	function key_detect(signal_str)
	{
		if ( ! this.is_active ) { return false }
		
		switch (signal_str)
		{
			case "down"   : this._key_down_action()   ; break;
			case "up"     : this._key_up_action()     ; break;
			case "select" : this._key_select_action() ; break;	
		}

		return true
	}

	function _key_down_action()
	{
		# If we're at the last option, nothing is done
		if ( this.selected_idx + 1 == this.options.len() ) {
			return
		}

		# Play a sound
		::sound_engine.play_click_sound()
		
		# Select next option
		this.selected_idx += 1
		
		# Redraw
		this.draw()
	}

	function _key_up_action()
	{
		# If we're at the first option, nothing is done
		if ( this.selected_idx == 0 ) {
			return
		}

		# Play a sound
		::sound_engine.play_click_sound()

		# Select previous option
		this.selected_idx -= 1

		# Redraw
		this.draw()
	}

	function _key_select_action()
	{
		# Play a sound
		::sound_engine.play_enter_sound()

		# Hide the popup
		this.hide()

		# Issue a signal so whoever called us gets notified
		fe.signal("custom1")
	}

	function draw()
	{
		# Update message
		this.message_label.msg = this.message

		# First hide all buttons
		foreach(button in this.buttons) {
			button.image.visible = false
			button.text.visible = false
		}

		# Update and show buttons that have options associated
		foreach( idx, option in this.options ) {
			local button = this.buttons[idx]

			# Make button visible
			button.text.visible = true
			button.image.visible = true
			
			# Set the text for the button
			button.scroller.set_text(option)

			# Set different image and text color is option is selected
			if ( this.selected_idx == idx ) {
				button.text.set_rgb(100, 71, 145)
				button.scroller.activate()
				button.image.file_name = "images/popup_option_selected.png"
			} else {
				button.text.set_rgb(255, 255, 255)
				button.scroller.desactivate()
				button.image.file_name = "images/popup_option.png"
			}
		}

		# Hide the unused top background image
		local visible_height = this.options.len() * 50 + 170
		this.background_top.subimg_height = visible_height
		
		# Move the bottom background image in place
		this.background_bottom.subimg_y = this.background_bottom.texture_height - 75
		this.background_bottom.y = visible_height

		# Set surface origin so that is centered when we do animations
		this.surface.origin_y = ( visible_height + 75 - 1280)/2
	}

	function set_message(message)
	{
		this.message = message
	}

	function set_options(options)
	{
		this.options = options

		# If we need to display more options than we can
		if ( options.len() >= this.MAX_OPTIONS ) {

			# Write a warning when when there are more options than we can show.
			print("WARNING: Popup cannot display more that "+this.MAX_OPTIONS+" options. List was truncated")

			# Truncate the options list
			this.options = options.slice(0, this.MAX_OPTIONS)
		}
	}

	function set_selected_idx(select_idx)
	{
		# Ensure the selected idx is in the list
		if ( select_idx >= this.MAX_OPTIONS ) {
			select_idx = 0
		}

		this.selected_idx = select_idx
	}

	function get_selected_idx()
	{
		return this.selected_idx
	}

	function get_selected_value()
	{
		return this.options[this.selected_idx]
	}

	function show()
	{
		# Play a sound
		::sound_engine.play_enter_sound()

		# Set the active flag to true
		this.is_active = true

		# Redraw
		this.draw()

		# Start the show up animation
		local startY = (this.options.len() * 50 + 170) / 2
        animation.add(PropertyAnimation(this.surface, {property = "y", start=startY, time = 150, tween = Tween.Quart}))
        animation.add(PropertyAnimation(this.surface, {property = "height", start=0, time = 150, center={x=0,y=500}, tween = Tween.Quart}))
        animation.add(PropertyAnimation(this.surface, {property = "alpha", start=0, end=255, time = 150, tween = Tween.Quart}))

        # Make sure the surface is visible
		this.surface.visible = true
	}

	function hide()
	{
		# Set the active flag to false
		this.is_active = false

		# Start the fadeout animation
        animation.add(PropertyAnimation(this.surface,{property = "alpha", start=255, end=0, time = 200, tween = Tween.Quart}))
	}

	function is_visible()
	{
		return this.is_active;
	}
}
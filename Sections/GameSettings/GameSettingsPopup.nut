
class GameSettingsPopup
{
	MAX_OPTIONS = 19          # The maximum number of options a popup can show
	message = ""              # String containg the message
	options = []              # Array of strings with all the options
	selected_idx = 0          # Integer representing the selected option

	surface = null             # fe.Surface that everything is drawn on
	background = null
	background_shadow = null
	buttons = []               # Array of fe.Image / fe.Text elements representing the buttons
	message_label = null       # fe.Text that displays the message

	is_active = false          # Boolean that is true when the popup is visible 

	function constructor()
	{
		# Drawing Surface
		this.surface = fe.add_surface(1000, 1280)
		this.surface.visible = false
		this.surface.set_pos(0, 0)

		# Background Shadow
		this.background_shadow = this.surface.add_rectangle(0, 0, 1000, 1280)
		this.background_shadow.set_rgb(0, 0, 0)

        local glow_shader = fe.add_shader(Shader.Fragment, "shaders/glow_shadow.fsh")
        glow_shader.set_param("resolution", fe.layout.width, fe.layout.height)
        glow_shader.set_param("rect", 230.0, 60.0, 500.0, 100.0)
        glow_shader.set_param("radius", 20.0)
        glow_shader.set_param("glow_size", 40.0)
        glow_shader.set_param("glow_color", 186.0 / 255.0, 253.0 / 255.0, 244.0 / 255.0)
		glow_shader.set_param("intensity", 0.5)
        this.background_shadow.shader = glow_shader

		# Background
		this.background = this.surface.add_rectangle(245, 75, 470, 800)
		this.background.outline = 15;
		this.background.corner_radius = 5;
		this.background.set_rgb(74,84,86);
		this.background.set_outline_rgb(194,139,240);

		# Message
		this.message_label = this.surface.add_text("", 0, 0, 0, 0)
		this.message_label.x         = this.background.width/2
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
				"background" : this.surface.add_rectangle(0, 0, 440, 35),
				"text"       : this.surface.add_text("", 0, 0, 0, 0),
				"scroller"   : null
			}

			# Option Button Image
			button.background.x             = 260
			button.background.y             = 160 + 50*idx
			button.background.outline       = -3;
			button.background.corner_radius = 5;
			button.background.visible       = false
			button.background.set_rgb(183, 156, 198);
			button.background.set_outline_rgb(255,255,255);


			# Option Button Text
			button.text.x         = button.background.x
			button.text.y         = button.background.y + button.background.height/2
			button.text.width     = button.background.width
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
			button.background.visible = false
			button.text.visible = false
		}

		# Update and show buttons that have options associated
		foreach( idx, option in this.options ) {
			local button = this.buttons[idx]

			# Make button visible
			button.text.visible = true
			button.background.visible = true
			
			# Set the text for the button
			button.scroller.set_text(option)

			# Set different background and text color is option is selected
			if ( this.selected_idx == idx ) {
				button.text.set_rgb(100, 71, 145)
				button.background.set_rgb(106, 148, 228);
				button.scroller.activate()
			} else {
				button.text.set_rgb(255, 255, 255)
				button.background.set_rgb(183, 156, 198);
				button.scroller.desactivate()
			}
		}

		# Resize the background
		local visible_height = this.options.len() * 50 + 170
		
		this.background.height = visible_height - 75
		this.surface.origin_y = ( visible_height + 75 - 1280)/2
		this.background_shadow.shader.set_param("rect", 230.0, 60.0, 500.0, background.height + 30)
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
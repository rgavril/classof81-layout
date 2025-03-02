class GameButton {
	surface = null;
	background_image = null;
	game_select_box = null;
	logo = null;
	logo_shadow = null;
	gear_icon = null;
	game_name = null;

	m_desaturize_shader = null;
	m_shadow_shader = null;
	m_empty_shader = null;

	is_selected = false;
	is_active = true;
	is_gear_selected = false;

	constructor(x=0, y=0)
	{
		# Create surface for drawing onto and position it
		this.surface = fe.add_surface(500, 300);
		this.surface.set_pos(x, y);
		this.surface.origin_y = this.surface.texture_height/2;

		# Draw the button background image on the surface
		this.background_image = this.surface.add_image("images/button_background_inactive.png");
		this.background_image.y = this.surface.texture_height / 2;

		# Create the the selection rectangle
		this.game_select_box = this.surface.add_image("images/game_select_box_active.png", 0, 0);
		this.game_select_box.y = this.surface.texture_height / 2;
		this.game_select_box.origin_x = this.game_select_box.texture_width;
		this.game_select_box.x = this.background_image.texture_width + this.background_image.x;
		this.game_select_box.visible = false;

		# Game Logo
		this.logo_shadow = this.surface.add_image(null);
		this.logo = this.surface.add_image(null);

		# Gear Icon
		this.gear_icon = this.surface.add_image("images/gear.png", 0, 0, 95, 95);
		this.gear_icon.origin_y = 40;
		this.gear_icon.origin_x = 0;
		this.gear_icon.y = this.background_image.y;
		this.gear_icon.x = 7;

		# Game Name
		this.game_name = this.surface.add_text("[Title]", 90, 135, 315, 105);
		this.game_name.align = Align.MiddleCentre;
		this.game_name.font = "fonts/compactablkbt_black.ttf";
		this.game_name.char_size = 48;
		this.game_name.char_spacing = 0.8;
		this.game_name.set_rgb(100, 120, 150);

		# Shader used to desaturade the unselected logo on buttons
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_shadow_shader = fe.add_shader(Shader.Fragment, "shaders/shadow.glsl");
		m_empty_shader = fe.add_shader(Shader.Empty);

		# Draw
		draw();
	}

	function key_detect(signal_str)
	{
		if (!this.is_active) {
			return false;
		}

		if (signal_str == "left" && !this.is_gear_selected) {
			::sound_engine.play_click_sound();
			this.select_gear();
			return true;
		}

		if (signal_str == "right" && this.is_gear_selected) {
			::sound_engine.play_click_sound();
			this.deselect_gear();
			return true;
		}

		if (signal_str == "select" && this.is_gear_selected) {
			::config_menu.show();
			return true;
		}

		if (signal_str == "select" && !this.is_gear_selected) {
			this.is_active = false;
			::startup_page.show();
			return true;
		}

		return false;
	}

	function setTitle(name) {
		this.game_name.msg = name;
	}

	function setLogo(filename, resize=true)
	{
		if (! fe.path_test(filename, PathTest.IsFile)) {
			this.game_name.visible = true;
		} else {
			this.game_name.visible = false;
		}

		this.logo.file_name = filename

		local logo_width = 0;
		local logo_height = 0;
		if (resize) {
			# Calculate the size of the logo based on max 260 horizontal / 130 vertical
			logo_width = 260;
			logo_height = 260.0/this.logo.texture_width * this.logo.texture_height;
			if (logo_height > 130) {
				logo_height = 130;
				logo_width = 130.0/this.logo.texture_height * this.logo.texture_width;
			}
		} else {
			logo_width = this.logo.texture_width;
			logo_height = this.logo.texture_height;
		}

		# Resize the logo
		this.logo.mipmap = true;
		this.logo.width  = logo_width;
		this.logo.height = logo_height;

		# Put the logo in front of shadow
		this.logo.zorder = 2;
		
		# Set the origin point to the center-right of the logo
		this.logo.origin_y = logo_height / 2;
		this.logo.origin_x = logo_width / 2;

		# Position the logo on center of select box from the button
		this.logo.x = this.background_image.x + this.background_image.texture_width - 145;
		this.logo.y = this.background_image.y + this.background_image.texture_height/2;

		# Update the logo shadow
		this.logo_shadow.file_name = filename;
		this.logo_shadow.width     = logo_width;
		this.logo_shadow.height    = logo_height;
		this.logo_shadow.origin_y  = this.logo_shadow.height/2 - 2;
		this.logo_shadow.origin_x  = this.logo_shadow.width/2 - 2;
		this.logo_shadow.x         = this.logo.x;
		this.logo_shadow.y         = this.logo.y;
		this.logo_shadow.alpha     = 1;
		this.logo_shadow.zorder    = 1;
		this.logo_shadow.shader    = m_shadow_shader;
	}

	function draw()
	{
		this.logo.shader = this.is_selected ? m_empty_shader : m_desaturize_shader;

		if (this.is_selected) {
			this.game_name.set_rgb(0, 0, 0);
		} else {
			this.game_name.set_rgb(100, 120, 150);
		}

		# Gear Icon
		if ( this.is_selected && this.is_gear_selected ) {
			this.gear_icon.file_name = "images/gear_active.png"
		} else {
			this.gear_icon.file_name = "images/gear_inactive.png"
		}

		# Button Background
		if ( this.is_selected && this.is_gear_selected ) {
			this.background_image.file_name = "images/button_background_active.png"
		} else {
			this.background_image.file_name = "images/button_background_inactive.png"
		}

		# Game Select Box Logic
		if ( this.is_selected && this.is_active && !this.is_gear_selected ) {
			this.game_select_box.file_name = "images/game_select_box_active.png"
			this.game_select_box.visible   = true;

		} else if ( this.is_selected && !this.is_active && !this.is_gear_selected ) {
			this.game_select_box.file_name = "images/game_select_box_inactive.png"
			this.game_select_box.visible   = true;

		} else if ( this.is_selected && this.is_active && this.is_gear_selected ) {
			this.game_select_box.file_name = "images/game_select_box_inactive.png"
			this.game_select_box.visible   = true;
		} else {
			this.game_select_box.visible   = false;
		}

		# Bottom Text
		if ( this.is_active ) {
			if ( this.is_gear_selected ) {
				::bottom_text.set("Press any button access settings for [Title]. Move right to select [Title] or a different game.");
			} else {
				::bottom_text.set("Press any button to start [Title]. Move up or down to select a different game. Move left to change game settings for [Title]. Move righ to access Online Features.");
			}
		}
	}

	function select()
	{
		this.is_selected = true;
		draw();
	}

	function deselect()
	{
		this.is_selected = false;
		this.is_gear_selected = false;
		draw();
	}

	function hide()
	{
		this.surface.visible = false;
	}

	function show()
	{
		this.surface.visible = true;
	}

	function activate()
	{
		this.is_active = true;
		draw();
	}

	function desactivate()
	{
		this.is_active = false;
		draw();
	}

	function select_gear()
	{
		this.is_gear_selected = true;
		draw();
	}

	function deselect_gear()
	{
		this.is_gear_selected = false;
		draw();
	}
}
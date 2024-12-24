class GameButton {
	m_surface = null;
	m_background = null;
	game_select_box = null;
	m_logo = null;
	m_logo_shadow = null;	
	gear_icon = null;
	connection_bar = null;

	m_desaturize_shader = null;
	m_shadow_shader = null;
	m_empty_shader = null;

	is_selected = false;
	is_active = true;
	is_config_mode = false;

	constructor(x=0, y=0) {
		debug()

		# Create surface for drawing onto and position it
		m_surface = fe.add_surface(500, 300);
		m_surface.set_pos(x, y);
		m_surface.origin_y = m_surface.texture_height/2;

		# Draw the button background image on the surface
		m_background = m_surface.add_image("images/button_background_inactive.png");
		m_background.y = m_surface.texture_height / 2;

		# Connection Bar
		this.connection_bar = m_surface.add_image("images/connection_bar_active.png", 0, 0);
		this.connection_bar.origin_x = this.connection_bar.texture_width;
		this.connection_bar.origin_y = this.connection_bar.texture_height / 2;
		this.connection_bar.x = 441;
		this.connection_bar.y = m_background.y + m_background.texture_height / 2;
		this.connection_bar.zorder = -1;
		this.connection_bar.visible = false;

		# Create the the selection rectangle
		this.game_select_box = m_surface.add_image("images/game_select_box_active.png", 0, 0);
		this.game_select_box.y = m_surface.texture_height / 2;
		this.game_select_box.origin_x = this.game_select_box.texture_width;
		this.game_select_box.x = m_background.texture_width + m_background.x;
		this.game_select_box.visible = false;

		# Game Logo
		m_logo_shadow = m_surface.add_image(null);
		m_logo = m_surface.add_image(null);

		# Gear Icon
		this.gear_icon = m_surface.add_image("images/gear.png", 0, 0, 85, 85);
		this.gear_icon.origin_y = 30;
		this.gear_icon.origin_x = 30;
		this.gear_icon.y = m_background.y;
		this.gear_icon.x = 43;

		# Shader used to desaturade the unselected logo on buttons
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_shadow_shader = fe.add_shader(Shader.Fragment, "shaders/shadow.glsl");
		m_empty_shader = fe.add_shader(Shader.Empty);

		# Draw
		draw();
	}

	function setLogo(filename) {
		debug()

		m_logo.file_name = filename

		# Resize the logo
		m_logo.preserve_aspect_ratio = true;
		m_logo.mipmap = true;
		m_logo.width = 260;
		m_logo.zorder = 2;

		# Set the origin point to the center-right of the logo
		m_logo.origin_y = (m_logo.texture_height * (m_logo.width / m_logo.texture_width)) / 2;
		m_logo.origin_x = m_logo.width;

		# Align it horizontaly near the end of the button background
		m_logo.x = m_background.x + m_background.texture_width - 17;
		
		# Align it verticaly to the middle of the button background image
		m_logo.y = m_background.y + m_background.texture_height/2;



		m_logo_shadow.file_name = filename;
		m_logo_shadow.preserve_aspect_ratio = true;
		m_logo_shadow.width = m_logo.width;
		m_logo_shadow.origin_y = m_logo.origin_y - 2;
		m_logo_shadow.origin_x = m_logo.origin_x - 2;
		m_logo_shadow.x = m_logo.x;
		m_logo_shadow.y = m_logo.y;
		m_logo_shadow.shader = m_shadow_shader;
		m_logo_shadow.zorder = 1;

		draw();
	}

	function draw() {
		debug()

		m_logo.shader = this.is_selected ? m_empty_shader : m_desaturize_shader;
		m_logo_shadow.alpha = this.is_selected ? 200 : 100;


		# Connection Bar Logic
		if (this.is_selected && this.is_active) {
			this.connection_bar.visible = true;
			this.connection_bar.file_name = "images/connection_bar_active.png";
		} else if (this.is_selected && !this.is_active) {
			this.connection_bar.visible = true;
			this.connection_bar.file_name = "images/connection_bar_inactive.png";
		} else {
			this.connection_bar.visible = false;
		}

		# Gear Icon Logic
		if (this.is_selected && this.is_config_mode) {
			this.gear_icon.file_name = "images/gear_active.png";
		} else {
			this.gear_icon.file_name = "images/gear_inactive.png";
		}

		# Button Background Logic
		if (this.is_selected && this.is_config_mode) {
			m_background.file_name = "images/button_background_active.png";
		} else {
			m_background.file_name = "images/button_background_inactive.png";
		}

		# Select Box Game Logic
		if (this.is_selected && this.is_active && !this.is_config_mode) {
			this.game_select_box.file_name = "images/game_select_box_active.png"
			this.game_select_box.visible = true;

		} else if (this.is_selected && !this.is_active && !this.is_config_mode) {
			this.game_select_box.file_name = "images/game_select_box_inactive.png"
			this.game_select_box.visible = true;

		} else if (this.is_selected && this.is_active && this.is_config_mode) {
			this.game_select_box.file_name = "images/game_select_box_inactive.png"
			this.game_select_box.visible = true;
		} else {
			this.game_select_box.visible = false;
		}
	}

	function select() {
		debug()

		this.is_selected = true;
		draw();
	}

	function deselect() {
		debug()

		this.is_selected = false;
		draw();

	}

	function hide() {
		debug()

		m_surface.visible = false;
	}

	function show() {
		debug()

		m_surface.visible = true;
	}

	function activate() {
		debug()

		this.is_active = true;
		draw();
	}

	function desactivate() {
		debug()

		this.is_active = false;
		draw();
	}

	function set_config_mode(is_config_mode) {
		debug();

		this.is_config_mode = is_config_mode;
		draw();
	}
}
class GameButton {
	m_x = 0;
	m_y = 0;
	m_surface = null;
	m_background = null;
	m_selection_box_a = null;
	m_selection_box_i = null;
	m_logo = null;
	m_logo_shadow = null;
	m_desaturize_shader = null;
	m_shadow_shader = null;
	m_empty_shader = null;
	m_icon = null;
	m_pointer_a = null;
	m_pointer_i = null;

	is_selected = false;
	is_active = true;

	constructor(x=0, y=0) {
		debug()

		# Create surface for drawing onto and position it
		m_surface = fe.add_surface(500, 300);
		m_surface.set_pos(x, y);
		m_surface.origin_y = m_surface.texture_height/2;

		# Draw the button background image on the surface
		m_background = m_surface.add_image("images/button_background.png");
		m_background.y = m_surface.texture_height / 2;

		# Pointer
		m_pointer_a = m_surface.add_image("images/pointer_active.png", 0, 0);
		m_pointer_a.origin_x = m_pointer_a.texture_width;
		m_pointer_a.origin_y = m_pointer_a.texture_height / 2;
		m_pointer_a.x = 441;
		m_pointer_a.y = m_background.y + m_background.texture_height / 2;
		m_pointer_a.zorder = -1;

		m_pointer_i = m_surface.add_image("images/pointer.png", 0, 0);
		m_pointer_i.origin_x = m_pointer_i.texture_width;
		m_pointer_i.origin_y = m_pointer_i.texture_height / 2;
		m_pointer_i.x = 441;
		m_pointer_i.y = m_background.y + m_background.texture_height / 2;
		m_pointer_i.zorder = -1;


		# Create the the selection rectangle
		m_selection_box_a = m_surface.add_image("images/button_selection.png", 0, 0);
		m_selection_box_a.y = m_surface.texture_height / 2;
		m_selection_box_a.origin_x = m_selection_box_a.texture_width;
		m_selection_box_a.x = m_background.texture_width + m_background.x;
		m_selection_box_a.visible = false;

		m_selection_box_i = m_surface.add_image("images/button_selection_inactive.png", 0, 0);
		m_selection_box_i.y = m_surface.texture_height / 2;
		m_selection_box_i.origin_x = m_selection_box_i.texture_width;
		m_selection_box_i.x = m_background.texture_width + m_background.x;
		m_selection_box_i.visible = false;

		# Game Logo
		m_logo_shadow = m_surface.add_image(null);
		m_logo = m_surface.add_image(null);

		# Gear Icon
		m_icon = m_surface.add_image("images/gear.png", 0, 0, 85, 85);
		m_icon.origin_y = 30;
		m_icon.origin_x = 30;
		m_icon.y = m_background.y;
		m_icon.x = 43;

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

		m_pointer_a.visible = (this.is_selected && !this.is_active) ? true : false;
		m_pointer_i.visible = (this.is_selected && this.is_active) ? true : false;

		m_selection_box_a.visible = (this.is_selected && this.is_active) ? true : false;
		m_selection_box_i.visible = (this.is_selected && !this.is_active) ? true : false;
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
}
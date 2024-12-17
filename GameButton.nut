class GameButton {
	m_x = 0;
	m_y = 0;
	m_surface = null;
	m_background = null;
	m_selection_box = null;
	m_logo = null;
	m_logo_shadow = null;
	m_desaturize_shader = null;
	m_shadow_shader = null;
	m_icon = null;
	m_pointer = null;

	constructor(x=0, y=0)
	{
		# Set Coordonates
		m_x = x; m_y = y;

		# Create surface for drawing onto and position it
		m_surface = fe.add_surface(500, 300);
		m_surface.set_pos(m_x, m_y);
		m_surface.origin_y = m_surface.texture_height/2;

		# Draw the button background image on the surface
		m_background = m_surface.add_image("images/button_background.png");
		m_background.y = m_surface.texture_height / 2;

		# Pointer
		m_pointer = m_surface.add_image("images/pointer.png", 0, 0);
		m_pointer.origin_x = m_pointer.texture_width;
		m_pointer.origin_y = m_pointer.texture_height / 2;
		m_pointer.x = 443;
		m_pointer.y = m_background.y + m_background.texture_height / 2;
		m_pointer.zorder = -1;

		# Create the the selection rectangle
		m_selection_box = m_surface.add_image("images/button_selection.png",0,0);
		m_selection_box.y = m_surface.texture_height / 2;
		m_selection_box.origin_x = m_selection_box.texture_width;
		m_selection_box.x = m_background.texture_width + m_background.x;

		# Game Logo
		m_logo_shadow = m_surface.add_image(null);
		m_logo = m_surface.add_image(null);

		# Gear Icon
		m_icon = m_surface.add_image("images/gear.png", 0, 0, 90, 90);
		m_icon.origin_y = 30;
		m_icon.origin_x = 30;
		m_icon.y = m_background.y;
		m_icon.x = 43;

		# Shader used to desaturade the unselected logo on buttons
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_shadow_shader = fe.add_shader(Shader.Fragment, "shaders/shadow.glsl");

		# Draw it deselected
		deselect();
	}

	function setLogo(filename)
	{	
		m_logo.swap(m_surface.add_image(filename,-1000, -1000))

		# Resize the logo
		m_logo.preserve_aspect_ratio = true;
		m_logo.mipmap = true;
		m_logo.width = 260;

		# Set the origin point to the center-right of the logo
		m_logo.origin_y = (m_logo.texture_height * (m_logo.width / m_logo.texture_width)) / 2;
		m_logo.origin_x = m_logo.width;

		# Align it horizontaly near the end of the button background
		m_logo.x = m_background.x + m_background.texture_width - 15;
		# Align it verticaly to the middle of the button background image
		m_logo.y = m_background.y + m_background.texture_height/2;


		m_logo_shadow.swap(m_surface.add_image(filename,-1000, -1000))
		m_logo_shadow.preserve_aspect_ratio = true;
		m_logo_shadow.width = m_logo.width;
		m_logo_shadow.origin_y = m_logo.origin_y - 2;
		m_logo_shadow.origin_x = m_logo.origin_x - 2;
		m_logo_shadow.x = m_logo.x;
		m_logo_shadow.y = m_logo.y;
		m_logo_shadow.shader = m_shadow_shader;
	}

	function select()
	{
		# Remove Desaturate Shader
		m_logo.shader = fe.add_shader(Shader.Empty)
		m_logo.alpha = 255;

		# Show Pointer
		m_pointer.alpha = 255;

		# Show selection rectangle
		m_selection_box.alpha = 255;

		m_logo_shadow.alpha = 200;
	}

	function deselect()
	{
		# Desaturize
		m_logo.shader = m_desaturize_shader;

		# Hide Pointer
		m_pointer.alpha = 0;

		# Hide selection rectangel
		m_selection_box.alpha = 0;

		m_logo_shadow.alpha = 100;
	}

	function hide()
	{
		m_surface.alpha = 0;
	}

	function show()
	{
		m_surface.alpha = 255;
	}
}
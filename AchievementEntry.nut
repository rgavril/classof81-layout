class AchievementEntry {
	m_x = 0
	m_y = 0
	m_info = null

	m_badge = null;
	m_surface = null;
	m_title = null;
	m_description = null;
	m_desaturize_shader = null;

	constructor(x, y) {
		m_x = x;
		m_y = y;

		m_surface = fe.add_surface(460, 350);
		m_surface.set_pos(m_x, m_y);

		m_badge = m_surface.add_image(null);

		m_description = m_surface.add_text("", 67, -9, 365, 85);
		m_description.char_size = 20;
		m_description.align = Align.TopLeft;
		m_description.word_wrap = true;

		m_title = m_surface.add_text("", 67, -9, 365, 85);
		m_title.char_size = 20;
		m_title.align = Align.TopLeft;
		m_title.word_wrap = true;
		m_title.set_rgb(255,252,103);

		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
	}

	function show(info) {
		m_info = info;

		update_badge();
		updateText();

		m_surface.visible = true;
	}

	function hide() {
		m_surface.visible = false;
	}

	function update_badge() {
		local filename = fe.script_dir + "/achievements/images/" + m_info.BadgeName + ".png";
		m_badge.swap(m_surface.add_image(filename,-1000, -1000))
	}

	function updateText() {
		m_title.msg = m_info.Title;
		m_description.msg = m_info.Title + " : " + m_info.Description;
	}

	function enable() {
		m_badge.shader = fe.add_shader(Shader.Empty);
	}

	function disable() {
		m_badge.shader = m_desaturize_shader;
	}
}
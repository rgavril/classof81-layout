class AchievementEntry {
	m_x = 0
	m_y = 0
	m_info = null

	m_badge = null;
	m_surface = null;
	m_title = null;
	m_description = null;

	constructor(x, y, info) {
		m_info = info;
		m_x = x;
		m_y = y;

		m_surface = fe.add_surface(460, 350);
		m_surface.set_pos(m_x, m_y);

		m_badge = m_surface.add_image("images/achievements/"+info.BadgeName+".png", 0, 0);
		m_badge.shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		// m_badge.alpha = 100;

		m_title = m_surface.add_text(info.Title, 65, -10, 365, 32);
		m_title.char_size = 24;
		m_title.align = Align.TopLeft;
		m_title.word_wrap = true;
		// m_title.style = Style.Bold;
		m_title.set_rgb(255,252,103);

		m_description = m_surface.add_text(info.Description, 65+2, 24-7, 365, 100);
		m_description.char_size = 18;
		m_description.align = Align.TopLeft;
		m_description.word_wrap = true;
		// m_description.line_spacing = 0.75;
	}
}
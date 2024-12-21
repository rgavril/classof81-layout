class AchievementEntry {
	m_x = 0
	m_y = 0
	m_info = null

	m_badge = null;
	m_surface = null;
	m_title = null;
	m_description = null;
	m_selection_box = null;
	m_desaturize_shader = null;
	m_empty_shader = null;

	constructor(x, y) {
		debug("AchievementEntry");

		# Coordinates where we start drawing
		m_x = x; m_y = y;

		# Surface that we draw on
		m_surface = fe.add_surface(460, 350);
		m_surface.set_pos(m_x, m_y);

		# Achivement selection box
		m_selection_box = m_surface.add_image("images/achievement_selected.png", 0, 0);
		m_selection_box.visible = false;
		m_selection_box.alpha = 200;

		# Achievemnt badge image
		m_badge = m_surface.add_image(null, 15, 5);

		# Location of description and title text
		local text_x = 67 + 10;
		local text_y = 5-6;

		# Description of the achievement
		m_description = m_surface.add_text("", text_x, text_y, 370, 85);
		m_description.char_size = 26;
		m_description.char_spacing = 0.8;
		m_description.align = Align.TopLeft;
		m_description.word_wrap = true;

		# Title of the achievement
		m_title = m_surface.add_text("", text_x, text_y, 370, 85);
		m_title.char_size = 26;
		m_title.char_spacing = 0.8;
		m_title.align = Align.TopLeft;
		m_title.word_wrap = false;
		m_title.set_rgb(255,252,103);

		# Shader used for desaturating badge icon
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_empty_shader = fe.add_shader(Shader.Empty);
	}

	function load(info) {
		debug("AchievementEntry");

		m_info = info;
		draw();
		m_surface.visible = true;
	}

	function hide() {
		debug("AchievementEntry");

		m_surface.visible = false;
	}

	function draw() {
		debug("AchievementEntry");

		# Load the badge
		local filename = fe.script_dir + "/achievements/images/" + m_info.BadgeName + ".png";


		m_badge.visible = false; m_badge = null
		m_badge = m_surface.add_image(filename, 15, 5);

		m_badge.shader = m_desaturize_shader;

		# Update the title and description
		m_title.msg = m_info.Title;
		m_description.msg = "\n" + m_info.Description;
	}

	function select() {
		debug("AchievementEntry");

		m_selection_box.visible = true;
	}

	function deselect() {
		debug("AchievementEntry");
		
		m_selection_box.visible = false;
	}
}
class AchievementEntry {
	achievement = null

	surface = null;
	badge_icon = null;
	title_label = null;
	description_label = null;
	selection_box = null;

	m_desaturize_shader = null;
	m_empty_shader = null;

	constructor(x, y)
	{
		# Surface that we draw on
		this.surface = fe.add_surface(460, 350);
		this.surface.set_pos(x, y);

		# Achivement selection box
		this.selection_box = this.surface.add_image("images/achievement_selected.png", 0, 0);
		this.selection_box.visible = false;
		this.selection_box.alpha = 200;

		# Achievemnt badge image
		this.badge_icon = this.surface.add_image(null, 15, 5);

		# Location of description and title text
		local text_x = 67 + 10;
		local text_y = 5-6;

		# Description of the achievement
		this.description_label = this.surface.add_text("", text_x, text_y, 370, 85);
		this.description_label.char_size = 26;
		this.description_label.align = Align.TopLeft;
		this.description_label.word_wrap = true;

		# Title of the achievement
		this.title_label = this.surface.add_text("", text_x, text_y, 370, 85);
		this.title_label.char_size = 26;
		this.title_label.align = Align.TopLeft;
		this.title_label.word_wrap = false;
		this.title_label.set_rgb(255,252,103);

		# Shader used for desaturating badge icon
		m_desaturize_shader = fe.add_shader(Shader.Fragment, "shaders/desaturate.glsl");
		m_empty_shader = fe.add_shader(Shader.Empty);
	}

	function set_achivement(achievement)
	{

		this.achievement = achievement;
		draw();
		this.surface.visible = true;
	}

	function hide()
	{
		this.surface.visible = false;
	}

	function draw()
	{
		# Load the badge
		local filename = fe.script_dir + "/achievements/images/" + this.achievement.BadgeName + ".png";

		this.badge_icon.file_name = filename;
		this.badge_icon.shader = m_desaturize_shader;

		# Update the title and description
		this.title_label.msg = this.achievement.Title;
		this.description_label.msg = "\n" + this.achievement.Description;
	}

	function select()
	{
		this.selection_box.visible = true;
	}

	function deselect()
	{	
		this.selection_box.visible = false;
	}
}
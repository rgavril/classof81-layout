class AchievementEntry {
	achievement = null

	surface = null;
	badge_icon = null;
	title_label = null;
	description_label = null;
	selection_box = null;
	is_selected = false;

	description_scroller = null;
	title_scroller = null;

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
		this.badge_icon.height=55;
		this.badge_icon.width=55;


		# Location of description and title text
		local text_x = 85;
		local text_y = 13;

		# Title of the achievement
		this.title_label = this.surface.add_text("", text_x, text_y, 340, 85);
		this.title_label.char_size = 24;
		this.title_label.align = Align.TopLeft;
		// this.title_label.word_wrap = true;
		this.title_label.margin = 0;
		// this.title_label.font = "fonts/CriqueGrotesk-Bold.ttf"
		this.title_label.set_rgb(255,252,103);

		# Description of the achievement
		this.description_label = this.surface.add_text("", text_x, text_y + 25 , 340, 40);
		this.description_label.char_size = 18;
		this.description_label.align = Align.TopLeft;
		// this.description_label.word_wrap = true;
		this.description_label.margin = 0;


		this.description_scroller = TextScroller(this.description_label, "");
		this.title_scroller = TextScroller(this.title_label, "");


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
		if ("DateEarned" in achievement) {
			this.badge_icon.shader = m_empty_shader;
		} else {
			this.badge_icon.shader = m_desaturize_shader;
		}

		# Update the title and description
		// this.title_label.msg = this.achievement.Title;
		// this.description_label.msg = this.achievement.Description;
		
		this.description_scroller.set_text(this.achievement.Description)
		this.title_scroller.set_text(this.achievement.Title)

		if (this.is_selected) {
			this.selection_box.visible = true;
			this.description_scroller.activate();
			this.title_scroller.activate();
		} else {
			this.selection_box.visible = false;
			this.description_scroller.desactivate();
			this.title_scroller.desactivate();
		}
	}

	function select()
	{
		this.is_selected = true;
		this.draw()
	}

	function deselect()
	{	
		this.is_selected = false;
		this.draw()
	}
}
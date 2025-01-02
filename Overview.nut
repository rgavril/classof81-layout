class Overview
{
	surface = null;

	constructor()
	{
		this.surface = fe.add_surface(450, 840)
		this.surface.set_pos(475, 235)

		// print(format("Width: %d height: %d\n", snap.width, snap.height));

		# Shadow
		local shadow = this.surface.add_text("[Overview]", 0+2, 100+2, this.surface.width, 600);
		shadow.align = Align.TopLeft;
		shadow.char_size = 26;
		shadow.word_wrap = true;
		shadow.margin = 20;
		shadow.set_rgb(0, 0, 0);

		# Overview
		local overview = this.surface.add_text(shadow.msg, 0, 100, this.surface.width, 600);
		overview.align = Align.TopLeft;
		overview.char_size = 26;
		overview.word_wrap = true;
		overview.margin = 20;
		overview.set_rgb(255, 252, 103);
	}	
}
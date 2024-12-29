class BottomText {
	text_obj = "";

	constructor()
	{
		this.text_obj = fe.add_text("" ,20, 1100, 800, 160);
		this.text_obj.char_size = 26;
		this.text_obj.align = Align.BottomLeft;
		this.text_obj.word_wrap = true;
		this.text_obj.set_rgb(77, 105, 192);

		# Add a callback to refresh the list when events take place
		fe.add_transition_callback(this, "transition_callback");
	}

	function set(text)
	{
		if (this.text_obj.msg != text) {
			this.text_obj.msg = text;
			this.pulse();
		}
	}

	function pulse()
	{
		local pulse_animation = {
			property = "color", 
			start = { red = 255, green = 255, blue = 255 }, 
			end = { red = 77, green = 105, blue = 192 },
			time = 1000,
			tween = Tween.Quart
		}
		animation.add(PropertyAnimation(this.text_obj,  pulse_animation));
	}

	function transition_callback(ttype, var, transition_time)
	{
		if (ttype == Transition.FromOldSelection) {
			this.pulse();
		}
	}
}
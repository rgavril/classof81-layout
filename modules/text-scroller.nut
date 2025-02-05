class TextScroller {
	text = "";
	container = null;
	is_active = false;

	last_scroll_text = "";
	last_scroll_tick = 0;
	last_scroll_idx = 0;

	constructor(container, text) {
		this.container = container;
		this.text = text;

		fe.add_ticks_callback(this, "_scroll")
	}

	function set_text(text) {
		if (this.text != text) {
			this.text = text;
			this._reset()
		}
	}

	function _reset()
	{
		this.last_scroll_text = "";
		this.last_scroll_tick = 0;
		this.last_scroll_idx = 0;

		this.container.msg = this.text;

		# If the text doesn't fit add '...' at the end
		if ( strip(this.container.msg) != strip(this.container.msg_wrapped) ) {
			this.container.msg = strip(this.container.msg_wrapped).slice(0, -3) + "..."
		}
	}

	function _scroll(tick_time)
	{
		# Don't do any scrolling if popup is not visible
		if ( ! this.is_active ) { return  }

		# Calculate the wait time till the next scroll
		local wait_tick_time = 100
		if (last_scroll_idx == 0) {
			wait_tick_time = 500
		}

		# If not enough time passed, skip this scroll
		if ( tick_time < last_scroll_tick + wait_tick_time ) {
			return
		# Else update last scroll time
		} else {
			last_scroll_tick = tick_time
		}

		# Get a hold of the container and the text we need to scroll
		local container   = this.container
		local scroll_text = this.text

		# Don't scroll if text fits the container
		container.msg = scroll_text
		if ( strip(container.msg) == strip(container.msg_wrapped) ) {
			return
		}

		# If the scrollable text changed, reset scroll index
		if ( last_scroll_text != scroll_text ) {
			last_scroll_idx = 0
			last_scroll_text = scroll_text
		# Else increase the scroll index
		} else {
			last_scroll_idx++
		}

		# If scroll index is at the end, reset it
		local scroll_space = "      "
		if ( last_scroll_idx > scroll_text.len() + scroll_space.len() ) {
			last_scroll_idx = 0
		}

		# Duplicate the scroll text so it will look as it repeats
		scroll_text = scroll_text + scroll_space + scroll_text 
		container.msg = scroll_text.slice(last_scroll_idx)
	}

	function activate() {
		this.is_active = true;
	}

	function desactivate() {
		this.is_active = false;
		this._reset()
	}
}
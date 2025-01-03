function min(a,b) 
{
	return a < b ? a : b;
}

function max(a,b) 
{
	return a > b ? a : b;
}

function str_replace(search, replace, subject)
{
	if (subject == null) return null;

	local text = subject;

	local position = text.find(search);

	while (position != null) {
		local slice1 = text.slice(0, position);
		local slice2 = text.slice(position + search.len());

		text = slice1 + replace + slice2;

		position = text.find(search);
	}

	return text;
}

function TitleFormatedx() {
	local title = fe.game_info( Info.Title );
	return split(title, "(")[0];
}
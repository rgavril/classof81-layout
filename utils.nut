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
	if (subject == null)  return null;

	local value = "";
	foreach (position, segment in split(subject, search))  {
		if (position != 0) {
			value += replace;
		}
		value += segment;
	}
	return value;
}
function min(a,b) {
	return a < b ? a : b;
}

function max(a,b) {
	return a > b ? a : b;
}

function debug(msg = "") {
	local func = getstackinfos(2).func;
	local src  = getstackinfos(2).src;
	local line = getstackinfos(2).line
	local locals = getstackinfos(2).locals

	local variables = "";
	// foreach (var, value in locals) {
	// 	variables += var + " = " + value + " | ";
	// }

	print("DEBUG: "+ func +" " + variables +"  @ "+ src + ":"+ line +" \n")
}
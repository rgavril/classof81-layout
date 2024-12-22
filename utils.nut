function min(a,b) {
	return a < b ? a : b;
}

function max(a,b) {
	return a > b ? a : b;
}

function debug(msg = "") {
	return;
	local func = getstackinfos(2).func;
	local src  = getstackinfos(2).src;
	local line = getstackinfos(2).line
	local locals = getstackinfos(2).locals
	local time = clock();

	// local variables = fe.obj.len();
	// foreach (key,val in fe.obj) {
	// 	print(key + " = " + val + "\n");
	// }
	// print("*** " + fe.image_cache.count() +"\n");

	print("DEBUG: "+time+" "+ func +" @ "+ src + ":"+ line +" \n")
}
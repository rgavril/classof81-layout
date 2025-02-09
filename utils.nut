
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

function ini_section(filename, section)
{
	local file = ReadTextFile("/", filename);
	local map = {};
	
	local section_found = false;
	while(!file.eos()) {
		local line = file.read_line();

		if (line == "["+section+"]") {
			section_found = true;
			continue;
		}

		if (! section_found) {
			continue;
		}

		if (line.len()>0 && line.slice(0, 1) == "[") {
			break;
		}

		local parts = split(line, "=");
		if (parts.len() == 2) {
			local key = strip(parts[0]);
			local value = strip(parts[1]);
			value = str_replace("\"", "", value);

			map[key] <- value;
		}
	}

	// file.close();
	return map;
}

function load_json(filename) {
	local jsonFile = file(filename, "r");
	local nutFile = file(filename+".nut", "w+");

	# Write 'return ' at the begining of file
	local text = "return ";
	for(local i=0; i<text.len(); i++) {
		nutFile.writen(text[i], 'b');
	}

	# Use blobs for parsing the file contents as
	# reading and writing files byte by byte is slow
	local jsonBlob = jsonFile.readblob(jsonFile.len());
	local nutBlob = blob(jsonFile.len());

	# Read from jsonBlob and weite to nutBlob
	while (! jsonBlob.eos()) {
		# Read a byte from json
		local byte = jsonBlob.readn('b');

		
		if (byte == '\\') {
			local nextByte = jsonBlob.readn('b');

			# Look for '\/'' and replace them with '/'
			if (nextByte == '/') {
				nutBlob.writen('/', 'b');

			# Look for '\u and replace them with '\\u'
			} else if (nextByte == 'u') {
				nutBlob.writen(byte, 'b');
				nutBlob.writen(byte, 'b');
				nutBlob.writen(nextByte, 'b');

			} else {
				nutBlob.writen(byte, 'b');
				nutBlob.writen(nextByte, 'b');
			}

			continue;
		}

		# Write the byte into the nut
		nutBlob.writen(byte, 'b');
	}

	# Write the actual nut file
	nutFile.writeblob(nutBlob);
	
	# Close the files, we don't need them anymore
	jsonFile.close();
	nutFile.close();

	# The actual parsing is done like this, m
	local data = dofile(filename+".nut", true);

	# Delete the nut file, we don't need it anymore
	remove(filename+".nut");

	# Return the data
	return data;
}

# For md5
function LROT(x, c) {
    return ((x << c) | (x >> (32 - c))) & 0xFFFFFFFF;
}

# For md5
function bytesToIntLE(b, offset) {
    return ((b[offset] & 0xFF) | ((b[offset + 1] & 0xFF) << 8) |
            ((b[offset + 2] & 0xFF) << 16) | ((b[offset + 3] & 0xFF) << 24)) & 0xFFFFFFFF;
}

# For md5
function intToBytesLE(x) {
    return [x & 0xFF, (x >> 8) & 0xFF, (x >> 16) & 0xFF, (x >> 24) & 0xFF];
}

function md5(input) {
    local S = [
        7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,  7, 12, 17, 22,
        5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,  5,  9, 14, 20,
        4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,  4, 11, 16, 23,
        6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21,  6, 10, 15, 21
    ];

    local K = [];
    for (local i = 0; i < 64; i++) {
        K.append(((fabs(sin(i + 1)) * 4294967296).tointeger()) & 0xFFFFFFFF);
    }

    local msg = [];
    foreach (c in input) msg.append(c.tointeger() & 0xFF);

    local origLen = msg.len() * 8;
    msg.append(0x80);
    while ((msg.len() % 64) != 56) msg.append(0);

    foreach (b in intToBytesLE(origLen)) msg.append(b);
    foreach (b in intToBytesLE(origLen >> 32)) msg.append(b);

    local a = 0x67452301;
    local b = 0xEFCDAB89;
    local c = 0x98BADCFE;
    local d = 0x10325476;

    for (local i = 0; i < msg.len(); i += 64) {
        local M = [];
        for (local j = 0; j < 16; j++) {
            M.append(bytesToIntLE(msg, i + j * 4));
        }

        local A = a, B = b, C = c, D = d;

        for (local j = 0; j < 64; j++) {
            local F, g;
            if (j < 16) {
                F = (B & C) | (~B & D);
                g = j;
            } else if (j < 32) {
                F = (D & B) | (~D & C);
                g = (5 * j + 1) % 16;
            } else if (j < 48) {
                F = B ^ C ^ D;
                g = (3 * j + 5) % 16;
            } else {
                F = C ^ (B | ~D);
                g = (7 * j) % 16;
            }

            F = (F + A + K[j] + M[g]) & 0xFFFFFFFF;
            A = D;
            D = C;
            C = B;
            B = (B + LROT(F, S[j])) & 0xFFFFFFFF;
        }

        a = (a + A) & 0xFFFFFFFF;
        b = (b + B) & 0xFFFFFFFF;
        c = (c + C) & 0xFFFFFFFF;
        d = (d + D) & 0xFFFFFFFF;
    }

    local result = "";
    foreach (x in [a, b, c, d]) {
        foreach (b in intToBytesLE(x)) {
            result += format("%02x", b);
        }
    }

    return result;
}

// Recursive function to print tables with tabs for indentation
function print_table(t, indent = 0) {
    local tab = "    "  // Define a tab space (4 spaces)
    local indentation = ""
    
    // Build the indentation string
    for (local i = 0; i < indent; i++) {
        indentation += tab
    }

    if (t == null) {
    	print(indentation + "(null)");
    	return;
    }

    foreach (key, value in t) {
        if (typeof(value) == "table" || typeof(value) == "array") {
            print(indentation + key + ": {\n")
            print_table(value, indent + 1)  // Recursively print nested table with increased indentation
            print(indentation + "}\n")
        } else {
            print(indentation + key + ": " + value + "\n")  // Print the key-value pair with the indentation
        }
    }
}
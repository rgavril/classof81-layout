// Function to read the contents of a file and return it as a string
function read_file(filePath) {
    local file = file(filePath, "r"); // Open the file in read mode
    
    if (file != null) {
        local contents = "";
        
        while (! file.eos()) {
            local char = file.readn('c')
            contents += format("%c", char);
            // print ( format("%c", char) );
        }

        file.close();
        return contents;
    } else {
        throw "Failed to open the file: " + filePath; // Handle file open error
    }
}

function short_overview()
{
    local sumary = "";
    
    try {
        local filename = format("%s/modules/overview/%s.txt",fe.script_dir, fe.game_info(Info.Name));
        sumary = read_file(filename);
    } catch (e) {
        sumary = "";
    }
    
    return sumary;

    local overview = fe.game_info(Info.Overview);
    local chunks = split(overview, "."); 
    local skip_newline = true;
    foreach (chunk in chunks) {
        if (skip_newline) {
            skip_newline = false;
        } else {
            sumary += "\n\n";
        }

        sumary += strip(chunk)+". ";

        if (chunk.len() >= 2 && chunk.slice(-2) == "Mr")  { skip_newline = true; }
        if (chunk.len() >= 2 && chunk.slice(-2) == "Ms")  { skip_newline = true; }
        if (chunk.len() >= 2 && chunk.slice(-2) == "Dr")  { skip_newline = true; }

        if (sumary.len() > 328) {
            break;
        }
    }

    return sumary;
}
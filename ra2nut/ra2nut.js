import fs from 'fs';

class Squirrel {
    filename = "achivements.nut";
    content = "";

    constructor() {

    }

    add_line(string) {
        this.content = this.content + "\n" + string;
    }

    log() {
        console.log(this.content);
    }

    save() {
        try {
            fs.writeFileSync(this.filename, this.content);
        } catch (err) {
            console.log(err);
        }
    }
}

var data = "";
try {
    data = fs.readFileSync('./retro.json', 'utf8');
    data = data.replace(/\\\//g, '/');
    console.log('File content:', data);  // The content of the file as a string
} catch (err) {
    console.error('Error reading file:', err);
}
// import ra from "./retro.json" with { type: "json" };

var squirrel = new Squirrel();

squirrel.add_line('local achivements = ' + data);
squirrel.add_line('return achivements');
// squirrel.log();
squirrel.save();

// console.log(ra);

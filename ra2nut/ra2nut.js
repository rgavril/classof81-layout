import fs from 'fs';

class Squirrel {
    filename = "achievements.nut";
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

const jsonData = fs.readFileSync('./mspacman.json', 'utf8');
const raData = JSON.parse(jsonData);
const achievements = raData.Achievements;
for (const key in achievements) {
    const badgeName = achievements[key].BadgeName;
    console.log(`wget https://media.retroachievements.org/Badge/${badgeName}.png`);
}

var data = "";
try {
    data = fs.readFileSync('./mspacman.json', 'utf8');
    data = data.replace(/\\\//g, '/');
} catch (err) {
    console.error('Error reading file:', err);
}

var squirrel = new Squirrel();

squirrel.add_line('local achievements = ' + data);
squirrel.add_line('return achievements');
// squirrel.log();
squirrel.save();

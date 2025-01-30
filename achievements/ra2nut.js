const fs = require('fs');
const https = require('https');
const crypto = require('crypto');
const config = require('./config.json'); 

function saveJson2Nut(json, filename) {
    console.log(`* Saving JSON to Squirrel [ ${filename} ]`)
    var content = ''

    content += "local achievements =\n";
    content += JSON.stringify(json, null, 2) + "\n";
    content += "return achievements\n";

    try {
        fs.writeFileSync(filename, content);
    } catch (err) {
        console.error('Error writing to file', err);
    }
}

function downloadUrl(url, filename) {
    console.log(`* Downloading URL [ ${url} -> ${filename} ]`);
    https.get(url, (response) => {
        const file = fs.createWriteStream(filename);
        response.pipe(file);

        file.on('finish', () => {
            file.close();
        });
    }).on('error', (err) => {
        console.error('Error downloading the image:', err);
    })
}

// Downloads badge images for achievements and saves them to the specified folder.
function downloadBadges(json, folder) {
    console.log(`* Downloading Badges [ ${folder} ]`)
    const achievements = json.Achievements;

    for (const key in achievements) {
        const badgeName = achievements[key].BadgeName;
        const url = `https://media.retroachievements.org/Badge/${badgeName}.png`;
        const filename = `${folder}/${badgeName}.png`;

        downloadUrl(url, filename);
    }
}

// Fetches a JSON from a URL and return it directly using async/await
async function fetchJson(url) {
  console.log(`* Fetching JSON [ ${url} ]`);
  try {
    return new Promise((resolve) => {
      https.get(url, (res) => {
        let data = '';

        // A chunk of data has been received
        res.on('data', (chunk) => {
          data += chunk;
        });

        // The whole response has been received
        res.on('end', () => {
          try {
            const jsonData = JSON.parse(data);  // Parse the JSON string into a JavaScript object
            resolve(jsonData);  // Resolve the Promise with the JSON data
          } catch (error) {
            resolve({});  // Return an empty JSON if there's an error parsing the JSON
          }
        });
      }).on('error', (error) => {
        resolve({});  // Return an empty JSON if there's an error with the HTTP request
      });
    });
  } catch (error) {
    return {};  // Return empty JSON if an unexpected error occurs
  }
}

async function gameIdOfRom(rom) {
    console.log(`* Detecting Retroachivements game id [ ${rom} ]`);

    const hashValue = crypto.createHash('md5').update(rom, 'utf8').digest('hex');

    const url = `https://retroachievements.org/API/API_GetGameList.php?y=${config.key}&i=27&h=1`;
    const jsonData = await fetchJson(url);
    for (const game of jsonData) {
        if (game.Hashes.includes(hashValue)) {
            return game.ID;  // Return the ID if the hash matches
        }
    }
    
    return null;  // Return null if no match is found
}

(async() => {
    const rom = process.argv[2];
    const gameId = await gameIdOfRom(rom)
    const url = `https://retroachievements.org/API/API_GetGameInfoAndUserProgress.php?g=${gameId}&u=${config.user}&y=${config.key}&z=${config.user}`;
    const jsonData = await fetchJson(url);
    saveJson2Nut(jsonData, `./nuts/${rom}.nut`);
    downloadBadges(jsonData, './images');
})();

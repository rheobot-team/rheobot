
const webCapture = require('webpage-capture');
var URL = require('url-parse');
var Slack = require('@slack/client')
const fs = require('fs')

module.exports = function (robot) {
    var webclient = robot.Slack;
    if(!webclient) {
        webclient = new Slack.WebClient(process.env.HUBOT_SLACK_TOKEN);
    }
    
    robot.respond(/web-screen/i, msg => {
        var commands = msg.message.text.split(" ");
        var url = commands[2]
        if(!url || url.length < 1) {
            msg.send("Usage: hubot web-screen <website>")
        }
        else {
            webCapture([url], { }, (err, res) => {
                if(!err) {
                    console.log('Output saved to:', res);
                    webclient.files.upload({ file: fs.createReadStream(res[0]) })
                    .then((fileUploadRes) => {
                        console.log('File uploaded: ', fileUploadRes.file.id);
                        fs.unlinkSync(res[0])
                        msg.send(fileUploadRes.file.permalink);
                    })
                    .catch(console.error);
                }
                else {
                    console.log(err);
                    msg.send("Problem taking screenshot!")
                }
            });
        }
    })
  }
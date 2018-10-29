# Description
#   Checks arbitrarily defined endpoints for their health
#
# Commands:
#   hubot check status of <url> - performs a GET request against the URL and returns status code
#
# Author:
#   Spencer Thomas

module.exports = (robot) ->
  robot.respond /check status of (.+)/, (msg) ->
    url = msg.match[1]

    robot
      .http(url)
      .get() (err, res, body) ->
        if err
          msg.send "Encountered an error with #{url}: #{err}"
        else
          statusCode = parseInt(res.statusCode)
          if statusCode >= 200 and statusCode <= 399
            msg.send "Looks up, returned #{statusCode}"
          else
            msg.send "Looks up, but gave a bad status code: #{statusCode}"

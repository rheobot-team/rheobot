# Description
#   A hubot script that gets the current release version of Gradle
#
# Commands:
#   hubot gradle version - gets the current release version of Gradle
#
# Author:
#   Jonatan Ivanov <jonatan.ivanov@gmail.com>

module.exports = (robot) ->
  robot.respond /.*[Gg]radle version.*/, (response) ->
    robot.http('https://services.gradle.org/versions/current').get() (err, res, body) ->
      if err
        response.reply "Encountered an error:\n#{err}"
      else
        statusCode = parseInt(res.statusCode)
        if statusCode >= 200 and statusCode < 300
          response.reply JSON.parse(body).version
        else
          response.reply "Encountered an error, HTTP #{statusCode}:\n#{body}"

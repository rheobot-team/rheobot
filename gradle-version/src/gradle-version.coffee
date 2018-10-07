# Description
#   A hubot script that gets the current release version of Gradle
#
# Commands:
#   hubot gradle version - gets the current release version of Gradle
#
# Author:
#   Jonatan Ivanov <jonatan.ivanov@gmail.com>

module.exports = (robot) ->
  robot.respond /.*[Gg]radle version.*/, (res) ->
    res.reply "10.1.42"

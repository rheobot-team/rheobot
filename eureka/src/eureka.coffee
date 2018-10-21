# Description
#   A hubot script to interact with Eureka
#
# Configuration:
#   HUBOT_EUREKA_BASE_URL - Eureka base URL, e.g.: http://localhost::8761/eureka
#
# Commands:
#   hubot eureka apps - lists the registered applications
#   hubot eureka apps AppB - lists the instance IDs of AppB
#   hubot eureka instances InstanceId001 - gives details about instances with InstanceId001
#
# Author:
#   Jonatan Ivanov <jonatan.ivanov@gmail.com>

module.exports = (robot) ->

  robot.respond /.*eureka apps$/, (res) ->
    res.reply "apps"

  robot.respond /.*eureka apps ([^ ]+)$/, (res) ->
    res.reply "apps with appId"

  robot.respond /.*eureka instances (.+)$/, (res) ->
    res.reply "instances"

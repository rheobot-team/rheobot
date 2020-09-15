# Description
#   A hubot script to interact with Eureka
#
# Configuration:
#   HUBOT_EUREKA_BASE_URL - Eureka base URL, e.g.: http://localhost:8761/eureka
#
# Commands:
#   hubot eureka apps - lists the registered applications
#   hubot eureka apps AppB - lists the instance IDs of AppB
#   hubot eureka instances InstanceId001 - gives details about instances with InstanceId001
#
# Author:
#   Jonatan Ivanov <jonatan.ivanov@gmail.com>

EUREKA_BASE_URL = process.env.HUBOT_EUREKA_BASE_URL
unless EUREKA_BASE_URL?
  console.log "Missing HUBOT_EUREKA_BASE_URL in environment: please set and try again"
  process.exit(1)

module.exports = (robot) ->
  robot.respond /.*eureka apps$/, (robotRS) ->
    url = "#{EUREKA_BASE_URL}/apps"
    handleMsg(robot, robotRS, url, getApps)

  robot.respond /.*eureka apps ([^ ]+)$/, (robotRS) ->
    url = "#{EUREKA_BASE_URL}/apps/#{robotRS.match[1]}"
    handleMsg(robot, robotRS, url, getInstances)

  robot.respond /.*eureka instances (.+)$/, (robotRS) ->
    url = "#{EUREKA_BASE_URL}/instances/#{robotRS.match[1]}"
    handleMsg(robot, robotRS, url, getInstance)

handleMsg = (robot, robotRS, url, replyCallback) ->
  robot.http(url).header('Accept', 'application/json').get() (err, httpRS, body) ->
    if err
      robotRS.reply "Encountered an error:\n#{err}"
    else
      statusCode = parseInt(httpRS.statusCode)
      if statusCode >= 200 and statusCode < 300
        robotRS.reply replyCallback(robotRS, body)
      else
        robotRS.reply "Encountered an error, HTTP #{statusCode}:\n#{url}\n#{body}"

getApps = (robotRS, body) ->
  '\n' + JSON.parse(body).applications.application.map((app) -> app.name).join('\n')

getInstances = (robotRS, body) ->
  '\n' + JSON.parse(body).application.instance.map((instance) -> instance.instanceId).join('\n')

getInstance = (robotRS, body) ->
  JSON.stringify(JSON.parse(body), null, 2)

# Description
#   A hubot script that searches in maven central repository
#
# Commands:
#   hubot maven <search term> - searches in maven central repo and replies with the result
#
# Author:
#   Jonatan Ivanov <jonatan.ivanov@gmail.com>

module.exports = (robot) ->
  robot.respond /maven (.+)/, (response) ->
    searchTerm = response.match[1]
    response.reply "Search term: #{searchTerm}"

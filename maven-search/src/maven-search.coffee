# Description
#   A hubot script that searches in maven central repository
#
# Commands:
#   hubot maven <search term> - searches in maven central repo and replies with the result
#
# Author:
#   Jonatan Ivanov <jonatan.ivanov@gmail.com>

SOLR_BASE_URL = 'https://search.maven.org/solrsearch'

module.exports = (robot) ->
  # matches search terms which contain one colon, e.g.: junit:junit
  robot.respond /maven (.+):(.+)$/, (response) ->
    url = "#{SOLR_BASE_URL}/select?q=g:#{response.match[1]}+AND+a:#{response.match[2]}&rows=10"
    getResultsAndReply(robot, response, url)

  # matches search terms which do not contain colons, e.g.: junit
  robot.respond /maven ([^:]+)$/, (response) ->
    url = "#{SOLR_BASE_URL}/select?q=#{response.match[1]}&rows=10"
    getResultsAndReply(robot, response, url)

getResultsAndReply = (robot, response, url) ->
  robot.http(url).get() (err, res, body) ->
    if err
      response.reply "Encountered an error:\n#{err}"
    else
      statusCode = parseInt(res.statusCode)
      if statusCode >= 200 and statusCode < 300
        response.reply(getFormattedResults(JSON.parse(body)))
      else
        response.reply "Encountered an error, HTTP #{statusCode}:\n#{body}"

getFormattedResults = (solr) ->
  return "\n#{getResults(solr).join('\n')}"

getResults = (solr) ->
  return solr.response.docs.map((doc) -> getResult(doc))

getResult = (doc) ->
  return "#{doc.id}:#{doc.latestVersion}"

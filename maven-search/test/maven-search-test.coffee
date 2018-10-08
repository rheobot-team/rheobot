Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require('nock')

expect = chai.expect

helper = new Helper('../src/maven-search.coffee')

solrResponse = {
  response: {
    docs: [
      {
        id: "junit:junit",
        latestVersion: "4.12"
      }
    ]
  }
}

describe 'maven-search', ->
  @room = null

  beforeEach ->
    @room = helper.createRoom()
    do nock.disableNetConnect

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks hubot for junit version and the bot receives a valid response', ->
    beforeEach (done) ->
      nock('https://search.maven.org')
        .get('/solrsearch/select?q=junit&rows=10')
        .reply(200, solrResponse)

      @room.user.say 'alice', '@hubot maven junit'
      setTimeout done, 100

    it 'should respond with the current junit version', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot maven junit' ]
        [ 'hubot', '@alice \njunit:junit:4.12' ]
      ]

  context 'user asks hubot for junit:junit version and the bot receives a valid response', ->
    beforeEach (done) ->
      nock('https://search.maven.org')
        .get('/solrsearch/select?q=g%3Ajunit%20AND%20a%3Ajunit&rows=10')
        .reply(200, solrResponse)

      @room.user.say 'alice', '@hubot maven junit:junit'
      setTimeout done, 100

    it 'should respond with the current junit:junit version', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot maven junit:junit' ]
        [ 'hubot', '@alice \njunit:junit:4.12' ]
      ]

  context 'user asks hubot for junit version but the bot fails to call search.maven.org', ->
    beforeEach (done) ->
      nock('https://search.maven.org')
        .get('/solrsearch/select?q=junit&rows=10')
        .replyWithError('something terrible happened')

      @room.user.say 'alice', '@hubot maven junit'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot maven junit' ]
        [ 'hubot', '@alice Encountered an error:\nError: something terrible happened' ]
      ]

  context 'user asks hubot for junit:junit version but the bot fails to call search.maven.org', ->
    beforeEach (done) ->
      nock('https://search.maven.org')
        .get('/solrsearch/select?q=g%3Ajunit%20AND%20a%3Ajunit&rows=10')
        .replyWithError('something terrible happened')

      @room.user.say 'alice', '@hubot maven junit:junit'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot maven junit:junit' ]
        [ 'hubot', '@alice Encountered an error:\nError: something terrible happened' ]
      ]

  context 'user asks hubot for junit version but the bot receives an error response', ->
    beforeEach (done) ->
      nock('https://search.maven.org')
        .get('/solrsearch/select?q=junit&rows=10')
        .reply('500', 'something awful happened')

      @room.user.say 'alice', '@hubot maven junit'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot maven junit' ]
        [ 'hubot', '@alice Encountered an error, HTTP 500:\nsomething awful happened' ]
      ]

  context 'user asks hubot for junit:junit version but the bot receives an error response', ->
    beforeEach (done) ->
      nock('https://search.maven.org')
        .get('/solrsearch/select?q=g%3Ajunit%20AND%20a%3Ajunit&rows=10')
        .reply('500', 'something awful happened')

      @room.user.say 'alice', '@hubot maven junit:junit'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot maven junit:junit' ]
        [ 'hubot', '@alice Encountered an error, HTTP 500:\nsomething awful happened' ]
      ]

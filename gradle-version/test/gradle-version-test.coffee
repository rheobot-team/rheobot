Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require('nock')

expect = chai.expect

helper = new Helper('../src/gradle-version.coffee')

describe 'gradle-version', ->
  @room = null

  beforeEach ->
    @room = helper.createRoom()
    do nock.disableNetConnect

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks hubot for gradle version and the bot receives a valid response', ->
    beforeEach (done) ->
      nock('https://services.gradle.org')
        .get('/versions/current')
        .reply 200, { version: '10.1.42' }

      @room.user.say 'alice', '@hubot gradle version'
      setTimeout done, 100

    it 'should respond with the current gradle version', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot gradle version' ]
        [ 'hubot', '@alice 10.1.42' ]
      ]

  context 'user asks hubot for gradle version but the bot fails to call services.gradle.org', ->
    beforeEach (done) ->
      nock('https://services.gradle.org')
        .get('/versions/current')
        .replyWithError('something terrible happened')

      @room.user.say 'alice', '@hubot gradle version'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot gradle version' ]
        [ 'hubot', '@alice Encountered an error:\nError: something terrible happened' ]
      ]

  context 'user asks hubot for gradle version but the bot receives an error response', ->
    beforeEach (done) ->
      nock('https://services.gradle.org')
        .get('/versions/current')
        .reply('500', 'something awful happened')

      @room.user.say 'alice', '@hubot gradle version'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot gradle version' ]
        [ 'hubot', '@alice Encountered an error, HTTP 500:\nsomething awful happened' ]
      ]

Helper = require('hubot-test-helper')
chai = require 'chai'
nock = require('nock')

expect = chai.expect

helper = new Helper('../src/eureka.coffee')

appsRS = {
  "applications": {
    "application": [
      { "name": "AppA" },
      { "name": "AppB" },
      { "name": "AppC" }
    ]
  }
}

appsWithAppNameRS = {
  "application": {
    "name": "AppB",
    "instance": [
      { "instanceId": "1c00cc262b59:AppB:8080" },
      { "instanceId": "309cec0977d1:AppB:8080" },
      { "instanceId": "7f28ebb57832:AppB:8080" }
    ]
  }
}

instancesRS = {
  "instance": {
    "instanceId": "1c00cc262b59:AppB:8080",
    "hostName": "AppB.example.com",
    "app": "AppB",
    "ipAddr": "10.10.10.10",
    "status": "UP",
    "port": {
      "$": 8080,
      "@enabled": "true"
    }
  }
}

describe 'eureka', ->
  @room = null

  beforeEach ->
    process.env.HUBOT_EUREKA_BASE_URL = 'http://eureka:8761/eureka'
    @room = helper.createRoom()
    do nock.disableNetConnect

  afterEach ->
    @room.destroy()
    nock.cleanAll()

  context 'user asks hubot for eureka apps and the bot receives a valid response', ->
    beforeEach (done) ->
      nock('http://eureka:8761')
        .get('/eureka/apps')
        .reply 200, appsRS

      @room.user.say 'alice', '@hubot eureka apps'
      setTimeout done, 100

    it 'should respond with the eureka apps', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot eureka apps' ]
        [ 'hubot', '@alice \nAppA\nAppB\nAppC' ]
      ]

  context 'user asks hubot for eureka apps with app name and the bot receives a valid response', ->
    beforeEach (done) ->
      nock('http://eureka:8761')
        .get('/eureka/apps/AppB')
        .reply 200, appsWithAppNameRS

      @room.user.say 'alice', '@hubot eureka apps AppB'
      setTimeout done, 100

    it 'should respond with the eureka apps', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot eureka apps AppB' ]
        [ 'hubot', '@alice \n1c00cc262b59:AppB:8080\n309cec0977d1:AppB:8080\n7f28ebb57832:AppB:8080' ]
      ]

  context 'user asks hubot for instances and the bot receives a valid response', ->
    beforeEach (done) ->
      nock('http://eureka:8761')
        .get('/eureka/instances/1c00cc262b59:AppB:8080')
        .reply 200, instancesRS

      @room.user.say 'alice', '@hubot eureka instances 1c00cc262b59:AppB:8080'
      setTimeout done, 100

    it 'should respond with the instances', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot eureka instances 1c00cc262b59:AppB:8080' ]
        [ 'hubot', "@alice #{JSON.stringify(instancesRS, null, 2)}" ]
      ]

  context 'user asks hubot for apps but the bot fails to call eureka', ->
    beforeEach (done) ->
      nock('http://eureka:8761')
        .get('/eureka/apps')
        .replyWithError('something terrible happened')

      @room.user.say 'alice', '@hubot eureka apps'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot eureka apps' ]
        [ 'hubot', '@alice Encountered an error:\nError: something terrible happened' ]
      ]

  context 'user asks hubot for apps but the bot receives an error response', ->
    beforeEach (done) ->
      nock('http://eureka:8761')
        .get('/eureka/apps')
        .reply('500', 'something awful happened')

      @room.user.say 'alice', '@hubot eureka apps'
      setTimeout done, 100

    it 'should respond with the error object', ->
      expect(@room.messages).to.eql [
        [ 'alice', '@hubot eureka apps' ]
        [ 'hubot', '@alice Encountered an error, HTTP 500:\nhttp://eureka:8761/eureka/apps\nsomething awful happened' ]
      ]

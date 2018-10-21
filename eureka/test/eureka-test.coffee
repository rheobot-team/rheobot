Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/eureka.coffee')

describe 'eureka', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to eureka apps', ->
    @room.user.say('alice', '@hubot eureka apps').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot eureka apps']
        ['hubot', '@alice apps']
      ]

  it 'responds to eureka apps AppB', ->
    @room.user.say('alice', '@hubot eureka apps AppB').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot eureka apps AppB']
        ['hubot', '@alice apps with appId']
      ]

  it 'responds to eureka apps', ->
    @room.user.say('alice', '@hubot eureka instances InstanceId001').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot eureka instances InstanceId001']
        ['hubot', '@alice instances']
      ]

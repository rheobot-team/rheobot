Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/gradle-version.coffee')

describe 'gradle-version', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to gradle version', ->
    @room.user.say('alice', '@hubot gradle version').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot gradle version']
        ['hubot', '@alice 10.1.42']
      ]

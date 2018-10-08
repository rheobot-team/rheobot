Helper = require('hubot-test-helper')
chai = require 'chai'

expect = chai.expect

helper = new Helper('../src/maven-search.coffee')

describe 'maven-search', ->
  beforeEach ->
    @room = helper.createRoom()

  afterEach ->
    @room.destroy()

  it 'responds to maven', ->
    @room.user.say('alice', '@hubot maven junit').then =>
      expect(@room.messages).to.eql [
        ['alice', '@hubot maven junit']
        ['hubot', '@alice Search term: junit']
      ]

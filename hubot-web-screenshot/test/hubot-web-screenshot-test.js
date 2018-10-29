
const path = require('path')
const chai = require('chai')
const Hubot = require('hubot')
const expect = chai.expect
const Robot = Hubot.Robot
const TextMessage = Hubot.TextMessage
const nock = require('nock')

const newTestRobot = function newTestRobot () {
  process.env.PORT = '0'
  const robot = new Robot(null, 'mock-adapter-v3', true, 'hubot')
  robot.Slack =  {
    files: {
      upload : function(param){
        return {
          then: function(callback) {
            callback({
              file: {
                id: 'testid',
                permalink: 'mytestlink'
              }
            })
            return {
              catch : function(callback) {}
            }
          }
        }
      }
    }
  };
  robot.loadFile(path.resolve('src/'), 'hubot-web-screenshot.js')
  robot.adapter.on('connected', () => robot.brain.userForId('1', {
    name: 'john',
    real_name: 'John Doe',
    room: '#test'
  }))

  return robot
}

describe('web-screenshot', () => describe('respond to screenshot commands', () => {
  beforeEach(function () {
    this.robot = newTestRobot()
    this.robot.run()
    this.user = this.robot.brain.userForName('john')
  })

  afterEach(function () {
    this.robot.shutdown()
  })

  context('when asked without a url', () => it('prompts for help', function (done) {
    this.robot.adapter.on('send', function (envelope, strings) {
      expect(strings.length).to.eql(1)
      expect(strings[0]).to.eql("Usage: hubot web-screen <website>")

      return done()
    })

    return this.robot.adapter.receive(new TextMessage(this.user, 'hubot web-screen'))
  }))


  context('when asked with a no auth url', () => it('sends a screenshot', function (done) {
    this.robot.adapter.on('send', function (envelope, strings) {
      expect(strings.length).to.eql(1)
      expect(strings[0]).to.eql('mytestlink')
      return done()
    })
    nock("http://myfakesite.com")
        .get('/')
        .reply(200, '<html>HELLO</html>')

    return this.robot.adapter.receive(new TextMessage(this.user, 'hubot web-screen myfakesite.com'))
  }))
}))

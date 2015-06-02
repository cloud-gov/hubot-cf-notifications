assert = require('assert')
fixtures = require('./support/fixtures')
notifier = require('../src/notifier')

describe 'notifier', ->
  describe '.roomFor()', ->
    it "uses the default room", ->
      event = fixtures.getStartedEvent()
      room = notifier.roomFor(event.entity)
      assert.equal(room, 'cf-notifications')

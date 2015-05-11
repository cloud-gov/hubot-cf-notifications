fixtures = require('./support/fixtures')
notifier = require('../src/notifier')

describe 'notifier', ->
  describe '.roomFor()', ->
    it "uses the default room", ->
      event = fixtures.getStartedEvent()
      notifier.roomFor(event.entity)

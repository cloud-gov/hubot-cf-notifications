assert = require('assert')
fs = require('fs')
checker = require('../src/event_checker')

describe 'event_checker', ->
  describe '.isDeploy()', ->
    it "returns false for STOPPED events", ->
      event = JSON.parse(fs.readFileSync('test/fixtures/stop_event.json'))
      # sanity check
      assert.equal(event.entity.metadata.request.state, 'STOPPED')
      assert(!checker.isDeploy(event))

  describe '.getRequestOpts()', ->
    it "formats the timestamp properly", ->
      since = new Date(2014, 2, 1)
      opts = checker.getRequestOpts(since)
      assert.deepEqual(opts,
        path: '/v2/events'
        qs:
          q: [
            'timestamp>2014-03-01T06:00:00.000Z'
            'type:audit.app.update'
          ]
      )

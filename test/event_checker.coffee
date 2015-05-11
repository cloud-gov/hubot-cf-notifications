assert = require('assert')
checker = require('../src/event_checker')

describe 'event_checker', ->
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

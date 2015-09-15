# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
checker = require('../src/event_checker')
tests = require('../src/smoke_tests')

describe 'smoke_tests', ->
  logger = null

  flatten = (array) ->
    # http://stackoverflow.com/a/4631593/358804
    [].concat(array)

  getOutput = ->
    flatten(logger.args).join("\n")

  beforeEach ->
    logger = this.sinon.stub(tests, 'log')

  describe '.printRecent()', ->
    it "handles no deployment events", ->
      this.sinon.stub(checker, 'getUpdateEvents').callsArgWith(1, null, [])

      tests.printRecent()

      expected = """
        Recent deployment events:
        -------------------------
        []

        Notifications:
        --------------
      """
      assert.equal(getOutput(), expected)

    # TODO implement once the Promises are in, since this is async
    it "prints the notifications"

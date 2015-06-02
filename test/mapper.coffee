assert = require('assert')
path = require('path')
mapper = require('../src/mapper')

describe 'mapper', ->
  describe '.configPath()', ->
    it "defaults to the process root directory", ->
      actual = mapper.configPath()
      expected = path.resolve(__dirname, '..')
      assert.equal(actual, expected)

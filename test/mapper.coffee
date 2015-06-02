# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
path = require('path')
client = require('../src/client')
mapper = require('../src/mapper')

describe 'mapper', ->
  describe '.configPath()', ->
    it "defaults to the process root directory", ->
      actual = mapper.configPath()
      expected = path.resolve(__dirname, '..')
      assert.equal(actual, expected)

  describe '.orgNameByGuid()', ->
    it "fetches the name from the API", (done) ->
      callStub = this.sinon.stub(client, 'call')
      callStub.callsArgWith(1, null, {}, {name: 'someorg'})

      mapper.orgNameByGuid '123456', (err, name)->
        assert.equal(name, 'someorg')
        done(err)

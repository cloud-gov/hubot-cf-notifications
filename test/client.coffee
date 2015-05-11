# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
client = require('../src/client')

describe 'client', () ->
  describe '.resolveUrl()', () ->
    it "returns the absolute URL", () ->
      this.sinon.stub(client, 'apiOrigin').returns('http://host.com')
      result = client.resolveUrl('/foo')
      assert.equal(result, 'http://host.com/foo')

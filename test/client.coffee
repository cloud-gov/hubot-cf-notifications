assert = require('assert')
sinon = require('sinon')
client = require('../src/client')

describe 'client', () ->
  describe '.resolveUrl()', () ->
    it "returns the absolute URL", () ->
      sinon.stub(client, 'apiOrigin').returns('http://host.com')
      result = client.resolveUrl('/foo')
      assert.equal(result, 'http://host.com/foo')

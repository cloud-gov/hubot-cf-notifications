# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
Promise = require('bluebird')
nock = require('nock')
client = require('../src/client')
credentials = require('../src/credentials')

describe 'client', ->
  describe '.call()', ->
    # needs to be called with context of the test
    stubWithToken = (accessToken) ->
      promise = new Promise (fulfill, reject) ->
        fulfill(access_token: accessToken)
      this.sinon.stub(credentials, 'fetchTokenObj').returns(promise)

    it "passes the data to the Promise", ->
      this.sinon.stub(client, 'apiOrigin').returns('http://api.host.com')
      stubWithToken.call(this, '123')

      nock('http://api.host.com').get('/foo').reply(200, bar: 'baz')

      client.request(path: '/foo').then (data) ->
        assert.deepEqual(data, bar: 'baz')

  describe '.resolveUrl()', ->
    it "returns the absolute URL", ->
      this.sinon.stub(client, 'apiOrigin').returns('http://host.com')
      result = client.resolveUrl('/foo')
      assert.equal(result, 'http://host.com/foo')

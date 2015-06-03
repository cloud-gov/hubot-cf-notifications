# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
Promise = require('bluebird')
nock = require('nock')
client = require('../src/client')
credentials = require('../src/credentials')

describe 'client', ->
  describe '.call()', ->
    stubWithToken = (accessToken) ->
      promise = new Promise (fulfill, reject) ->
        fulfill(access_token: accessToken)

      # TODO figure out how to hold onto the context
      this.sinon.stub(credentials, 'fetchTokenObj').returns(promise)

    it "passes the data to the callback", (done) ->
      this.sinon.stub(client, 'apiOrigin').returns('http://api.host.com')
      stubWithToken.call(this, '123')

      nock('http://api.host.com').get('/foo').reply(200, bar: 'baz')

      opts = {path: '/foo'}
      client.request opts, (error, response, data) ->
        assert.deepEqual(data, bar: 'baz')
        done(error)

  describe '.resolveUrl()', ->
    it "returns the absolute URL", ->
      this.sinon.stub(client, 'apiOrigin').returns('http://host.com')
      result = client.resolveUrl('/foo')
      assert.equal(result, 'http://host.com/foo')

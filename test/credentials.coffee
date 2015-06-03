# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
nock = require('nock')
credentials = require('../src/credentials')

describe 'credentials', ->
  describe '.fetchTokenObj()', ->
    it "returns a Promise", ->
      this.sinon.stub(credentials, 'uaaOrigin').returns('http://uaa.host.com')
      this.sinon.stub(credentials, 'username').returns('myuser')
      this.sinon.stub(credentials, 'password').returns('password')

      nock('http://uaa.host.com').post('/oauth/token').reply({})

      promise = credentials.fetchTokenObj()
      assert.equal(typeof promise.then, 'function')
      promise

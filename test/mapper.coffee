# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
fs = require('fs')
Promise = require('bluebird')
client = require('../src/client')
mapper = require('../src/mapper')
fixtures = require('./support/fixtures')
temporary = require('temporary')

describe 'mapper', ->
  # needs to be called with context of the test
  stubOrg = (name) ->
    promise = new Promise (fulfill) ->
      fulfill(name: name)
    this.sinon.stub(client, 'request').returns(promise)

  describe '.getConfig()', ->
    it "handles a missing config file", ->
      # sanity check
      assert.equal(mapper.configExists(), false)
      assert.deepEqual(mapper.getConfig(), {})

  describe '.orgNameByGuid()', ->
    it "fetches the name from the API", ->
      stubOrg.call(this, 'someorg')
      mapper.orgNameByGuid('123456').then (name)->
        assert.equal(name, 'someorg')

  describe '.roomForEntity()', ->
    entity = null
    origCwd = null
    testTempDir = null

    writeConfig = (data) ->
      json = JSON.stringify(data)
      fs.writeFileSync('cf_config.json', json)

    beforeEach ->
      event = fixtures.getStartedEvent()
      entity = event.entity
      stubOrg.call(this, 'myorg')
      origCwd = process.cwd()
      testTempDir = new temporary.Dir()
      process.chdir(testTempDir.path)

    afterEach ->
      fs.unlinkSync('cf_config.json')
      process.chdir(origCwd)
      testTempDir.rmdir()

    it "uses the default room when there isn't a match", ->
      writeConfig({})
      mapper.roomForEntity(entity).then (room) ->
        assert.equal(room, 'cf-notifications')

    it "allows the default room to be overridden", ->
      writeConfig({ room: 'notification-center' })
      mapper.roomForEntity(entity).then (room) ->
        assert.equal(room, 'notification-center')

    it "finds the org that matches the room", ->
      writeConfig({
        orgs: {
          myorg: {
            room: 'myorgroom'
          }
        }
      })

      mapper.roomForEntity(entity).then (room) ->
        assert.equal(room, 'myorgroom')

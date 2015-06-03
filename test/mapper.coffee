# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
fs = require('fs')
client = require('../src/client')
mapper = require('../src/mapper')
fixtures = require('./support/fixtures')
temporary = require('temporary')

describe 'mapper', ->
  describe '.getConfig()', ->
    it "handles a missing config file", ->
      # sanity check
      assert.equal(mapper.configExists(), false)
      assert.deepEqual(mapper.getConfig(), {})

  describe '.orgNameByGuid()', ->
    it "fetches the name from the API", (done) ->
      this.sinon.stub(client, 'call').callsArgWith(1, null, {}, {name: 'someorg'})

      mapper.orgNameByGuid '123456', (err, name)->
        assert.equal(name, 'someorg')
        done(err)

  describe '.roomForEntity()', ->
    entity = null
    origCwd = null
    testTempDir = null

    beforeEach ->
      event = fixtures.getStartedEvent()
      entity = event.entity
      this.sinon.stub(client, 'call').callsArgWith(1, null, {}, {name: 'myorg'})
      origCwd = process.cwd()
      testTempDir = new temporary.Dir()
      process.chdir(testTempDir.path)

    afterEach ->
      fs.unlinkSync('cf_config.json')
      process.chdir(origCwd)
      testTempDir.rmdir()

    it "uses the default room when there isn't a match", (done) ->
      fs.writeFileSync('cf_config.json', JSON.stringify({}))

      mapper.roomForEntity entity, (err, room) ->
        assert.equal(room, 'cf-notifications')
        done(err)

    it "allows the default room to be overridden", (done) ->
      fs.writeFileSync('cf_config.json', JSON.stringify(
        {room: 'notification-center'}))

      mapper.roomForEntity entity, (err, room) ->
        assert.equal(room, 'notification-center')
        done(err)

    it "finds the org that matches the room", (done) ->
      fs.writeFileSync('cf_config.json', JSON.stringify({
        orgs: {
          myorg: {
            room: 'myorgroom'
          }
        }
      }))

      mapper.roomForEntity entity, (err, room) ->
        assert.equal(room, 'myorgroom')
        done(err)

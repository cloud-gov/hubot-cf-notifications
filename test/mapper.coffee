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
    orig_cwd = null
    test_temp_dir = null

    writeConfig = (data) ->
      json = JSON.stringify(data)
      fs.writeFileSync('cf_config.json', json)

    beforeEach ->
      event = fixtures.getStartedEvent()
      entity = event.entity
      this.sinon.stub(client, 'call').callsArgWith(1, null, {}, {name: 'myorg'})
      orig_cwd = process.cwd()
      test_temp_dir = new temporary.Dir()
      process.chdir(test_temp_dir.path)

    afterEach ->
      fs.unlinkSync('cf_config.json')
      process.chdir(orig_cwd)
      test_temp_dir.rmdir()

    it "uses the default room when there isn't a match", (done) ->
      writeConfig({})

      mapper.roomForEntity entity, (err, room) ->
        assert.equal(room, 'cf-notifications')
        done(err)

    it "allows the default room to be overridden", (done) ->
      writeConfig({ room: 'notification-center' })

      mapper.roomForEntity entity, (err, room) ->
        assert.equal(room, 'notification-center')
        done(err)

    it "finds the org that matches the room", (done) ->
      writeConfig({
        orgs: {
          myorg: {
            room: 'myorgroom'
          }
        }
      })

      mapper.roomForEntity entity, (err, room) ->
        assert.equal(room, 'myorgroom')
        done(err)

# https://github.com/elliotf/mocha-sinon#using-mochas-flakey---watch-flag
require('mocha-sinon')()

assert = require('assert')
path = require('path')
client = require('../src/client')
mapper = require('../src/mapper')
fixtures = require('./support/fixtures')

describe 'mapper', ->
  describe '.configPath()', ->
    it "defaults to the process root directory", ->
      actual = mapper.configPath()
      expected = path.resolve(__dirname, '../apps.json')
      assert.equal(actual, expected)

  describe '.orgNameByGuid()', ->
    it "fetches the name from the API", (done) ->
      this.sinon.stub(client, 'call').callsArgWith(1, null, {}, {name: 'someorg'})

      mapper.orgNameByGuid '123456', (err, name)->
        assert.equal(name, 'someorg')
        done(err)

  describe '.roomForEntity()', ->
    it "uses the default room when there isn't a match", (done) ->
      this.sinon.stub(mapper, 'getConfig').returns({})
      this.sinon.stub(mapper, 'orgNameByGuid').callsArgWith(1, null, 'otherorg')

      event = fixtures.getStartedEvent()
      mapper.roomForEntity event.entity, (err, room) ->
        assert.equal(room, 'cf-notifications')
        done(err)

    it "allows the default room to be overridden", (done) ->
      this.sinon.stub(mapper, 'getConfig').returns(room: 'notification-center')
      this.sinon.stub(mapper, 'orgNameByGuid').callsArgWith(1, null, 'otherorg')

      event = fixtures.getStartedEvent()
      mapper.roomForEntity event.entity, (err, room) ->
        assert.equal(room, 'notification-center')
        done(err)

    it "finds the org that matches the room", (done) ->
      this.sinon.stub(mapper, 'getConfig').returns(
        orgs: {
          myorg: {
            room: 'myorgroom'
          }
        }
      )
      this.sinon.stub(mapper, 'orgNameByGuid').callsArgWith(1, null, 'myorg')

      event = fixtures.getStartedEvent()
      mapper.roomForEntity event.entity, (err, room) ->
        assert.equal(room, 'myorgroom')
        done(err)

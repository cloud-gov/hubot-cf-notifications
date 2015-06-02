appRoot = require('app-root-path')
fs = require('fs')
path = require('path')
client = require('../src/client')

module.exports = {
  configPath: ->
    path.resolve(appRoot.toString(), 'apps.json')

  configExists: ->
    fs.existsSync(@configPath())

  getConfig: ->
    # TODO cache config
    if @configExists()
      contents = fs.readFileSync(@configPath())
      JSON.parse(contents)
    else
      {}

  orgNameByGuid: (guid, callback) ->
    opts = {
      path: "/v2/organizations/#{guid}/summary"
    }
    client.call opts, (error, response, data) ->
      callback(error, data.name)

  roomForOrg: (name) ->
    config = @getConfig()

    config.orgs?[name].room ||
      config.room ||
      process.env.HUBOT_CF_ROOM ||  # TODO drop environment variable support
      'cf-notifications'

  roomForEntity: (entity, callback) ->
    guid = entity.organization_guid
    @orgNameByGuid guid, (err, name) =>
      room = @roomForOrg(name)
      callback(err, room)
}

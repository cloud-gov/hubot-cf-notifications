# draws inspiration from https://github.com/atmos/hubot-deploy/blob/master/docs/config-file.md
fs = require('fs')
client = require('../src/client')

# using just the filename will be relative to process.cwd()
configPath = 'cf_config.json'

module.exports = {
  configExists: ->
    fs.existsSync(configPath)

  getConfig: ->
    # TODO cache config
    if @configExists()
      contents = fs.readFileSync(configPath)
      JSON.parse(contents)
    else
      {}

  # returns a Promise
  orgNameByGuid: (guid) ->
    opts = {
      path: "/v2/organizations/#{guid}/summary"
    }
    client.request(opts).then (data) ->
      data.name

  roomForOrg: (name) ->
    config = @getConfig()
    config.orgs?[name].room ||
      config.room ||
      process.env.HUBOT_CF_ROOM ||  # TODO drop environment variable support
      'cf-notifications'

  # returns a Promise
  roomForEntity: (entity) ->
    guid = entity.organization_guid
    @orgNameByGuid(guid).then (name) =>
      @roomForOrg(name)
}

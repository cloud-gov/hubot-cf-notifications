appRoot = require('app-root-path')
client = require('../src/client')

module.exports = {
  configPath: ->
    appRoot

  orgNameByGuid: (guid, callback) ->
    opts = {
      path: "/v2/organizations/#{guid}/summary"
    }
    client.call opts, (error, response, data) ->
      callback(error, data.name)
}

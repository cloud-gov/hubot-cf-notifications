util = require('util')
client = require('../src/client')

module.exports = {
  # http://apidocs.cloudfoundry.org/205/events/list_app_update_events.html
  getRequestOpts: (since) ->
    sinceStr = since.toISOString()
    {
      path: '/v2/events'
      qs:
        q: [
          "timestamp>#{sinceStr}"
          'type:audit.app.update'
        ]
    }

  getUpdateEvents: (since, callback) ->
    opts = @getRequestOpts(since)
    client.call opts, (error, response, data) ->
      callback(error, data.resources)

  # check for apps deployed to support https://github.com/cloudfoundry-community/cf-ssh
  isCfSsh: (event) ->
    /-ssh$/.test(event.entity.actee_name)

  # a mediocre proxy for an existing app being `push`ed, since it has false positives like new instances starting
  isAppStarting: (event) ->
    event.entity.metadata?.request?.state is 'STARTED'

  isDeploy: (event) ->
    !@isCfSsh(event) && @isAppStarting(event)

  getDeployEntities: (since, callback) ->
    @getUpdateEvents since, (error, events) =>
      if error
        callback(error)
      else
        entities = (event.entity for event in events when @isDeploy(event))
        callback(null, entities)

  # for debugging
  printRecent: ->
    since = new Date()
    since.setHours(since.getHours() - 3)

    @getDeployEntities since, (error, entities) ->
      console.log('error:', error)
      console.log(util.inspect(entities,
        colors: true,
        depth: null
      ))
}

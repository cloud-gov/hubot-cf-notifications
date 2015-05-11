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

  isDeploy: (event) ->
    # a mediocre proxy for an existing app being `push`ed, since it has false positives like new instances starting
    event.entity.metadata?.request?.state is 'STARTED'

  getDeployEntities: (since, callback) ->
    @getUpdateEvents since, (error, events) =>
      if error
        callback(error)
      else
        entities = (event.entity for event in events when @isDeploy(event))
        callback(null, entities)
}

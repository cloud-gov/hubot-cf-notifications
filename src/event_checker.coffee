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

  # returns a Promise
  getUpdateEvents: (since) ->
    opts = @getRequestOpts(since)
    client.request(opts).then (data) ->
      data.resources

  # check for apps deployed to support https://github.com/cloudfoundry-community/cf-ssh
  isCfSsh: (event) ->
    /-ssh$/.test(event.entity.actee_name)

  # a mediocre proxy for an existing app being `push`ed, since it has false positives like new instances starting
  isAppStarting: (event) ->
    event.entity.metadata?.request?.state is 'STARTED'

  isDeploy: (event) ->
    !@isCfSsh(event) && @isAppStarting(event)

  # returns a Promise
  getDeployEntities: (since) ->
    @getUpdateEvents(since).then (events) =>
      entities = (event.entity for event in events when @isDeploy(event))
      entities
}

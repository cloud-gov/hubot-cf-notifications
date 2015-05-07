# Description:
#   Sends notifications of Cloud Foundry activity.
#
# Configuration:
#   HUBOT_CF_USER
#   HUBOT_CF_PASS
#   HUBOT_CF_API_ORIGIN
#   HUBOT_CF_UAA_ORIGIN
#   HUBOT_CF_ROOM (default to `cf-notifications`)
#
# Notes:
#   Create the client credentials via:
#
#     cf create-user hubot-cf-listener <password>
#     # add read-only permissions for the appropriate orgs/spaces
#     cf set-org-role hubot-cf-listener <org> OrgAuditor
#
#   then set HUBOT_CF_USER and HUBOT_CF_PASS.
#
# Author:
#   afeld

childProcess = require('child_process')
client = require('../src/client')


# http://apidocs.cloudfoundry.org/205/events/list_app_update_events.html
getRequestOpts = (since) ->
  sinceStr = since.toISOString()
  {
    path: '/v2/events'
    qs:
      q: [
        "timestamp>#{sinceStr}"
        'type:audit.app.update'
      ]
  }


getUpdateEvents = (since, callback) ->
  opts = getRequestOpts(since)
  client.call opts, (error, response, data) ->
    callback(error, data.resources)


isDeploy = (event) ->
  # a mediocre proxy for an existing app being `push`ed, since it has false positives like new instances starting
  event.entity.metadata?.request?.state is 'STARTED'


getDeployEntities = (since, callback) ->
  getUpdateEvents since, (error, events) ->
    if error
      callback(error)
    else
      entities = (event.entity for event in events when isDeploy(event))
      callback(null, entities)

roomFor = (entity) ->
  # TODO map to particular rooms based on organization_guid
  process.env.HUBOT_CF_ROOM || 'cf-notifications'

notifyForDeploys = (robot) ->
  # poll for deployment events
  lastCheckedAt = new Date()

  setInterval(->
    getDeployEntities lastCheckedAt, (error, entities) ->
      for entity in entities
        envelope = {
          room: roomFor(entity)
        }
        robot.send(envelope, "#{entity.actor_name} is deploying #{entity.actee_name}")

    lastCheckedAt = new Date()
  , 5000)



# check if run directly, for testing
if require.main is module
  since = new Date(2014)
  getDeployEntities since, (error, entities) ->
    console.log('error:', error)
    console.log(entities)
else
  module.exports = (robot) ->
    notifyForDeploys(robot)

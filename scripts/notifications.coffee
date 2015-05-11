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
# Author:
#   afeld

checker = require('../src/event_checker')
notifier = require('../src/notifier')

notifyForDeploys = (robot) ->
  # poll for deployment events
  lastCheckedAt = new Date()

  setInterval(->
    checker.getDeployEntities lastCheckedAt, (error, entities) ->
      notifier.processEntities(entities, robot)
    lastCheckedAt = new Date()
  , 5000)


# check if run directly, for testing
if require.main is module
  since = new Date()
  since.setHours(since.getHours() - 1)
  checker.getDeployEntities since, (error, entities) ->
    console.log('error:', error)
    console.log(entities)
else
  module.exports = (robot) ->
    notifyForDeploys(robot)

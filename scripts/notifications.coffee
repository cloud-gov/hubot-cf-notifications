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

# check if run directly, for testing
if require.main is module
  checker = require('../src/event_checker')
  checker.printRecent()
else
  notifier = require('../src/notifier')
  module.exports = (robot) ->
    notifier.notifyForDeploys(robot)

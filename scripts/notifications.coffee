# Description:
#   Sends notifications of Cloud Foundry activity.
#
# Configuration:
#   HUBOT_CF_USER
#   HUBOT_CF_PASS
#   HUBOT_CF_API_ORIGIN
#   HUBOT_CF_UAA_ORIGIN
#
# Author:
#   afeld

notifier = require('../src/notifier')
module.exports = (robot) ->
  notifier.notifyForDeploys(robot)

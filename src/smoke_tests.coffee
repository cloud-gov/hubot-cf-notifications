util = require('util')
checker = require('./event_checker')
notifier = require('./notifier')


printNotifications = (entities) ->
  console.log("Notifications:")
  console.log("--------------")

  # fake Hubot
  robot = {
    send: (envelope, msg) ->
      console.log("#{envelope.room}: #{msg}")
  }
  notifier.processEntities(entities, robot)

printEntities = (entities) ->
  console.log("Recent deployment events:")
  console.log("-------------------------")
  console.log(util.inspect(entities,
    colors: true,
    depth: null
  ))

printRecent = ->
  since = new Date()
  since.setHours(since.getHours() - 24)

  checker.getDeployEntities since, (error, entities) ->
    if error
      throw error
    else
      printEntities(entities)
      console.log('') # newline
      printNotifications(entities)
      # TODO console.log("\nOK") when complete


printRecent()

util = require('util')
checker = require('./event_checker')
notifier = require('./notifier')


module.exports = {
  # to make testing easier
  log: ->
    console.log.apply(console, arguments)

  printNotifications: (entities) ->
    @log("Notifications:")
    @log("--------------")

    # fake Hubot
    robot = {
      send: (envelope, msg) =>
        @log("#{envelope.room}: #{msg}")
    }
    notifier.processEntities(entities, robot)

  printEntities: (entities) ->
    @log("Recent deployment events:")
    @log("-------------------------")
    @log(util.inspect(entities,
      colors: true,
      depth: null
    ))

  printRecent: ->
    since = new Date()
    since.setHours(since.getHours() - 24)

    checker.getDeployEntities(since).then (entities) =>
      @printEntities(entities)
      @log('') # newline
      @printNotifications(entities)
      # TODO @log("\nOK") when complete
}


# check if file is being run directly
if require.main is module
  module.exports.printRecent()

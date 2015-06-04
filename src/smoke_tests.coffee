util = require('util')
checker = require('./event_checker')

printRecent = ->
  since = new Date()
  since.setHours(since.getHours() - 24)

  checker.getDeployEntities since, (error, entities) ->
    if error
      throw error
    else
      console.log("Recent deployment events:")
      console.log(util.inspect(entities,
        colors: true,
        depth: null
      ))

printRecent()

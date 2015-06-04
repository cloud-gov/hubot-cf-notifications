util = require('util')
checker = require('./event_checker')

module.exports.printRecent = ->
  since = new Date()
  since.setHours(since.getHours() - 3)

  checker.getDeployEntities since, (error, entities) ->
    console.log('error:', error)
    console.log(util.inspect(entities,
      colors: true,
      depth: null
    ))

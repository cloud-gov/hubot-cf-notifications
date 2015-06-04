checker = require('./event_checker')
mapper = require('./mapper')

module.exports = {
  processEntity: (entity, robot) ->
    # TODO handle error
    mapper.roomForEntity(entity).then (room) ->
      envelope = {
        room: room
      }
      robot.send(envelope, "#{entity.actor_name} is deploying #{entity.actee_name}")

  processEntities: (entities, robot) ->
    for entity in entities
      @processEntity(entity, robot)

  # returns a Promise
  notify: (since, robot) ->
    checker.getDeployEntities(since).then (entities) =>
      @processEntities(entities, robot)

  notifyForDeploys: (robot) ->
    # poll for deployment events
    lastCheckedAt = new Date()

    setInterval(=>
      @notify(lastCheckedAt, robot)
      lastCheckedAt = new Date()
    , 5000)
}

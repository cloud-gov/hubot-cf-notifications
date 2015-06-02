checker = require('./event_checker')
mapper = require('./mapper')

module.exports = {
  processEntity: (entity, robot) ->
    mapper.roomForEntity entity, (err, room) ->
      # TODO handle error
      envelope = {
        room: room
      }
      robot.send(envelope, "#{entity.actor_name} is deploying #{entity.actee_name}")

  processEntities: (entities, robot) ->
    for entity in entities
      @processEntity(entity, robot)

  notify: (since, robot) ->
    checker.getDeployEntities since, (error, entities) =>
      @processEntities(entities, robot)

  notifyForDeploys: (robot) ->
    # poll for deployment events
    lastCheckedAt = new Date()

    setInterval(=>
      @notify(lastCheckedAt, robot)
      lastCheckedAt = new Date()
    , 5000)
}

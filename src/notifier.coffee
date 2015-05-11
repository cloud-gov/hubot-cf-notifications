checker = require('./event_checker')

module.exports = {
  roomFor: (entity) ->
    # TODO map to particular rooms based on organization_guid
    process.env.HUBOT_CF_ROOM || 'cf-notifications'

  processEntity: (entity, robot) ->
    envelope = {
      room: @roomFor(entity)
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

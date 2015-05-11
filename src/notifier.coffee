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
}

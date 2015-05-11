fs = require('fs')

module.exports = {
  getStoppedEvent: ->
    path = 'test/fixtures/stop_event.json'
    contents = fs.readFileSync(path)
    JSON.parse(contents)

  getStartedEvent: ->
    event = @getStoppedEvent()
    event.entity.metadata.request.state = 'STARTED'
    event
}

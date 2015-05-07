# https://github.com/cloudfoundry/uaa/blob/master/docs/UAA-APIs.rst#support-for-additional-authorization-attributes
request = require('request')


module.exports = {
  username: ->
    process.env.HUBOT_CF_USER || throw new Error("Please set HUBOT_CF_USER.")

  password: ->
    process.env.HUBOT_CF_PASS || throw new Error("Please set HUBOT_CF_PASS.")

  uaaOrigin: ->
    process.env.HUBOT_CF_UAA_ORIGIN || throw new Error("Please set HUBOT_CF_UAA_ORIGIN.")

  requestOpts: ->
    # https://gist.github.com/ozzyjohnson/6ae51e3fdebc8a839751
    {
      url: @uaaOrigin() + '/oauth/token'
      method: 'POST'
      json: true
      headers:
        authorization: 'Basic Y2Y6'
      form:
        grant_type: 'password'
        username: @username()
        password: @password()
    }

  # TODO use promises
  fetchTokenObj: (callback) ->
    opts = @requestOpts()
    request opts, (error, response, token) ->
      if error
        console.log('Access Token Error', error)
      else
        callback(token)
}

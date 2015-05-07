Fs   = require 'fs'
Path = require 'path'

module.exports = (robot) ->
  # Resolve the path to the scripts directory in the package
  path = Path.resolve __dirname, 'scripts'

  # Check if that path exists, and try loading each script in the directory
  Fs.exists path, (exists) ->
    if exists
      robot.loadFile path, file for file in Fs.readdirSync(path)

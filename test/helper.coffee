global.Agent = require '../src'
global.Http = require 'http'
global.assert = require 'assert'
global.Test =
  port: 9000
  endpoint: 'http://localhost:9000'
  server: (callback) ->
    srv = Http.createServer callback
    srv.listen Test.port
    srv
  agent: (args...) ->
    Agent.create Test.endpoint, args...

class Agent
  constructor: (@endpoint, @client, callback) ->
    if typeof @client is 'function'
      callback = @client
      @client = null

    @client or= require("./vendor/scoped-http-client").create(@endpoint)
    callback?(@client)

  root: (callback) ->
    if @rootResource
      callback? @rootResource
    else if @rootCallbacks
      @rootCallbacks.push callback
    else
      @rootCallbacks = [callback]
      @start (res) =>
        callbacks = @rootCallbacks
        delete @rootCallbacks
        @rootResource = res
        for cb in callbacks
          cb? res

  start: (callback) ->
    @call 'get', @endpoint, callback

  call: (method, url, data, options, callback) ->
    if typeof data is 'function'
      options = data
      data = null

    if typeof options is 'function'
      callback = options
      options = null

    if method in Agent.noBody
      options or= data
      data = null

    options or= {}
    callback or= options.callback
    started = null

    agent = @
    @client.scope url, (cli) ->
      started = new Date
      cli[method]() (err, res, body) ->
        return unless callback
        callback new Response(agent, res, body, started)

  decodeBody: (str) ->
    JSON.parse str

Agent.noBody = ['get', 'head']

class Response
  constructor: (@agent, @response, body, @started) ->
    @time = new Date
    @status = @response.statusCode
    @data = new Resource @agent, body
    @headers = @response.headers
    @timing = @time - @started

class Resource
  constructor: (@agent, json) ->
    @extractAttributes @agent.decodeBody json

  get: (key) ->
    @data[key]

  extractAttributes: (data) ->
    @data = {}
    for key, value of data
      if key in Resource.reserved
        @data[key] = value
      else
        @[key] = value

Resource.reserved = []
for key, value of Resource.prototype
  Resource.reserved.push key

exports.create = (args...) ->
  new Agent args...

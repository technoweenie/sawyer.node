class Agent
  constructor: (@endpoint, @client, callback) ->
    if typeof @client is 'function'
      callback = @client
      @client = null

    @client or= require("./vendor/scoped-http-client").create(@endpoint)
    callback?(@client)

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

    decoder = @decodeBody
    @client.scope url, (cli) ->
      started = new Date
      cli[method]() (err, res, body) ->
        return unless callback
        callback new Response(res, body, started, decoder)

  decodeBody: (str) ->
    JSON.parse str

Agent.noBody = ['get', 'head']

class Response
  constructor: (@response, @body, @started, @decoder) ->
    @time = new Date
    @status = @response.statusCode
    @data = @decoder @body
    @headers = @response.headers
    @timing = @time - @started

exports.create = (args...) ->
  new Agent args...

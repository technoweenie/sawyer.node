class Agent
  constructor: (@endpoint, @client, callback) ->
    if typeof @client is 'function'
      callback = @client
      @client = null

    @client or= require("./vendor/scoped-http-client").create(@endpoint)
    callback?(@client)

  call: (method, url, data, options, callback) ->
    if method in Agent.noBody
      options or= data
      data = null

    options or= {}
    callback or= options.callback
    started = null

    @client.scope url, (cli) ->
      cli[method]() (err, res, body) ->
        console.log res
        callback? body

Agent.noBody = ['get', 'head']

exports.create = (args...) ->
  new Agent args...

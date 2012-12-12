require '../helper'


server = Http.createServer (req, res) ->
  res.writeHead 200,
    'Content-Type': 'application/json'
  res.end JSON.stringify(
    method: req.method
    url: req.url
  )

server.listen Test.port

agent = Agent.create(Test.endpoint)
agent.call 'get', 'foo', (body) ->
  console.log 'shout out', body
  server.close()


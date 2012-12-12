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
agent.call 'get', 'foo', (res) ->
  assert.equal 200, res.status
  assert.equal 'GET', res.data.method
  assert.equal '/foo', res.data.url
  assert.equal 'application/json', res.headers['content-type']
  server.close()


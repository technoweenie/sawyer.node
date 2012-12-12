require '../helper'


server = Test.server (req, res) ->
  res.writeHead 200,
    'Content-Type': 'application/json'
  res.end JSON.stringify(
    method: req.method
    url: req.url
  )

agent = Test.agent()
agent.call 'get', 'foo', (res) ->
  assert.equal 200, res.status
  assert.equal 'GET', res.data.method
  assert.equal '/foo', res.data.url
  assert.equal 'application/json', res.headers['content-type']
  assert.ok res.time
  assert.ok res.timing
  server.close()


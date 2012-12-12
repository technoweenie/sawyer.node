require '../helper'

calls = 0
server = Test.server (req, res) ->
  calls += 1
  res.writeHead 200,
    'Content-Type': 'application/json'
  res.end JSON.stringify(
    method: req.method
    url: req.url
    calls: calls
  )

agent = Test.agent()

# hits the root endpoint without caching it
agent.start (res) ->
  assert.equal 1, res.data.calls

  # hits the root endpoint (not cached)
  agent.root (res) ->
    assert.equal 2, res.data.calls

    # hits the root endpoint cache
    agent.root (res) ->
      assert.equal 2, res.data.calls
      server.close()

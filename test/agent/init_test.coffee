require '../helper'

endpoint = 'http://127.0.0.1:9999'

# agent with endpoint
agent = Agent.create endpoint
assert.ok agent.client
assert.equal endpoint, agent.endpoint

# agent with endpoint, client, and callback
client = agent.client
client.booya = 1

called = false
agent = Agent.create endpoint, client, (cli) ->
  called = true
  assert.equal 1, cli.booya

assert.ok called
assert.ok agent.client
assert.equal 1, agent.client.booya
assert.equal endpoint, agent.endpoint

# agent with endpoint and callback
called = false
agent = Agent.create endpoint, (cli) ->
  called = true
  assert.notEqual 1, cli.booya

assert.ok called
assert.ok agent.client
assert.notEqual 1, agent.client.booya
assert.equal endpoint, agent.endpoint


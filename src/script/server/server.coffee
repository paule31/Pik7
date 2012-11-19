port = 8080

ns = require('node-static')

files = new(ns.Server)('.')
server = require('http').createServer (request, response) ->
  request.addListener 'end', ->
    files.serve(request, response)

server.listen(port)

console.log("\u001b[36m Info: \u001b[m Pik7 server running at \u001b[1mlocalhost:#{port}")
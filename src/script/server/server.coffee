# Super-rudimentaray web server. Can serve static pages and list the contents of certain
# directories (e.g. /presentations). Could in the future be expanded to enable realtime
# communication between clients.

fs = require('fs')
path = require('path')
ns = require('node-static')

port = 8080

# List the contents of the requested directory
listDirectory = (request, response) ->
  dir = path.relative('/', request.url)
  html = "<!doctype html><meta charset=\"utf-8\"><title>#{request.url}</title><h1>#{request.url}</h1><ul>"
  fs.readdir dir, (err, result) ->
    if err then return endError(request, response, { status: 500 })
    result.forEach (file) ->
      html += "<li><a href=\"#{encodeURI(request.url + '/' + file)}\">#{file}</a>"
    html += '</ul>'
    response.writeHead(200, { "Content-Type": "text/html" })
    response.end(html)


# Ends a request with an error message
endError = (request, response, err) ->
  response.end("Error #{err.status}")
  console.log("\u001b[31m Error\u001b[m - #{err.status} for \u001b[1m#{request.url}\u001b[m")


# Serve static files from the main directory.
fileServer = new(ns.Server)('.')
server = require('http').createServer (request, response) ->
  request.addListener 'end', ->
    fileServer.serve request, response, (err) ->
      # For 404s that happen somewhere inside /presentations, offer a directory listing
      if err
        if err.status == 404 && /^\/presentations/.test(request.url)
          listDirectory(request, response)
        else
          endError(request, response, err) if request.url != '/favicon.ico'
      else
        console.log("  \u001b[30m#{response.statusCode} #{request.url}\u001b[m")


server.listen(port)
console.log("\u001b[36m Info\u001b[m  - Pik7 server running at \u001b[1mlocalhost:#{port}\u001b[m")
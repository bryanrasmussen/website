# Requires
docpad = require 'docpad'
filepad = require 'filepad'
express = require 'express'

# Create Instances
docpadInstance = docpad.createInstance port:8002
filepadInstance = filepad.createInstance path: __dirname+'/src', port:8003

# Fetch Servers
docpadServer = docpadInstance.server
filepadServer = filepadInstance.server

# Master Server
app = express.createServer()
app.use express.vhost 'balupton.*', docpadServer
app.use express.vhost 'edit.balupton.*', filepadServer
app.listen process.env.PORT || 8001
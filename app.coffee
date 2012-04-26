express   = require 'express'
stylus    = require 'stylus'
util      = require 'util'
everyauth = require './lib/github'
mongoose  = require 'mongoose'

# Connect to mongodb :)
mongoose.connect process.env.MONGOHQ_URL

# Create server 
app = express.createServer()

# Config
app.configure ->
  if process.env.NODE_ENV isnt 'production'
    app.use stylus.middleware
      debug: true
      src: __dirname + '/public'
      dest: __dirname + '/public'
      compile: (str) ->
        stylus(str).set('compress', true)
  
  app.use express.bodyParser()
  app.use express.cookieParser()
  app.use express.session { secret: 'asdfasdf' }
  app.use everyauth.middleware()
  app.use express.methodOverride()
  app.use express.static __dirname + '/public'
  app.use app.router
  app.set 'view engine', 'jade'
  app.set 'views', __dirname + '/views'
  everyauth.helpExpress(app)

app.configure 'development', ->
  app.use express.errorHandler
    dumpExceptions: true
    showStack: true

app.configure 'production', ->
  app.use express.errorHandler()

# Routes
app.get  '/',               require('./routes/index')
app.get  '/:org',           require('./routes/org').get
app.post '/:org',           require('./routes/org').post
app.get  '/:org/:decision', require('./routes/decision').get
app.post '/:org/:decision', require('./routes/decision').post

app.listen process.env.PORT ?= 3000, ->
  console.log "Express server listening on port %d in %s mode", app.address().port, app.settings.env

module.exports = app
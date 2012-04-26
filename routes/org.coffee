###
  GET home page.
###

auth =         require '../lib/auth'
Decision =     require '../models/decision'
_ =            require 'underscore'
relativeDate = require 'relative-date'

module.exports.get = (req, res) ->
  auth req, res, (user) ->
    Decision.find( org: req.params.org ).sort( 'date', -1 ).execFind (err, docs) ->
      # Prepare
      _.each docs, (doc) ->
        doc.count = 0
        doc.relativeDate = relativeDate(doc.date)
        _.each doc.possibilities, (pos) ->
          doc.count += pos.voters.length

      res.render 'org', 
        org: req.params.org
        decisions: docs

module.exports.post = (req, res) ->
  auth req, res, (user) ->
    res.header "Content-Type", "application/json"
    try
      possibilities = []
      _.each req.body.possibilities, (possibility) ->
        if possibility.length > 0
          possibilities.push
            text: possibility
            voters: []

      decision = new Decision
        title: req.body.title
        org: req.params.org
        creator:
          name: user.name
          url: user.html_url
          avatar: user.avatar_url
        possibilities: possibilities

      decision.save (err) ->
        if err
          res.send JSON.stringify( error: err )
        else
          res.send JSON.stringify( success: decision )

    catch e 
      res.send JSON.stringify( error:e ) 

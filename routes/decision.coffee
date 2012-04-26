###
  GET home page.
###

auth =         require '../lib/auth'
Decision =     require '../models/decision'
_ =            require 'underscore'
relativeDate = require 'relative-date'

module.exports.get = (req, res) ->
  auth req, res, (user) ->
    Decision.findById req.params.decision, (err, doc) ->

      # Make it beautiful :)
      doc.count = 0
      doc.relativeDate = relativeDate(doc.date)
      _.each doc.possibilities, (pos) ->
        doc.count += pos.voters.length


      # Find out for which item i voted
      voted_for = -1
      for possibility, i in doc.possibilities
          for voter in possibility.voters
            if voter?.url is user.html_url
              voted_for = i

      res.render 'decision',
        org: req.params.org
        decision: doc
        voted_for: voted_for

module.exports.post = (req, res) ->
  auth req, res, (user) ->
    res.header "Content-Type", "application/json"
    try
      Decision.findById req.params.decision, (err, decision) ->

        # Remove if you have already voted
        for possibility, i in decision.possibilities
          for voter, j in possibility.voters
            console.log voter?.url
            if voter?.url is user.html_url
              decision.possibilities[i].voters[j].remove()

        # Save the delete, otherwise we cannot push ):
        decision.save (err) ->
          if err
            res.send JSON.stringify( error: err )
          else
            decision.possibilities[parseInt(req.body.index)].voters.push
              name: user.name
              url: user.html_url
              avatar: user.avatar_url

            decision.save (err) ->
              if err
                res.send JSON.stringify( error: err )
              else
                res.send JSON.stringify( success: decision )

    catch e 
      res.send JSON.stringify( error:e ) 

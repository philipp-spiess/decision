###
  GET home page.
###

auth =  require '../lib/auth'

module.exports = (req, res) ->
  auth req, res, (user) ->
    console.log user
    res.render 'index'
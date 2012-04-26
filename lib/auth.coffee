###
  Auth mechanism
###

_ = require 'underscore'

module.exports = (req, res, fn) -> 
  login = true

  # If logged in
  unless req.session.auth? and req.session.auth.loggedIn?
    login = false
  # Or checked an org
  else if req.params?.org?
    current_org  = req.params.org
    orgs = req.session.auth.github.user.orgs

    login = false
    _.each orgs, (org) ->
      if org.login is current_org
        login = true

  if login
    fn? req.session.auth.github.user
  else
    res.redirect '/login'
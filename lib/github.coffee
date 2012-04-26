###
  Github strategy for everyauth using api V3 and orgs ;)
###

everyauth = require 'everyauth'

# everyauth.debug = true

# GitHub OAuth
users = {}

everyauth.github
  .entryPath('/login')
  .apiHost('https://api.github.com/')
  .fetchOAuthUser (accessToken) ->
    p = this.Promise();
    that = this
    that.oauth.get that.apiHost() + 'user', accessToken, (err, data) ->
      if (err)
        return p.fail(err)

      oauthUser = JSON.parse(data)

      that.oauth.get that.apiHost() + 'user/orgs', accessToken, (err, data) ->
        if (err)
          return p.fail(err)
        oauthUser.orgs = JSON.parse(data)
        p.fulfill(oauthUser)

    return p
  .appId(process.env.DECISION_APPID)
  .appSecret(process.env.DECISION_SECRET)
  .findOrCreateUser (sess, accessToken, accessTokenExtra, ghUser) ->
    console.log accessToken
    unless users[ghUser.id]?
      users[ghUser.id] = ghUser
    users[ghUser.id]
  .redirectPath('/')

module.exports = everyauth
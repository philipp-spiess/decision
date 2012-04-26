mongoose = require 'mongoose'

User = new mongoose.Schema
  name: String
  url: String
  avatar: String

Possibility = new mongoose.Schema
  text:
    type: String
    required: true
  voters: [ User ]

Decision = new mongoose.Schema
  title:
    type: String
    required: true
  org:
    type: String
    required: true
    index: true
  date:
    type: Date
    default: Date.now
  creator: 
    name: String
    url: String
    avatar: String
  possibilities: [ Possibility ]

module.exports = mongoose.model 'Decision', Decision
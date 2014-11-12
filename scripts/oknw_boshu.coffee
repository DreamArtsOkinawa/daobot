# Description:
#   Retrieve news related to public offer
#
# Commands:
#   hubot okinawa boshu - get kobo lists
#   hubot okinawa boshu kobo - get kobo lists
#   hubot okinawa boshu nyusatsu - get nyusatsu lists
#   hubot okinawa boshu new - get kobo has opened
#   hubot okinawa boshu kobo new - get kobo has opened
#   hubot okinawa boshu nyusatsu - get kobo nyusatsu opened
#
# Author:
#   hiromiyagi

request = require("request")

class Boshu
  url: 'https://www.kimonolabs.com/api/6nnwgmey?apikey=rbkcE1a21fhOgpACclSMc5mFZ9FUyMnq'

  constructor: ->
    that = this
    request @url, (err, response, body) ->
      that.api = JSON.parse(body)

  kobo: ->
    @api.results.kobo

  nyusatsu: ->
    @api.results.nyusatsu


module.exports = (robot) ->

  boshu = new Boshu

  robot.respond /okinawa boshu (kobo|nyusatsu)$/i, (msg) ->
    method = msg.match[1]
    msg.send ("#{item.date} - #{item.title.text} #{item.title.href}" for item in boshu[method]()).join '\n'

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

  all: ->
    @kobo().concat @nyusatsu()

  kobo: ->
    @api.results.kobo

  nyusatsu: ->
    @api.results.nyusatsu

  new: (items)->
    items.filter((item) => item.new.src)



module.exports = (robot) ->

  boshu = new Boshu

  robot.respond /okinawa boshu$/i, (msg) ->
    msg.send ("#{item.date} - #{item.title.text}\n#{item.title.href}" for item in boshu.all()).join '\n\n'

  robot.respond /okinawa boshu (kobo|nyusatsu)$/i, (msg) ->
    method = msg.match[1]
    msg.send ("#{item.date} - #{item.title.text}\n#{item.title.href}" for item in boshu[method]()).join '\n\n'

  robot.respond /okinawa boshu new$/i, (msg) ->
    msg.send ("#{item.date} - #{item.title.text}\n#{item.title.href}" for item in boshu.new(boshu.all())).join '\n\n'

  robot.respond /okinawa boshu (kobo|nyusatsu) (new)$/i, (msg) ->
    method = msg.match[1]
    msg.send ("#{item.date} - #{item.title.text}\n#{item.title.href}" for item in boshu.new(boshu[method]())).join '\n\n'

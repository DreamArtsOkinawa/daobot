# Description:
#   The Yahoo News Top 20 of the genre you chose is returned
#
# Commands:
#   hubot news [all|IT|sports|geinou|keizai] - The Yahoo News Top 20 of the genre you chose is returned
#

request = require("request")

class YahooAll
  url: 'https://www.kimonolabs.com/api/87mytyla?apikey=kw3rpsf6o05I12B9rBLS6jLimYFT0zHM'

  constructor: ->
    that = this
    request @url, (err, response, body) ->
      that.api = JSON.parse(body)

  all: ->
    @collection1()

  collection1: ->
    @api.results.collection1

  new: (items)->
    items.filter((item) => item.new.src)

class YahooSports
  url: 'https://www.kimonolabs.com/api/6901dldm?apikey=kw3rpsf6o05I12B9rBLS6jLimYFT0zHM'

  constructor: ->
    that = this
    request @url, (err, response, body) ->
      that.api = JSON.parse(body)

  all: ->
    @collection1()

  collection1: ->
    @api.results.collection1

  new: (items)->
    items.filter((item) => item.new.src)

class YahooIT
  url: 'https://www.kimonolabs.com/api/ajglczpm?apikey=kw3rpsf6o05I12B9rBLS6jLimYFT0zHM'

  constructor: ->
    that = this
    request @url, (err, response, body) ->
      that.api = JSON.parse(body)

  all: ->
    @collection1()

  collection1: ->
    @api.results.collection1

  new: (items)->
    items.filter((item) => item.new.src)

class YahooGeinou
  url: 'https://www.kimonolabs.com/api/dcx5rn3y?apikey=kw3rpsf6o05I12B9rBLS6jLimYFT0zHM'

  constructor: ->
    that = this
    request @url, (err, response, body) ->
      that.api = JSON.parse(body)

  all: ->
    @collection1()

  collection1: ->
    @api.results.collection1

  new: (items)->
    items.filter((item) => item.new.src)

class YahooKeizai
  url: 'https://www.kimonolabs.com/api/ad29jw6e?apikey=kw3rpsf6o05I12B9rBLS6jLimYFT0zHM'

  constructor: ->
    that = this
    request @url, (err, response, body) ->
      that.api = JSON.parse(body)

  all: ->
    @collection1()

  collection1: ->
    @api.results.collection1

  new: (items)->
    items.filter((item) => item.new.src)

module.exports = (robot) ->

  newsall = new YahooAll
  sports = new YahooSports
  it = new YahooIT
  geinou = new YahooGeinou
  keizai = new YahooKeizai

  robot.respond /news all/i, (msg) ->
    msg.send ("#{item.property1.text}\n#{item.property1.href}" for item in newsall.all()).join '\n\n'

  robot.respond /news sports/i, (msg) ->
    msg.send ("#{item.property1.text}\n#{item.property1.href}" for item in sports.all()).join '\n\n'

  robot.respond /news IT/i, (msg) ->
    msg.send ("#{item.property1.text}\n#{item.property1.href}" for item in it.all()).join '\n\n'

  robot.respond /news geinou/i, (msg) ->
    msg.send ("#{item.property1.text}\n#{item.property1.href}" for item in geinou.all()).join '\n\n'

  robot.respond /news keizai/i, (msg) ->
    msg.send ("#{item.property1.text}\n#{item.property1.href}" for item in keizai.all()).join '\n\n'



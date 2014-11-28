# Description:
#   Check Airplane vacant seat.
#
# Commands:
#   hubot air <from(沖縄)> <to(羽田)> <date(mmdd)> - Returns Skymark ANA JAL Website URL.
#   hubot air list - show area list.

_ = require 'underscore'

class areaList
  airMap:
    "羽田 or 東京": 1
    "成田": 2
    "札幌 or 新千歳 or 北海道": 3
    "仙台": 4
    "茨城": 5
    "名古屋 or 中部": 6
    "大阪": 7
    "関西": 8
    "伊丹": 9
    "神戸": 10
    "米子": 11
    "広島": 12
    "岩国": 13
    "福岡": 14
    "北九州": 15
    "長崎": 16
    "鹿児島": 17
    "那覇 or 沖縄": 18
    "宮古": 19
    "石垣": 20

  emotions: ->
    _.keys @airMap

module.exports = (robot) ->
  arealist = new areaList

  robot.respond /air (.+)[\s　](.+)[\s　](.+)/i, (msg) ->
    from = msg.match[1]
    to = msg.match[2]
    date= msg.match[3]
    url = "http://hima213.com/pub/jlvr2cwx/air.php?from=" + from + "&to=" + to + "&date=" + date
    robot.http(url)
    .get() (err, res, body) ->
      str = body.replace(/\ /g,"\n")
      msg.send str 

  robot.respond /air list/i, (msg) ->
    msg.send arealist.emotions().join "\n"


# Description:
#   Show bijin-tokei
#
# Commands:
#   hubot bijint area - show area list
#   hubot bijint <area> <HHmm> - show bijin-tokei image
#
# Author:
#   hiromiyagi

dateformat = require 'dateformat'
cronJob = require('cron').CronJob

areas = [
  ['日本', 'jp'],
  ['2012', '2012jp'],
  ['2011', '2011jp'],
  ['東京', 'tokyo'],
  ['北海道', 'hokkaido'],
  ['宮城', 'sendai'],
  ['秋田', 'akita'],
  ['群馬', 'gunma'],
  ['新潟', 'niigata'],
  ['石川', 'kanazawa'],
  ['福井', 'fukui'],
  ['愛知', 'nagoya'],
  ['京都', 'kyoto'],
  ['大阪', 'osaka'],
  ['兵庫', 'kobe'],
  ['岡山', 'okayama'],
  ['香川', 'kagawa'],
  ['福岡', 'fukuoka'],
  ['鹿児島', 'kagoshima'],
  ['沖縄', 'okinawa'],
  ['熊本', 'kumamoto'],
  ['埼玉', 'saitama'],
  ['広島', 'hiroshima'],
  ['千葉', 'chiba'],
  ['奈良', 'nara'],
  ['山口', 'yamaguchi'],
  ['長野', 'nagano'],
  ['静岡', 'shizuoka'],
  ['宮崎', 'miyazaki'],
  ['鳥取', 'tottori'],
  ['岩手', 'iwate'],
  ['山梨', 'yamanashi'],
  ['茨城', 'ibaraki'],
  ['栃木', 'tochigi'],
  ['佐賀', 'saga'],
  ['taiwan', 'taiwan'],
  ['hawaii', 'hawaii'],
  ["美男", "binan"],
  ["カンバン娘", "k-musume"],
  ["美魔女", "bimajo"],
]

module.exports = (robot) ->

  getBijin = (area, hhmm = "#{dateformat(new Date, 'HHMM')}") ->
    unless Math.max(0, parseInt(hhmm[..1])) < 24 and Math.max(0, parseInt(hhmm[2..])) < 60
      hhmm = "#{dateformat(new Date, 'HHMM')}"
    return "http://www.bijint.com/#{area}/tokei_images/#{hhmm}.jpg"

  getArea = (area) ->
    filtered = areas.filter((a) => area in a).pop()
    return if filtered then filtered[1] else areas[Math.floor(Math.random() * areas.length)][1]

  robot.respond /(?:bijint|美人時計) area$/, (msg) ->
    msg.send "対応エリアは(#{areas.map((a) => a[0]).join("|")})"

  robot.respond /(?:bijint|美人時計)(?: ([^\s]*))?(?: (\d{4}))?$/, (msg) ->
    if msg.match[1] is 'area' then return

    area = getArea(msg.match[1])

    hhmm = msg.match[2]
    msg.send getBijin(area, hhmm)

  new cronJob('00 00 09,12,18 * * 1-5', () ->
    area = areas[Math.floor(Math.random() * ((areas.length - 1) + 1))][1]
    robot.send {room: "#{process.env.BIJINT_CRON_ROOM}"}, getBijin(area, dateformat(new Date, 'HHMM'))
  ).start()

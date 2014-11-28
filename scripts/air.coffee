# Description:
#   Check Airplane vacant seat.
#
# Commands:
#   hubot air <from(沖縄)> <to(羽田)> <date(mmdd)> - Returns Skymark ANA JAL Website URL.

module.exports = (robot) ->

  robot.respond /air (.+) (.+) (.+)/i, (msg) ->
    from = msg.match[1]
    to = msg.match[2]
    date= msg.match[3]
    url = "http://hima213.com/pub/jlvr2cwx/air.php?from=" + from + "&to=" + to + "&date=" + date
    robot.http(url)
    .get() (err, res, body) ->
      str = body.replace(/\ /g,"\n")
      msg.send str 


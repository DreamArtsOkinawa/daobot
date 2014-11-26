# Description:
#   Interacts with the Google Maps API.
#
# Commands:
#   hubot map <住所or施設名> - Returns a map view of the area returned by `住所or施設名`.

module.exports = (robot) ->

  robot.respond /map (.+)/i, (msg) ->
    location = msg.match[1]
    url = "http://hima213.com/pub/jlvr2cwx/map.php?addres=" + location
    robot.http(url)
    .get() (err, res, body) ->
      msg.send body 


# Description:
#   meigen from twitter
#
# Commands:
#   hubot 名言
#
# Author:
#   masato

module.exports = (robot) ->

  robot.respond /名言/i, (msg) ->
    robot.http('http://hima213.com/pub/jlvr2cwx/twitter.php')
    .get() (err, res, body) ->
      msg.send body

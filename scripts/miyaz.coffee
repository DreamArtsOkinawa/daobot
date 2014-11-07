module.exports = (robot) ->

  robot.hear /宮里/i, (msg) ->
    msg.send "ルートビアでしょ"


module.exports = (robot) ->

  robot.hear /宮里さんといえば/i, (msg) ->
    msg.send "ルートビアでしょ"


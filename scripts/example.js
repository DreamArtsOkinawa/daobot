// Description:
//   Example scripts for you to examine and try out.
//   Translate example.coffee to javascript.
//
// Notes:
//   They are commented out by default, because most of them are pretty silly and
//   wouldn't be useful and amusing enough for day to day huboting.
//   Uncomment the ones you want to try and experiment with.
//
//   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = function(robot) {

  // robot.hear(/badger/i, function(msg) {
  //   msg.send("Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS");
  // });

  // robot.respond(/open the (.*) doors/i, function(msg) {
  //   var doorType = msg.match[1];
  //   if (doorType === "pod bay") {
  //     msg.reply("I'm afraid I can't let you do that.");
  //   } else {
  //     msg.reply("Opening #{doorType} doors");
  //   }
  // });

  // robot.hear(/I like pie/i, function(msg) {
  //   msg.emote("makes a freshly baked pie");
  // });

  // var lulz = ['lol', 'rofl', 'lmao'];

  // robot.respond(/lulz/i, function(msg) {
  //   msg.send(msg.random(lulz));
  // });

  // robot.topic(function(msg) {
  //   msg.send("#{msg.message.text}? That's a Paddlin'");
  // });


  // var enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you'];
  // var leaveReplies = ['Are you still there?', 'Target lost', 'Searching'];

  // robot.enter(function(msg) {
  //   msg.send(msg.random(enterReplies));
  // });
  // robot.leave(function(msg) {
  //   msg.send(msg.random(leaveReplies));
  // });

  // var answer = process.env.HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING;

  // robot.respond(/what is the answer to the ultimate question of life/, function(msg) {
  //   if (!answer) {
  //     msg.send("Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again");
  //     return;
  //   }
  //   msg.send("#{answer}, but what is the question?");
  // });

  // robot.respond(/you are a little slow/, function(msg) {
  //   setTimeout(function() {
  //     msg.send("Who you calling 'slow'?");
  //   }, 60 * 1000);
  // });

  // var annoyIntervalId = null

  // robot.respond(/annoy me/, function(msg) {
  //   if (annoyIntervalId) {
  //     msg.send("AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH");
  //     return;
  //   }

  //   msg.send("Hey, want to hear the most annoying sound in the world?");
  //   annoyIntervalId = setInterval(function() {
  //     msg.send("AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH");
  //   }, 1000);
  // });

  // robot.respond(/unannoy me/, function(msg) {
  //   if (annoyIntervalId) {
  //     msg.send( "GUYS, GUYS, GUYS!");
  //     clearInterval(annoyIntervalId);
  //     annoyIntervalId = null;
  //   } else {
  //     msg.send("Not annoying you right now, am I?");
  //   }
  // });


  // robot.router.post('/hubot/chatsecrets/:room', function(req, res) {
  //   var room   = req.params.room;
  //   var data   = JSON.parse(req.body.payload);
  //   var secret = data.secret;

  //   robot.messageRoom(room, "I have a secret: #{secret}");

  //   res.send('OK');
  // });

  // robot.error(function(err, msg) {
  //   robot.logger.error("DOES NOT COMPUTE");

  //   if (msg)
  //     msg.reply("DOES NOT COMPUTE");
  // });

  // robot.respond(/have a soda/i, function(msg) {
  //   // Get number of sodas had (coerced to a number).
  //   var sodasHad = robot.brain.get('totalSodas') * 1 || 0;

  //   if (sodasHad > 4) {
  //     msg.reply("I'm too fizzy..");
  //   } else {
  //     msg.reply('Sure!');
  //   }

  //     robot.brain.set('totalSodas', sodasHad+1);
  // });

  // robot.respond(/sleep it off/i, function(msg) {
  //   robot.brain.set('totalSodas', 0);
  //   robot.respond('zzzzz');
  // });

}

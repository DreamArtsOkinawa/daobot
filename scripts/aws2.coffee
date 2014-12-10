# Description:
#   Queries for the status of AWS services
#
# Dependencies:
#   "aws2js": "^2.0.25"
#
# Configuration:
#   HUBOT_AWS_ACCESS_KEY_ID
#   HUBOT_AWS_SECRET_ACCESS_KEY
#   HUBOT_AWS_EC2_REGIONS
#
# Commands:
#   hubot ec2 list - Show EC2 instace list.
#   hubot ec2 list ami - Show AMI list.
#   hubot ec2 create <instanceName> <amiName> - Create the EC2 instance. Set <instanceName> to Tags:Name
#   hubot ec2 start <instanceName> - Start the EC2 instance.
#   hubot ec2 stop <instanceName> - Stop the EC2 instance.
#   hubot ec2 destroy <instanceName> - Terminate the EC2 instance.
#
# Notes:
#   It's highly recommended to use a read-only IAM account for this purpose
#   https://console.aws.amazon.com/iam/home?
#   EC2 - requires EC2:Describe*, elasticloadbalancing:Describe*, cloudwatch:ListMetrics, 
#   cloudwatch:GetMetricStatistics, cloudwatch:Describe*, autoscaling:Describe*
#
# Author:
#    miyaz

key = process.env.HUBOT_AWS_ACCESS_KEY_ID
secret = process.env.HUBOT_AWS_SECRET_ACCESS_KEY
AWS = require("aws-sdk")
AWS.config.update({region: 'ap-northeast-1', accessKeyId: key, secretAccessKey: secret});
ec2 = new AWS.EC2()

runInstances = (msg) ->
  if msg.message.room isnt "testroom"
    msg.send "そのコマンドは #testroom でやってね"
    return
  params =
    ImageId: msg.match[2] if msg.match[2]
    ImageId: "ami-d26361d3" if not msg.match[2]
    InstanceType: "t2.medium"
    MinCount: 1
    MaxCount: 1
    KeyName: "dssdev"
    IamInstanceProfile: {
      Arn: 'arn:aws:iam::566109878544:instance-profile/slack-miyaz'
    }
    NetworkInterfaces: [
      DeviceIndex: 0
      AssociatePublicIpAddress: true
      SubnetId: "subnet-4ee5e63a"
      Groups: [ "sg-1f7f9b7a" ]
    ]
  instanceName = msg.match[1]

  # Create the instance
  ec2.runInstances params, (err, data) ->
    if err
      msg.send "Could not create instance", err
      return
    instanceId = data.Instances[0].InstanceId
  
    # Add tags to the instance
    params =
      Resources: [instanceId]
      Tags: [
        {
          Key: "Name"
          Value: instanceName
        }
        {
          Key: "Owner"
          Value: "#{msg.message.user.name}"
        }
      ]
    ec2.createTags params, (err) ->
      msg.send err if err
      return

    reply =  "@#{msg.message.user.name}: インスタンス[#{instanceName}]を作成中です\n"
    reply += "5分程待って下記にアクセスしてください\n"
    reply += "Web 一般ユーザアクセス (test01:test01) http://#{instanceName}.dev.diol.jp/\n"
    reply += "Web 管理ユーザアクセス (insuite:admin) http://#{instanceName}.dev.diol.jp:8001/\n"
    reply += "SSH rootユーザアクセス (root:dss#dev)  ssh://#{instanceName}.dev.diol.jp:22\n"
    reply += "    ->Chrome SecureShell用URL  chrome-extension://pnhechapfaindjhompbnflcldabbghjo/html/nassh.html#root@#{instanceName}.dev.diol.jp:22"
    msg.send reply
    return

startInstances = (msg) ->
  params = {}
  if msg.message.room isnt "testroom"
    msg.send "そのコマンドは #testroom でやってね"
    return
  instanceName = msg.match[1]
  ec2.describeInstances params, (err, data) ->
    instanceId = ""
    if err
      console.log err, err.stack
    else
      for insidx of data.Reservations
        instances = data.Reservations[insidx]
        InstanceState = instances.Instances[0].State.Name
        for tagidx of instances.Instances[0].Tags
          tags = instances.Instances[0].Tags[tagidx]
          if tags.Key is "Name"
            instanceId = instances.Instances[0].InstanceId if msg.match[1] is tags.Value and InstanceState is "stopped"

    msg.send "not found instance[#{msg.match[1]}] in stopped" if instanceId is ""
    return if instanceId is ""

    params =
      InstanceIds: ["#{instanceId}"]

    # Start the instance
    ec2.startInstances params, (err, data) ->
      if err
        msg.send "Could not start instance", err
        return
      return

    reply =  "@#{msg.message.user.name}: インスタンス[#{instanceName}]を起動中です\n"
    reply += "5分程待って利用開始してください => http://#{instanceName}.dev.diol.jp/"
    msg.send reply
    return

stopInstances = (msg) ->
  params = {}
  if msg.message.room isnt "testroom"
    msg.send "そのコマンドは #testroom でやってね"
    return
  instanceName = msg.match[1]
  ec2.describeInstances params, (err, data) ->
    instanceId = ""
    if err
      console.log err, err.stack
    else
      for insidx of data.Reservations
        instances = data.Reservations[insidx]
        InstanceState = instances.Instances[0].State.Name
        for tagidx of instances.Instances[0].Tags
          tags = instances.Instances[0].Tags[tagidx]
          if tags.Key is "Name"
            instanceId = instances.Instances[0].InstanceId if msg.match[1] is tags.Value and InstanceState is "running"

    msg.send "not found instance[#{msg.match[1]}] in running" if instanceId is ""
    return if instanceId is ""

    params =
      InstanceIds: ["#{instanceId}"]

    # Stop the instance
    ec2.stopInstances params, (err, data) ->
      if err
        msg.send "Could not stop instance", err
        return
      msg.send "@#{msg.message.user.name}: インスタンス[#{instanceName}]を停止中です"
      return
    return

terminateInstances = (msg) ->
  params = {}
  if msg.message.room isnt "testroom"
    msg.send "そのコマンドは #testroom でやってね"
    return
  instanceName = msg.match[1]
  ec2.describeInstances params, (err, data) ->
    instanceId = ""
    ownerName = ""
    if err
      console.log err, err.stack
    else
      for insidx of data.Reservations
        instances = data.Reservations[insidx]
        InstanceState = instances.Instances[0].State.Name
        for tagidx of instances.Instances[0].Tags
          tags = instances.Instances[0].Tags[tagidx]
          if tags.Key is "Name"
            instanceId = instances.Instances[0].InstanceId if msg.match[1] is tags.Value and InstanceState isnt "terminated"
      for insidx of data.Reservations
        instances = data.Reservations[insidx]
        if instanceId is instances.Instances[0].InstanceId
          for tagidx of instances.Instances[0].Tags 
            tags = instances.Instances[0].Tags[tagidx]
            ownerName = tags.Value if tags.Key is "Owner"

    msg.send "Not found instance[#{msg.match[1]}]" if instanceId is ""
    return if instanceId is ""
    msg.send "Only owner can delete instance[#{msg.match[1]}]" if ownerName isnt msg.message.user.name
    return if ownerName isnt msg.message.user.name

    params =
      InstanceIds: ["#{instanceId}"]

    # Destroy the instance
    ec2.terminateInstances params, (err, data) ->
      if err
        msg.send "Could not destroy instance", err
        return
      msg.send "@#{msg.message.user.name}: インスタンス[#{instanceName}]を削除中です"
      return
    return

listInstances = (msg) ->
  params = {}
  if msg.message.room isnt "testroom" and msg.message.room isnt "Shell"
    msg.send "そのコマンドは #testroom でやってね"
    return
  ec2.describeInstances params, (err, data) ->
    if err
      console.log err, err.stack
    else
      data.Reservations.sort (a, b) ->
        x = a.Instances[0].Tags[0].Value
        y = b.Instances[0].Tags[0].Value
        return 1  if x > y
        return -1  if x < y
        0

      messageStr = ""
      for insidx of data.Reservations
        instanceStr = ""
        instanceName = ""
        ownerName = ""
        instances = data.Reservations[insidx]
        for tagidx of instances.Instances[0].Tags
          tags = instances.Instances[0].Tags[tagidx]
          if tags.Key is "Name"
            instanceName = tags.Value
          if tags.Key is "Owner"
            ownerName = tags.Value
        if instanceName is ""
          instanceStr += "undefined" + "\t/ "
        else
          instanceStr += instanceName + ((if tags.Value.length < 11 then "\t/ " else "/ "))
        InstanceId = instances.Instances[0].InstanceId
        ImageId = instances.Instances[0].ImageId
        InstanceType = instances.Instances[0].InstanceType
        InstanceState = instances.Instances[0].State.Name
        instanceStr += InstanceId + " / "
        instanceStr += ImageId + " / "
        instanceStr += InstanceType + " / "
        instanceStr += InstanceState + " / "
        if ownerName isnt ""
          instanceStr += ownerName + "\n"
        else
          instanceStr += "\n"
        messageStr += instanceStr if InstanceState isnt "terminated"
      msg.send messageStr
    return

module.exports = (robot) ->
  robot.respond /ec2 create +([^ ]+) *([^ ]*).*$/i, (msg) ->
    runInstances msg
  robot.respond /ec2 stop +([^ ]+).*$/i, (msg) ->
    stopInstances msg
  robot.respond /ec2 start +([^ ]+).*$/i, (msg) ->
    startInstances msg
  robot.respond /ec2 destroy +([^ ]+).*$/i, (msg) ->
    terminateInstances msg
  robot.respond /ec2 list[ ]*$/i, (msg) ->
    listInstances msg


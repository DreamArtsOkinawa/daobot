# Description:
#   Queries for the status of AWS services
#
# Dependencies:
#   "aws2js": "0.6.12"
#   "underscore": "1.3.3"
#   "moment": "1.6.2"
#
# Configuration:
#   HUBOT_AWS_ACCESS_KEY_ID
#   HUBOT_AWS_SECRET_ACCESS_KEY
#   HUBOT_AWS_EC2_REGIONS
#
# Commands:
#   hubot ec2 status - Returns the status of EC2 instances
#   hubot ec2 status <name> - Returns the status of EC2 instance that matched <name>
#
# Notes:
#   It's highly recommended to use a read-only IAM account for this purpose
#   https://console.aws.amazon.com/iam/home?
#   EC2 - requires EC2:Describe*, elasticloadbalancing:Describe*, cloudwatch:ListMetrics, 
#   cloudwatch:GetMetricStatistics, cloudwatch:Describe*, autoscaling:Describe*
#
# Author:
#   Iristyle, miyaz

key = process.env.HUBOT_AWS_ACCESS_KEY_ID
secret = process.env.HUBOT_AWS_SECRET_ACCESS_KEY

_ = require 'underscore'
moment = require 'moment'
aws = require 'aws2js'
ec2 = aws
  .load('ec2', key, secret)
  .setApiVersion('2012-05-01')

getRegionInstances = (region, msg) ->
  ec2.setRegion(region).request 'DescribeInstances', (error, reservations) ->
    if error?
      msg.send "Failed to describe instances for region #{region} - error #{error}"
      return

    filter_str = msg.match[1]
    msg.send "filter by name : " + filter_str if filter_str

    ec2.setRegion(region).request 'DescribeInstanceStatus', (error, allStatuses) ->
      statuses = if error? then [] else allStatuses.instanceStatusSet.item

      instances = _.flatten [reservations?.reservationSet?.item ? []]
      instances = _.pluck instances, 'instancesSet'
      instances = _.flatten _.pluck instances, 'item'

      if filter_str
        find_cnt=0
        for instance in instances
          do (instance) ->
            status = _.find statuses, (s) ->
              instance.instanceId == s.instanceId
            tags = _.flatten [instance.tagSet?.item ? []]
            name = (_.find tags, (t) -> t.key == 'Name')?.value ? 'missing'
            find_cnt++ if name.indexOf(filter_str) isnt -1
        msg.send "Found #{find_cnt} instances for region #{region}..."

      else
        msg.send "Found #{instances.length} instances for region #{region}..."

      bot_speak = ''
      for instance in instances
        do (instance) ->
          status = _.find statuses, (s) ->
            instance.instanceId == s.instanceId

          tags = _.flatten [instance.tagSet?.item ? []]
          name = (_.find tags, (t) -> t.key == 'Name')?.value ? 'missing'


          suffix = ''
          state = instance.instanceState.name
          excl = String.fromCharCode 0x203C
          dexcl = excl + excl

          switch state
            when 'pending' then prefix = String.fromCharCode 0x25B2
            when 'running' then prefix = String.fromCharCode 0x25BA
            when 'shutting-down' then prefix = String.fromCharCode 0x25BC
            when 'terminated' then prefix = String.fromCharCode 0x25AA
            when 'stopping' then prefix = String.fromCharCode 0x25A1
            when 'stopped' then prefix = String.fromCharCode 0x25A0
            else prefix = dexcl

          if status?
            bad = _.filter [status.systemStatus, status.instanceStatus],
            (s) -> s.status != 'ok'

            if bad.length > 0
              prefix = dexcl
              badStrings = _.map bad, (b) ->
                b.details.item.name + ' ' + b.details.item.status
              concat = (memo, s) -> memo + s
              suffix = _.reduce badStrings, concat, ''

            iEvents = _.flatten [status.eventsSet?.item ? []]
            if not _.isEmpty iEvents then prefix = dexcl
            desc = (memo, e) -> "#{memo} #{dexcl}#{e.code} : #{e.description}"
            suffix += _.reduce iEvents, desc, ''

          id = instance.instanceId ? 'N/A'
          type = instance.instanceType
          dnsName = if _.isEmpty instance.dnsName then 'N/A' \
            else instance.dnsName
          launchTime = moment(instance.launchTime)
            .format 'ddd, L LT'
          arch = instance.architecture
          devType = instance.rootDeviceType

          if not filter_str or name.indexOf(filter_str) isnt -1
            bot_speak += "#{prefix} [#{state}] - #{name} / #{type} / #{id}\n"

      msg.send "#{bot_speak}" if instances.length > 0

#defaultRegions = 'ap-northeast-1,ap-southeast-1,sa-east-1,us-east-1,us-west-1,us-west-2,eu-west-1'
defaultRegions = 'ap-northeast-1'

module.exports = (robot) ->
  robot.respond /ec2 status[ ]*([^ ]*).*$/i, (msg) ->
    regions = process.env?.HUBOT_AWS_EC2_REGIONS ? defaultRegions
    getRegionInstances region, msg for region in regions.split ','

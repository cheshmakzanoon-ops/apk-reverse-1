local LWBerserkBossRewardAndAttackTimesInfo = BaseClass("LwBerserkBossRewardAndAttackTimesInfo")

function LWBerserkBossRewardAndAttackTimesInfo:__init()
  self.bossUuid = ""
  self.receivedReward = false
  self.alreadyAttackedTimes = 0
end

function LWBerserkBossRewardAndAttackTimesInfo:__delete()
  self.bossUuid = nil
  self.receivedReward = nil
  self.alreadyAttackedTimes = nil
end

function LWBerserkBossRewardAndAttackTimesInfo:InitData(message)
  if message.uuid then
    self.bossUuid = message.uuid
  end
  if message.times then
    self.alreadyAttackedTimes = message.times
  end
  if message.hasReward then
    self.receivedReward = message.hasReward
  end
end

return LWBerserkBossRewardAndAttackTimesInfo

local LWZoneMobilizationAttackInfo = BaseClass("LWZoneMobilizationAttackInfo")
local LWZoneMobilizationAttackOrDefendRewardInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationAttackOrDefendRewardInfo")

function LWZoneMobilizationAttackInfo:__init()
  self.bossServerId = 0
  self.bossPointId = 0
  self.transferBeginTime = 0
  self.transferEndTime = 0
  self.curHp = 0
  self.damage = 0
  self.rewardList = {}
  self.maxDamage = 0
  self.bossState = 0
  self.refreshTime = 0
  self.stage = 0
end

function LWZoneMobilizationAttackInfo:__delete()
  self.bossServerId = nil
  self.bossPointId = nil
  self.transferBeginTime = nil
  self.transferEndTime = nil
  self.curHp = nil
  self.damage = nil
  self.rewardList = nil
  self.maxDamage = nil
  self.bossState = nil
  self.refreshTime = nil
  self.stage = nil
end

function LWZoneMobilizationAttackInfo:RefreshData(message)
  self.bossServerId = message.bossServerId or 0
  self.bossPointId = message.bossPointId or 0
  self.transferBeginTime = message.transferBeginTime or 0
  self.transferEndTime = message.transferEndTime or 0
  self.curHp = message.curHp or 0
  self.damage = message.damage or 0
  self.rewardList = {}
  if message.rewardList then
    for i, v in ipairs(message.rewardList) do
      local rewardInfo = LWZoneMobilizationAttackOrDefendRewardInfo.New()
      rewardInfo:RefreshData(v)
      table.insert(self.rewardList, rewardInfo)
      if rewardInfo.targetValue > self.maxDamage then
        self.maxDamage = rewardInfo.targetValue
      end
    end
  end
  self.bossState = message.bossState or 0
  self.refreshTime = message.refreshTime or 0
  self.stage = message.stage or 0
end

function LWZoneMobilizationAttackInfo:OurSideIsPlacedBoss()
  return self.bossPointId > 0
end

function LWZoneMobilizationAttackInfo:IsAchieveAllDamage()
  return self.damage >= self.maxDamage
end

function LWZoneMobilizationAttackInfo:CanReceiveReward()
  local rewardCount = table.count(self.rewardList)
  for i = 1, rewardCount do
    local rewardInfo = self.rewardList[i]
    if not rewardInfo.rewarded and self.damage >= rewardInfo.targetValue then
      return true
    end
  end
  return false
end

function LWZoneMobilizationAttackInfo:UpdateRewardReceiveState(index)
  local rewardCount = table.count(self.rewardList)
  for i = 1, rewardCount do
    if index == 0 or index == i then
      local rewardInfo = self.rewardList[i]
      rewardInfo:UpdateReceivedState(self.damage >= rewardInfo.targetValue)
    end
  end
end

return LWZoneMobilizationAttackInfo

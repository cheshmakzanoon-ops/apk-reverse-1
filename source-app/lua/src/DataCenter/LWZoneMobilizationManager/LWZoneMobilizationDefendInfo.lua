local LWZoneMobilizationDefendInfo = BaseClass("LWZoneMobilizationDefendInfo")
local LWZoneMobilizationAttackOrDefendRewardInfo = require("DataCenter.LWZoneMobilizationManager.LWZoneMobilizationAttackOrDefendRewardInfo")

function LWZoneMobilizationDefendInfo:__init()
  self.bossSrcServerId = 0
  self.bossSrcPointId = 0
  self.bossPointId = 0
  self.transferBeginTime = 0
  self.transferEndTime = 0
  self.curHp = 0
  self.rewardList = {}
  self.rankList = {}
  self.bossState = 0
  self.refreshTime = 0
  self.bossId = 0
end

function LWZoneMobilizationDefendInfo:__delete()
  self.bossSrcServerId = nil
  self.bossSrcPointId = nil
  self.bossPointId = nil
  self.transferBeginTime = nil
  self.transferEndTime = nil
  self.curHp = nil
  self.rewardList = nil
  self.rankList = nil
  self.bossState = nil
  self.refreshTime = nil
  self.bossId = nil
end

function LWZoneMobilizationDefendInfo:RefreshData(message)
  self.bossSrcServerId = message.bossSrcServerId or 0
  self.bossSrcPointId = message.bossSrcPointId or 0
  self.bossPointId = message.bossPointId or 0
  self.transferBeginTime = message.transferBeginTime or 0
  self.transferEndTime = message.transferEndTime or 0
  self.curHp = message.curHp or 0
  self.rewardList = {}
  if message.rewardList then
    for i, v in ipairs(message.rewardList) do
      local rewardInfo = LWZoneMobilizationAttackOrDefendRewardInfo.New()
      rewardInfo:RefreshData(v)
      table.insert(self.rewardList, rewardInfo)
    end
  end
  self.rankList = {}
  if message.rankList then
    for i, v in ipairs(message.rankList) do
      local rankInfo = AllianceRankData.New()
      rankInfo:ParseData(v)
      rankInfo:SetRank(i)
      table.insert(self.rankList, rankInfo)
    end
  end
  self.bossState = message.bossState or 0
  self.refreshTime = message.refreshTime or 0
  self.bossId = message.bossId or 0
end

function LWZoneMobilizationDefendInfo:EnemySideIsPlacedBoss()
  return self.bossPointId > 0
end

function LWZoneMobilizationDefendInfo:IsTransfer()
  if self.transferBeginTime > 0 and 0 < self.transferEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.transferBeginTime and curTime <= self.transferEndTime then
      return true
    end
  end
  return false
end

function LWZoneMobilizationDefendInfo:UpdateRewardReceiveState(index)
  local rewardCount = table.count(self.rewardList)
  for i = 1, rewardCount do
    if index == i then
      local rewardInfo = self.rewardList[i]
      rewardInfo:UpdateReceivedState(true)
    end
  end
end

return LWZoneMobilizationDefendInfo

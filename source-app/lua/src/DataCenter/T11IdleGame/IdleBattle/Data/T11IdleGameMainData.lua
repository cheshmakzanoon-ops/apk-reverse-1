local T11IdleGameMainData = BaseClass("T11IdleGameMainData")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameMainData:__init()
  self.currentLevel = 0
  self.bossId = -1
  self.lastChallengeTime = 0
  self.idleGameIdleInfo = nil
  self.surpriseBoxGainTime = 0
  self.startGameLeftTime = 0
  self.canReceiveEventNum = 0
  self.startGameLeftTime_Client = 0
end

function T11IdleGameMainData:__delete()
  self.currentLevel = nil
  self.bossId = nil
  self.lastChallengeTime = nil
  self.idleGameIdleInfo = nil
  self.surpriseBoxGainTime = nil
  self.startGameLeftTime = nil
  self.canReceiveEventNum = nil
  self.startGameLeftTime_Client = nil
end

function T11IdleGameMainData:UpdateData(data)
  if data == nil then
    DataCenter.T11IdleGameManager:PrintRealErrorLog("T11IdleGameMainData:UpdateData call with nil data")
    return
  end
  if data.currentLevel then
    self.currentLevel = data.currentLevel
  end
  if data.bossId then
    self.bossId = data.bossId
  end
  if data.lastChallengeTime then
    self.lastChallengeTime = data.lastChallengeTime
  end
  if data.idleGameIdleInfo then
    DataCenter.T11IdleGameDataManager:ClearIdleInfoData()
    DataCenter.T11IdleGameDataManager:UpdateIdleInfoData(data.idleGameIdleInfo, self.currentLevel)
  end
  if data.surpriseBoxGainTime then
    self.surpriseBoxGainTime = data.surpriseBoxGainTime
  end
  if data.canReceiveEventNum then
    self.canReceiveEventNum = data.canReceiveEventNum
  end
  if data.startGameLeftTime ~= nil then
    self.startGameLeftTime = data.startGameLeftTime
    self.startGameLeftTime_Client = self.startGameLeftTime
  end
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameMainDataUpdate)
end

function T11IdleGameMainData:GetCurLevelId()
  return self.currentLevel
end

function T11IdleGameMainData:GetCurLevelTemplate()
  return DataCenter.T11IdleGameTemplateManager:GetLevelTemplateById(self:GetCurLevelId())
end

function T11IdleGameMainData:GetLastWinedBossId()
  return self.bossId
end

function T11IdleGameMainData:GetCanReceiveEventNum()
  return self.canReceiveEventNum
end

function T11IdleGameMainData:GetLastWinedBossTemplate()
  local bossId = self:GetLastWinedBossId()
  if bossId and 0 < bossId then
    return DataCenter.T11IdleGameTemplateManager:GetBossTemplateById(bossId)
  end
end

function T11IdleGameMainData:IsFinishedAllBoss()
  local lastBossTemplate = self:GetLastWinedBossTemplate()
  if lastBossTemplate and lastBossTemplate:IsFinalBoss() then
    return true
  end
  return false
end

function T11IdleGameMainData:GetCurBossTemplate()
  local preBossId = self:GetLastWinedBossId()
  if preBossId == -1 then
    local levelTemplate = self:GetCurLevelTemplate()
    if levelTemplate then
      return levelTemplate:GetFirstBossTemplate()
    end
  else
    local preBossTemplate = self:GetLastWinedBossTemplate()
    if preBossTemplate then
      return preBossTemplate:GetNextBossTemplate()
    end
  end
end

function T11IdleGameMainData:HasSurpriseBox()
  return self.surpriseBoxGainTime > 0
end

function T11IdleGameMainData:GetStartGameLeftTime()
  return self.startGameLeftTime_Client
end

function T11IdleGameMainData:TryAddStartGameLeftTime()
  local limitTime = DataCenter.T11IdleGameDataManager:GetStartGameLeftTimeLimit()
  local addTime = DataCenter.T11IdleGameDataManager:GetStartGameAddTimePerDay()
  local afterTime = self.startGameLeftTime_Client + addTime
  if limitTime < afterTime then
    return
  end
  self.startGameLeftTime_Client = afterTime
  EventManager:GetInstance():Broadcast(EventId.T11IdleGameOnStartGameLeftTimeChangeMessage)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  DataCenter.T11IdleGameManager:PrintEditorCustomLog("add leftTime at: " .. curTime .. "," .. UITimeManager:GetInstance():TimeStampToTimeForServer(curTime))
end

return T11IdleGameMainData

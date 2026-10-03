local LWSaveDominatorUpRecordMessage = BaseClass("LWSaveDominatorUpRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, stageId, isContinuous)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", stageId)
  if isContinuous then
    self.sfsObj:PutInt("isContinuous", isContinuous)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  if message.reward then
    DataCenter.RewardManager:AddRewardsAndRes(message)
    DataCenter.TowerUpSaveDataManager.saveData = message.reward
    EventManager:GetInstance():Broadcast(EventId.TowerupBattleReward, message.reward)
  end
  DataCenter.TowerUpSaveDataManager:AddSweepStage(message.reward, message.isWin)
  DataCenter.LWDominatorUpStageManager:UpdateData(message)
  if message.idleRewardStageId and message.lastIdleRewardTimeStamp then
    DataCenter.DomintorStageManager:UpdateHangUpReward(message.lastDominatorIdleRewardTimeStamp, message.idleRewardDominatorUpId)
  end
  local stageId = message.id
  local meta = DataCenter.DominatorUpTemplateManager:GetDominatorUpUnlockTemplate(stageId)
  if meta ~= nil and meta.type == TowerupBattleType.FakePVP then
    if message.contentArray then
      EventManager:GetInstance():Broadcast(EventId.TowerupFakePVPBattleDataGet, message)
    else
      EventManager:GetInstance():Broadcast(EventId.JeepAdventureFastSweep, message)
    end
  end
end

LWSaveDominatorUpRecordMessage.OnCreate = OnCreate
LWSaveDominatorUpRecordMessage.HandleMessage = HandleMessage
return LWSaveDominatorUpRecordMessage

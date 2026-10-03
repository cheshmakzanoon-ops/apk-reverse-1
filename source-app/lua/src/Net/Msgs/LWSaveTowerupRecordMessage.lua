local LWSaveTowerupRecordMessage = BaseClass("LWSaveTowerupRecordMessage", SFSBaseMessage)
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
  DataCenter.LWTowerUpStageManager:UpdateData(message)
  if message.idleRewardStageId and message.lastIdleRewardTimeStamp then
    DataCenter.StageManager:UpdateHangUpReward(message.lastIdleRewardTimeStamp, message.idleRewardStageId)
  end
  local stageId = message.id
  local meta = DataCenter.TowerUpTemplateManager:GetTowerUpUnlockTemplate(stageId)
  if meta ~= nil and meta.type == TowerupBattleType.FakePVP then
    if message.contentsArr or message.content then
      EventManager:GetInstance():Broadcast(EventId.TowerupFakePVPBattleDataGet, message)
    else
      EventManager:GetInstance():Broadcast(EventId.JeepAdventureFastSweep, message)
    end
  end
end

LWSaveTowerupRecordMessage.OnCreate = OnCreate
LWSaveTowerupRecordMessage.HandleMessage = HandleMessage
return LWSaveTowerupRecordMessage
